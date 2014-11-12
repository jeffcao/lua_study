require 'logic/message_logic'

class MessageServerController < ApplicationController

  def test
    logger.info("[MessageServerController.test]")
    render :text => '0', :content_type => 'application/text'
    logger.info("[MessageServerController.test]")
  end

  def get_notification_msg
    # 从游戏任务消息发关队列获取
    logger.info("[get_notification_msg] params => #{params.to_json}")
    user_id =  params["user_id"]
    last_msg_seq = params["last_msg_seq"]
    result = MessageLogic.get_device_notify(user_id.to_i, last_msg_seq.to_i)
    logger.debug("[get_notification_msg] result => #{result.to_json}")
    render :json => result

  end
end