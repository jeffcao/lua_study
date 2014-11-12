require "game_config"
require "game_text"
require 'game_const'

module ResultCode

  include GameConfig
  include GameText
  include GameConst

  #更新个人资料
  UPDATE_USER_PROFILE_FAIL = 203
  #retry设定值
  CONNECTION_RETRY_BEGIN = "0"
  #retry 设定值
  REDIS_KEY_VALUE_LOST = 300
  #完善资料失败

  #用户没又可用的道具
  PROP_IS_NULL = 400

  #用户桌子上的状态
  USER_TABLE_READY = 1
  USER_TABLE_LEFT = 0
  ROBOT = 1 #托管

  PLAYER_READY_TIMEOUT = 33   #准备超时后自动准备
  RESTORE_CONNECTION_TIMEOUT = 300
  GAME_OVER_RETURN_GAME_TIMEOUT = 35

  FORCE_SIGN_OUT_REDIS_EVENT = "f_sign_out_event"

  #NOT_FRIEND = 500
  FREE_TYPE = "12"

  TIMING_BUY_PROP = 60

  RESET_PASSWORD_FAIL = 201
  SYSTEM_MESSAGE_NULL = 502
  USER_ALREADY_JOIN = 503
  GAME_MATCH_IS_NULL = 504
  USER_HAVE_NOT_ENOUGH_MOBILE = 505
  USER_HAVE_NO_MOBILE = 509
  ANZHI_KEY = 123
  ANZHUI_APP_SECRET = "ABC"
  USER_GET_MOBILE_CHARGE = 20
  #local imsi = user_default:getStringForKey("hw_imsi")
  #imsi以46000/46002/46007开头的是移动卡。
  CMCC_APPID = 1003
  CMCC_APPID_A = 1000
  CMCC_VERSION = "2.0"


  SERVER_CONNECTIONS_COUNT_KEY = "hall_server_connections_key"
end