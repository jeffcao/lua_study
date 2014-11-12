require "game_config"
require "game_text"
require 'game_const'

module ResultCode
  include GameConfig
  include GameText
  include GameConst

  #用户没又可用的道具
  PROP_IS_NULL = 400

  #用户桌子上的状态
  USER_TABLE_READY = 1
  USER_TABLE_LEFT = 0
  ROBOT = 1 #托管

  PLAYER_READY_TIMEOUT = 22   #准备超时后自动准备
  RESTORE_CONNECTION_TIMEOUT = 300
  GAME_OVER_RETURN_GAME_TIMEOUT = 29

  GRAB_LORD_TIMEOUT = 32
  PLAY_CARD_TIMEOUT = 18

  ADD_ROBOT_TIMEOUT_LEVEl = [2, 5, 15, 20]

  KICKS_PLAYER_TIMEOUT = 10



  DEFAULT_ROOM_RUL = "192.168.0.240:4000"
  FORCE_SIGN_OUT_REDIS_EVENT = "f_sign_out_event"
  PAGE_SIZE = 10

  #NOT_FRIEND = 500
  #NOT_FRIEND = 500

  TIMING_BUY_PROP = 60
  MOBILE = "07556467902"

  #retry设定值
  CONNECTION_RETRY_BEGIN = "0"

  #retry 设定值
  REDIS_KEY_VALUE_LOST = 300
  USER_HAVE_NOT_ENOUGH_MOBILE = 505
  PUSH_PROP_ON_GAMING_FOR_BEANS = 10000

  SERVER_CONNECTIONS_COUNT_KEY = "game_connections_count_key"

end