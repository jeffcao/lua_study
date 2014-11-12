#encoding: utf-8
module GameText
  CLIENT_VERIFY_FAILED_TEXT = "未认证的客户端"
  MOBILE_CHARGES = "恭喜您获得10元话费,您可以在话费榜中领取."
  TWO_PRIZE = "恭喜您获得了300000豆子,手气不错哦."
  THREE_PRIZE = "恭喜您获得了一个记牌器,物有所值,再接再厉!"
  CONSOLATION_PRIZE = "获得了安慰奖50000豆子,胜不骄败不馁!"
  PUBLISH_TIGER_CHARGES_MSG = "喜气洋洋,xxx摇奖摇出了10元话费奖励"
  PUBLISH_TIGER_TWO_PRIZE_MSG = "喜气洋洋,xxx摇奖摇出了300000豆子奖励"
  PUBLISH_TIGER_THREE_PRIZE_MSG = "喜气洋洋,xxx摇奖摇出了1个记牌器奖励"
  GAME_OVER_PUSH_SHUANGBEIJIFENKA = "财神驾到，豆子翻翻！"
  GAME_OVER_PUSH_JIPAIQI = "速记好帮手！"
  GAME_OVER_PUSH_HUSHENKA = "为您的豆子保驾护航！"
  GAME_BEGIN_PUSH_SHUANGBEIJIFENKA = "今天手气不错哦，要不要试试加倍呢？"
  MATCH_START_NOTIFY_CONTENT = "比赛开始了，快来赢豆子吧!"
  MATCH_START_NOTIFY_TITLE = "比赛开始了"
  MATCH_END_NOTIFY_CONTENT = "本场比赛已经结束!"
  MATCH_END_NOTIFY_TITLE = "比赛结束了"
  ROOM_MAINTENANCE = "房间维护中，请选择其它游戏房间进入"
  ROOM_IS_FULL = "房间已经满员，请选择其它游戏房间游戏"
  BEANS_IS_NOT_ENOUGH = "您的豆子不足，请前往商城购买"
  ROOM_IS_NOT_ENTRY = "此房间暂时不能进入"
  GAME_MATCH_TEXT_ONE = '\b\b\b\b\b\b\b\b敬爱的玩家\b\bnick_name，恭喜您在room_name的《match_name》活动中获得：'
  DP_AWARD_MSG = '第i名\b\b\b\baward'
  GET_MOBILE_LOG = "在[送话费房]比赛中获得第i名获得了n元话费，恭喜您"
  GET_BEANS_LOG = "在[送豆房]比赛中获得第i名获得了n豆子，恭喜您"
  GET_CHARGE_TEXT = "恭喜您领取了n元话费，五个工作日内将充值到您的手机"
  #base_mobile = MatchSystemSetting.first.mobile_charge unless MatchSystemSetting.first.nil?
  #base_mobile = base_mobile.nil? ? 20 : base_mobile
  GET_CHARGE_FAIL = "您目前账户剩额不足money元，请下次领取"
  ERR_MOBILE= "您输入的电话号码有误,请从新输入11位的电话号码"
  BUY_FAILD_OVER_CREDIT=" 对不起，购买失败，详情请联系客服.\n联系电话:"
  SIGN_UP_GET_CHARGE = "注册成功！您已获得5元话费"
  SHOUCHONGLIBAO_SUCCESS="您已经获得350000豆子、5元话费和7*24小时记牌器。"
end