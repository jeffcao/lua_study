class GameBaseController < WebsocketRails::BaseController
  #include WebsocketRails::Logging
  #include WebsocketRails::DataStore
  @@connections = {}

  def initialize
    #unless DdzGameServer::Synchronization.synchronizing?
    #  Fiber.new {
    #    DdzGameServer::Synchronization.synchronize!
    #    EM.add_shutdown_hook { DdzGameServer::Synchronization.shutdown! }
    #  }.resume
    #end
  end

  def self.connections
    return @@connections
  end

  def self.trigger_game_notify(notify_name, notify_data, user_id, table_info)
    room_table_id = "#{table_info.room_id}_#{table_info.table_id}"
    notify_id = get_new_notify_id(room_table_id)
    channel_name = table_info.channel_name
    notify_data["notify_id"] = notify_id
    #logger.debug("[trigger_game_notify] notify_name =>#{notify_name}")
    #EM.next_tick {
    #logger.debug("[trigger_game_notify] notify_data =>#{notify_data.to_json}")
    WebsocketRails[channel_name].trigger(notify_name, notify_data)
    record_server_notify(user_id, table_info.game_id, notify_id, notify_name, notify_data)
    Rails.logger.debug("[trigger_game_notify] channel=>#{channel_name}, #{notify_name}, data=> #{notify_data.to_json}")
    #}
  end

  def self.trigger_prop_notify(notify_name, notify_data, user_id, table_info)
    room_table_id = "#{table_info.room_id}_#{table_info.table_id}"
    notify_id = get_new_notify_id(room_table_id)
    #channel_name = table_info.channel_name
    channel_name = "channel_#{user_id}"
    notify_data["notify_id"] = notify_id
    WebsocketRails[channel_name].trigger(notify_name, notify_data)
    Rails.logger.debug("[trigger_game_notify] channel=>#{channel_name}, #{notify_name}, data=> #{notify_data.to_json}")
  end


  def self.trigger_personal_game_notify(user_id, notify_name, notify_data, table_info)
    room_table_id = "#{table_info.room_id}_#{table_info.table_id}"
    channel_name = "channel_#{user_id}"
    notify_id = get_new_notify_id(room_table_id)
    notify_data["notify_id"] = notify_id
    #EM.next_tick {
    WebsocketRails[channel_name].trigger(notify_name, notify_data)
    record_server_notify(user_id, table_info.game_id, notify_id, notify_name, notify_data)
    Rails.logger.debug("[trigger_personal_game_notify] channel=>#{channel_name}, #{notify_name}, data=> #{notify_data.to_json}")
    #}
  end

  def self.unsubscribe_channel(user_id, channel_name)
    unless  @@connections[user_id.to_s].nil?
      WebsocketRails[channel_name].unsubscribe(@@connections[user_id.to_s])
    end
  end


  #def trigger_event_to_own(event_name, event_data)
  #  event = WebsocketRails::Event.new(event_name, {:data => event_data})
  #  self.connection.dispatcher.send(:dispatch, event)
  #  logger.debug("[trigger_event_to_own] event_name=> #{event_name}, data=> #{event_data.to_json}")
  #end

  def self.set_current_timer(user_id, timer)
    if @@connections[user_id.to_s].nil?
      Rails.logger.debug("[set_current_timer] connection is nil, user_id=>#{user_id}")
      return
    end
    if   @@connections[user_id.to_s].data_store["current_timer"].blank?
      @@connections[user_id.to_s].data_store["current_timer"] = {}
    end
    @@connections[user_id.to_s].data_store["current_timer"][user_id.to_s] = timer
  end

  def self.current_timer(user_id)
    if connection_exist?(user_id.to_s) and !@@connections[user_id.to_s].data_store["current_timer"].nil?
      @@connections[user_id.to_s].data_store["current_timer"][user_id.to_s]
    else
      nil
    end
  end

  def self.set_player_voice_timer(user_id, timer)
    if @@connections[user_id.to_s].nil?
      Rails.logger.debug("[set_current_timer] connection is nil, user_id=>#{user_id}")
      return
    end
    key = "#{user_id}_#{ResultCode::PLAYER_VOICE_TIMER_KEY_SUFFIX}"
    if   @@connections[user_id.to_s].data_store["current_timer"].blank?
      @@connections[user_id.to_s].data_store["current_timer"] = {}
    end
    @@connections[user_id.to_s].data_store["current_timer"][key] = timer
  end

  def self.current_voice_timer(user_id)
    key = "#{user_id}_#{ResultCode::PLAYER_VOICE_TIMER_KEY_SUFFIX}"
    if connection_exist?(user_id.to_s) and !@@connections[user_id.to_s].data_store["current_timer"].nil?
      @@connections[user_id.to_s].data_store["current_timer"][key]
    else
      nil
    end
  end

  def self.record_server_notify(user_id, game_id, notify_id, notify_name, notify_data)

    key = "server_notify_#{game_id}"

    notify = {:notify_id => notify_id, :user_id => user_id, :notify_name => notify_name, :notify_data => notify_data}

    Redis.current.lpush(key, notify.to_json)
  end

  def self.get_server_notifies(game_id)
    key = "server_notify_#{game_id}"
    Redis.current.lrange(key, 0, -1)
  end

  def self.get_new_notify_id(room_table_id)
    key = "server_notify_id_#{room_table_id}"
    notify_id = Redis.current.incr(key)
  end


  def self.game_trigger_success(data, event)
    event.success = true
    event.data = data
    event.trigger
    Rails.logger.debug("[game_trigger_success] event =>"+event.serialize)
  end

  def self.game_trigger_failure(data, event)
    event.success = false
    event.data = data
    event.trigger
  end

  def self.connection_exist?(user_id)
    if @@connections[user_id.to_s].nil?
      Rails.logger.debug("[connection_exist?] false , user_id=>#{user_id.to_s}, process_id=>#{Process.pid.to_s}")
      dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
      Rails.logger.debug("[connection_exist?] @@connections_k_v=>" + dump_str)

      false
    else
      Rails.logger.debug("[connection_exist?] true , user_id=>"+user_id.to_s)
      true
    end
  end

  def current_user_id
    connection_store["current_user_id"]
  end

  def client_run_evn
    connection_store["client_run_evn"]
  end

  def client_app_id
    connection_store["client_app_id"]
  end

  def authenticate (user_id, token)

    Rails.logger.debug("[authenticate] user_id=>#{user_id}")

    unless Redis.current.exists(token)
      connection_store["authentication"] = false
    else
      user_info = Redis.current.hgetall(token)
      Rails.logger.debug("[authenticate]_user_id=>#{user_info["user_id"]}")
      if user_info["user_id"].to_s == user_id.to_s
        connection_store["authentication"] = true
      else
        connection_store["authentication"] = false
      end
    end
  end

  def check_connection
    run_env = message[:run_env].to_s
    connection_store["client_run_evn"] = run_env
    client_app_id = message[:app_id].to_s
    connection_store["client_app_id"] = client_app_id

    Rails.logger.debug("[check_connection]_message_user_id: #{message["user_id"].to_s}")
    Rails.logger.debug("[check_connection] process_id => #{Process.pid.to_s}")

    s_name = message[:s_name]
    s_token = message[:s_token]

    version = message[:version]
    if version.nil?
      version = User.find_by_user_id(message[:user_id]).version
    end
    logger.info("[sign_in_version=>#{version}")

    discard_version = SystemSetting.find_by_setting_name("discard_version").reload(:lock => true)
    discard_version = discard_version.setting_value unless discard_version.nil?
    if version.to_s > discard_version.to_s
      unless verify_client(s_name, s_token)
        return
      end
    end

    authenticate(message["user_id"], message["token"])
    user_id = message["user_id"].to_s
    if connection_store["authentication"]
      unless @@connections["#{user_id}"].nil? or @@connections["#{user_id}"].data_store.nil? or @@connections["#{user_id}"].data_store["current_timer"].nil?
        Rails.logger.debug("[check_connection] user have two connections")
        timer = @@connections["#{user_id}"].data_store["current_timer"]["#{user_id}"]
        Rails.logger.debug("[check_connection] user have two timer")
        timer.cancel unless timer.nil?
      end
      set_player_connection_info(user_id)
      dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
      Rails.logger.debug("[check_connection] @@connections_k_v=>" + dump_str)
      trigger_success()
      true
    else
      trigger_failure()
      false
    end
  end

  def verify_client(s_name, s_token)
    unless ClientVerify.verify_client(s_name, s_token, connection.id, client_app_id)
      check_result = ResultCode::CLIENT_VERIFY_FAILED
      result_msg = ResultCode::CLIENT_VERIFY_FAILED_TEXT
      trigger_failure({:result_code => check_result, :result_message => result_msg})
      connection.on_error({connection_closed: true, error: "Invalidate client: #{self}"})
      false
    end
    true
  end

  def set_player_connection_info(user_id)
    @@connections[user_id] = connection
    connection_store["current_user_id"] = user_id

    Rails.logger.debug("[set_player_connection_info]_current_user_id: #{connection_store["current_user_id"]}")
    Rails.logger.debug("[set_player_connection_info] user_id: #{user_id}")
    player_connection = PlayerConnectionInfo.from_redis(user_id.to_s)

    if player_connection.nil?
      player_connection = PlayerConnectionInfo.new
      player_connection.user_id = user_id
      player_connection.connections = []
    end
    player_connection.game_server_id = Process.pid.to_s
    player_connection.connections.push({connection_id: connection.id.to_s, begin_time: Time.now.to_i})
    if player_connection.connections.size > 2
      player_connection.connections.delete_at(0)
    end
    player_connection.save
    Rails.logger.debug("[set_player_connection_info] player_connection: #{player_connection.to_json}")
  end


  def execute_observers(event_name)
    if event_name.to_s == "check_connection" or event_name.to_s == "restore_connection" or event_name.to_s == "client_connected"
      true
    elsif connection_store["authentication"].nil? or connection_store["authentication"] == false
      false
    else
      Rails.logger.debug("execute_observers, [#{event_name}] process_id =>#{Process.pid.to_s}, user_id =>#{connection_store["current_user_id"].to_s}")
      true
    end
  end

  def get_server_rul
    url_str = "http://localhost:5001"
    sms_simulator = SystemSetting.find_by_setting_name("ddz_simulator_url")

    url_str = sms_simulator.setting_value unless sms_simulator.nil?
    url_str
  end
end