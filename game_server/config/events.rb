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
  # config.redis_options = {:host => 'localhost', :port => '6800'}
  config.redis_options = DDZRedis.syn_option
end

WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
  namespace :test do
    subscribe :sign_in, :to => GameTestController, :with_method => :sign_in
    subscribe :say_hello, :to => GameTestController, :with_method => :say_hello
  end

  namespace :g  do

    subscribe :enter_room, :to => GameController, :with_method => :enter_room
    subscribe :check_connection, :to => GameController, :with_method => :check_connection
    subscribe :ready_game,  :to => GameController, :with_method => :player_ready
    subscribe :grab_lord,  :to => GameController, :with_method => :on_grab_lord
    subscribe :play_card, :to => GameController, :with_method => :play_card
    subscribe :restore_connection, :to => GameController, :with_method => :restore_connection
    subscribe :restore_game, :to => GameController, :with_method => :restore_game
    subscribe :get_rival_msg, :to => GameController, :with_method => :get_rival_msg
    subscribe :leave_game, :to => GameController, :with_method => :player_leave_game
    subscribe :on_tuo_guan, :to => GameController, :with_method => :turn_on_guan
    subscribe :off_tuo_guan, :to => GameController, :with_method => :cancel_tuo_guan
    subscribe :user_change_table, :to => GameController, :with_method => :player_change_game_table
    subscribe :player_timeout, :to => GameController, :with_method => :player_timeout
    subscribe :user_score_list, :to => GameController, :with_method => :user_score_list
    subscribe :dialogue_count, :to => GameController, :with_method => :dialogue_count
    subscribe :chat_in_playing, :to => GameController, :with_method => :chat_in_playing
    subscribe :buy_prop,  :to => GameController, :with_method => :buy_prop  #商城购买道具
    subscribe :timing_buy_prop, :to => GameController, :with_method => :timing_buy_prop  #计时用户
    subscribe :use_cate, :to => GameController, :with_method => :use_cate        #个人使用道具
    subscribe :mobile_charge_list, :to => GameController, :with_method => :mobile_charge_list        #话费排行榜
    subscribe :get_mobile_charge, :to => GameController, :with_method => :get_mobile_charge        #获取电话费

  end

  subscribe :client_error, :to => GameController, :with_method => :on_client_error
  subscribe :client_disconnected, :to => GameController, :with_method => :on_client_disconnected
  subscribe :client_connected, :to => GameController, :with_method => :on_client_connected

end
