#encoding: utf-8

class MessageController < BaseController
  # To change this template use File | Settings | File Templates.

  def get_sys_msg
    # 从游戏发送队列获取 消息时间戳 从 (now - 10m) 到 now 的所有记录
    # 包括 各种获奖公告， 后台维护的公告
    s_name = message[:s_name]
    s_token = message[:s_token]

    user_id = message[:user_id]
    last_msg_seq = message[:last_msg_seq]
    logger.info("[MessageController.get_sys_msg], user_id=>#{user_id}, last_msg_seq=>#{last_msg_seq}")
    if user_id.nil?
      trigger_failure({:result_code => ResultCode::PROP_IS_NULL, :result_message=>"参数为空错误:user_id"})
      return
    end
    player = Player.get_player(user_id)
    if player.nil?
      trigger_failure({:result_code => ResultCode::PROP_IS_NULL, :result_message=>"找不到指定的玩家信息"})
      return
    end
    result = MessageLogic.get_public_notify(user_id.to_i, last_msg_seq.to_i, player)
    trigger_success(result)
  end
end