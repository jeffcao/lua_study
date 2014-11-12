module WebsocketRails
  class Configuration
    def ping_period
      @ping_period ||= 10
    end

    def ping_period=(value)
      @ping_period = value
    end
  end
end
WebsocketRails.setup do |config|

  # Uncomment to override the default log level. The log level can be
  # any of the standard Logger log levels. By default it will mirror the
  # current Rails environment log level.
  config.log_level = :debug

  config.ping_period = 30
  # Uncomment to change the default log file path.
  # config.log_path = "#{Rails.root}/log/websocket_rails.log"
  
  # Set to true if you wish to log the internal websocket_rails events
  # such as the keepalive `websocket_rails.ping` event.
  config.log_internal_events = true

  # Change to true to enable standalone server mode
  # Start the standalone server with rake websocket_rails:start_server
  # * Requires Redis
  config.standalone = false

  # Change to true to enable channel synchronization between
  # multiple server instances.
  # * Requires Redis.
  config.synchronize = true

  # Uncomment and edit to point to a different redis instance.
  # Will not be used unless standalone or synchronization mode
  # is enabled.
  # config.redis_options = {:host => 'localhost', :port => '6379'}
  config.redis_options = DDZRedis.syn_option
end

WebsocketRails::EventMap.describe do
  namespace :ui do
    subscribe :request_enter_room, :to => GameHallController, :with_method => :request_enter_room
    subscribe :fast_begin_game, :to => GameHallController, :with_method => :fast_request_enter_room
    subscribe :feedback, :to => GameHallController, :with_method => :feedback   #用户反馈
    subscribe :check_connection,  :to => GameHallController, :with_method => :check_connection   #判断用户合法不
    subscribe :restore_connection,  :to => GameHallController, :with_method => :restore_connection   #断线重链接
    subscribe :get_room,  :to => GameHallController, :with_method => :get_room   #获取房间列表
    subscribe :cate_list, :to => PropController, :with_method => :user_prop_list      #个人道具列表
    subscribe :use_cate, :to => PropController, :with_method => :use_cate        #个人使用道具
    subscribe :shop_prop_list,  :to => GameShopPropController, :with_method => :shop_prop_list  #商场道具列表
    subscribe :buy_prop,  :to => GameShopPropController, :with_method => :buy_prop  #商城购买道具
    subscribe :reset_password, :to => UserProfileController, :with_method => :reset_password   #用户重新设置密码
    subscribe :complete_user_info, :to => UserProfileController, :with_method => :complete_user_info  #用户完善各自资料
    subscribe :sign_out, :to => GameHallController, :with_method => :sign_out  #用户退出游戏
    subscribe :get_user_profile, :to => UserProfileController, :with_method => :get_user_profile  #用户退出游戏
    subscribe :online_time_get_beans, :to => GameHallController, :with_method => :user_online_time_get_beans  #在线时间获取豆子
    subscribe :share_weibo, :to => GameHallController, :with_method => :share_weibo  #分享微博
    subscribe :get_activity, :to => GameHallController, :with_method => :get_day_activity  #获取当日活动
    subscribe :prepare_sign_out, :to => GameHallController, :with_method => :prepare_sign_out
    subscribe :get_salary, :to => GameHallController, :with_method => :get_salary    #领取工资
    subscribe :ui_visit_count, :to => GameHallController, :with_method => :ui_visit_count    #界面切换时间
    subscribe :get_system_message, :to => GameHallController, :with_method => :get_system_message    #获取系统消息
    subscribe :get_match_list , :to => GameHallController, :with_method => :get_match_list     #获取活动接口
    subscribe :mobile_charge_list , :to => GameHallController, :with_method => :mobile_charge_list     #话费排行榜
    subscribe :user_score_list , :to => GameHallController, :with_method => :user_score_list     #豆子排行榜
    subscribe :get_mobile_charge , :to => GameHallController, :with_method => :get_mobile_charge     #获取话费
    subscribe :join_match , :to => GameHallController, :with_method => :join_match     #报名
    subscribe :slot_machine , :to => GameHallController, :with_method => :slot_machine     #老虎机
    subscribe :game_match_log , :to => GameHallController, :with_method => :game_match_log     #获奖记录
    subscribe :cancel_buy_prop, :to => GameShopPropController, :with_method => :cancel_buy_prop  #取消购买
    subscribe :get_room_match_list, :to=> GameHallController, :with_method => :get_room_match_list     #获取指定房间当天的比赛列表
  end

  subscribe :client_error, :to => GameHallController, :with_method => :on_client_error
  subscribe :client_disconnected, :to => BaseController, :with_method => :on_client_disconnected
  subscribe :client_connected, :to => BaseController, :with_method => :on_client_connected
end
