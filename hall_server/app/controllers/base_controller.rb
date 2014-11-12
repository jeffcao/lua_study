require "result_code"
require "logic/synchronization"
class BaseController < WebsocketRails::BaseController

  @@connections = {}


  def initialize
    Rails.logger.debug("[BaseController.initialize]")
    unless DdzHallServer::Synchronization.synchronizing?
      Rails.logger.debug("[BaseController.initialize synchronizing? is false]")
      Fiber.new {
        DdzHallServer::Synchronization.synchronize!
        EM.add_shutdown_hook { DdzHallServer::Synchronization.shutdown! }
      }.resume
    end
  end

  def self.connections
    return @@connections
  end

  def redis_key_pro(user_id, event_id)
    key = "#{user_id.to_s}_#{event_id.to_s}"
    key
  end

  def self.connection_exist?(user_id)

    if @@connections[user_id.to_s].nil?
      Rails.logger.debug("[connection_exist?] false, user_id=>#{user_id.to_s}, process_id=>#{Process.pid.to_s}")
      dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
      Rails.logger.debug("[connection_exist?] @@connections_k_v=>" + dump_str)
      false
    else
      Rails.logger.debug("[connection_exist?] true , user_id=>"+user_id.to_s)
      true
    end
  end

  def get_user(id)
    logger.debug("get_user_id=>#{id}")
    unless id.nil?
      User.find_by_user_id(id)
    end
  end

  def redis_key_value(key, value)

    Redis.current.set "#{key}", "#{value}"
    Redis.current.expire(key, ResultCode::REDIS_KEY_VALUE_LOST)

  end

  def set_current_table_id(table_id)
    connection_store[:current_table] = table_id
  end

  def current_table_id
    connection_store[:current_table]
  end

  def set_channel_name(name)
    connection_store[:channel_name] = name
  end

  def set_current_user(user_id)
    connection_store[:this_user] = user_id
  end

  def channel_name
    connection_store[:channel_name]
  end

  def current_user_id
    connection_store[:this_user]
  end

  def client_run_evn
    connection_store["client_run_evn"]
  end

  def client_app_id
    connection_store["client_app_id"]
  end

  def increase_room_online_count(room_id)
    key = redis_key_pro(room_id.to_s, ResultCode::ROOM_ONLINE_COUNT_KEY_SUFFIX)
    Redis.current.incr(key)
  end

  def decrease_room_online_count(room_id)
    key = redis_key_pro(room_id.to_s, ResultCode::ROOM_ONLINE_COUNT_KEY_SUFFIX)
    Redis.current.decr(key)
  end

  def get_room_online_count(room_id)
    key = redis_key_pro(room_id.to_s, ResultCode::ROOM_ONLINE_COUNT_KEY_SUFFIX)
    count = Redis.current.get(key)
    count = 0 if count.nil?
    count.to_i
  end

  #def client_run_evn
  #  connection_store["client_run_evn"]
  #end

  def check_connection
    key = "hall_" + message[:user_id].to_s
    ad_id = "ad_" + message[:user_id].to_s
    user_id = message[:user_id].to_s
    run_env = message[:run_env].to_s
    client_app_id = message[:app_id].to_s
    connection_store["client_run_evn"] = run_env
    connection_store["client_app_id"] = client_app_id
    Rails.logger.debug("[check_connection], client_run_evn=>#{run_env}")
    discard_version = SystemSetting.find_by_setting_name("discard_version").reload(:lock => true)
    discard_version = discard_version.setting_value unless discard_version.nil?
    logger.info("[sign_in_discard_version=>#{discard_version}")
    version = message[:version]
    if version.nil?
      version = User.find_by_user_id(message[:user_id]).version
    end
    logger.info("[sign_in_version=>#{version}")

    s_name = message[:s_name]
    s_token = message[:s_token]
    if version.to_s > discard_version
      unless verify_client(s_name, s_token)
        return
      end
    end

    connection_store[key] = 0
    if Redis.current.exists(message[:token])
      logger.debug("[check_connection]=>#{message[:token]}")
      #time, key = UserOnlineTime.set_user_redis(user_id)
      #Rails.logger.debug("[check_connection], time=>#{time}")
      #if Redis.current.get("#{user_id}_online_count").to_i <= 9
      #  UserOnlineTime.user_online_time(user_id, time, key)
      #  Rails.logger.debug("[check_connection] true, user_id=>#{user_id.to_s}, process_id=>#{Process.pid.to_s}")
      #  UserOnlineTime.subscribe_user_online_time
      #end
      set_player_connection_info(user_id)
      connection_store[ad_id] = 0
      connection_store["authorized"] = true
      trigger_success()
      return true
    end
    logger.debug("[check_connection]=>false")
    connection_store["authorized"] = false
    trigger_failure()
  end

  def set_player_connection_info(user_id)
    logger.debug("[set_player_connection_info] user_id=>#{user_id}")

    dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
    Rails.logger.debug("[connection_exist?] @@connections_k_v=>" + dump_str)
    @@connections[user_id] = connection
    connection_store["current_user_id"] = user_id

    dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
    Rails.logger.debug("[connection_exist?] @@connections_k_v=>" + dump_str)
    #logger.debug("[set_player_connection_info], @@connections=>#{@@connections.to_json}")
  end


  def execute_observers(event)
    logger.debug("[execute_observers=>#{event.to_json}]")
    if event.to_s == "check_connection" or event.to_s == "restore_connection" or event.to_s == "client_connected"
      logger.debug("[execute_observers=>true]")
      return true
    else
      if connection_store["authorized"].nil? or connection_store["authorized"] == false
        logger.debug("[execute_observers=>false]")
        return false
      else
        logger.debug("[execute_observers=>true]")
        user_id = connection_store["current_user_id"].to_s
        set_player_connection_info(user_id) unless user_id.blank?
      end
    end
  end

  def restore_connection
    logger.debug("[controller.restore_connection] user_id=>#{message[:user_id].to_s}]")
    user_id = message[:user_id].to_s
    run_env = message[:run_env].to_s
    client_app_id = message[:app_id].to_s

    Rails.logger.debug("[connection_exist?] false , user_id=>#{user_id.to_s}, process_id=>#{Process.pid.to_s}")
    Rails.logger.debug("[check_connection], client_run_evn=>#{run_env}")
    connection_store["client_run_evn"] = run_env
    connection_store["client_app_id"] = client_app_id

    s_name = message[:s_name]
    s_token = message[:s_token]

    discard_version = SystemSetting.find_by_setting_name("discard_version").reload(:lock => true)
    discard_version = discard_version.setting_value unless discard_version.nil?
    version = User.find_by_user_id(message[:user_id]).user_profile.version
    if version.to_s > discard_version.to_s
      unless verify_client(s_name, s_token)
        return
      end
    end

    if Redis.current.exists(message[:token])
      logger.debug("[check_connection]=>#{message[:token]}")
      set_player_connection_info(user_id)
      connection_store["authorized"] = true
      trigger_success()
      return true
    end
    logger.debug("[check_connection]=>false")
    connection_store["authorized"] = false
    trigger_failure()
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

  def get_notify_id(user_id)
    key = "hall_" + user_id.to_s
    connection_store[key] = connection_store[key].to_i + 1
    connection_store[key]
  end

  def on_client_disconnected
    logger.debug("[on_client_disconnected] current_user_id=>"+connection_store["current_user_id"].to_s)
    user_id = connection_store["current_user_id"].to_s
    key = "user_online_time_#{user_id}"

    unless user_id.nil?
      online_time = Time.now.to_i - Redis.current.get(key).to_i
      UserSheet.count_user_online_time(online_time)
      #Redis.current.del(key)
    end

    logger.debug("[controller.on_client_disconnected] connections exist. ") unless  @@connections[user_id].nil?
    @@connections.delete(user_id)
    logger.debug("[controller.on_client_disconnected] connections deleted") if @@connections[user_id].nil?
    #p_channel_name =  "#{user_id}_hall_channel"
    WebsocketRails.channel_manager.unsubscribe(connection)
    # Redis.current.decr(ResultCode::HALL_SERVER_CONNECTIONS_COUNT_KEY)
    logger.debug("[controller.on_client_disconnected] unsubscribe all channels")
    #logger.debug("[on_client_disconnected], @@connections=>#{@@connections.to_json}")
  end

  def on_client_connected
    # Redis.current.incr(ResultCode::HALL_SERVER_CONNECTIONS_COUNT_KEY)
    Redis.current.incr(ResultCode::HALL_SERVER_CONNECTIONS_COUNT_KEY)
    characteristic_code = ClientVerify.produce_verify_info(connection.id)
    logger.info("[on_client_connected] characteristic_code=>#{characteristic_code}")
    e_data = {v_code: characteristic_code}
    options = {connection: connection, data: e_data }

    hs_en =  WebsocketRails::Event.new("ui.hand_shake", options)
    hs_en.trigger

    logger.info("[on_client_connected] trigger ui.hand_shake")
  end

  def get_server_rul
    url_str = "http://localhost:5001"
    sms_simulator = SystemSetting.find_by_setting_name("ddz_simulator_url")

    url_str = sms_simulator.setting_value unless sms_simulator.nil?
    url_str
  end

  def get_charge_server_rul
    url_str = "http://localhost:5001"
    hall_server = SystemSetting.find_by_setting_name("ddz_charge_server_url")

    url_str = hall_server.setting_value unless hall_server.nil?
    url_str
  end

  def get_unicom_server_url
    url_str = "http://localhost:5001"
    unicom_url = SystemSetting.find_by_setting_name("unicom_pay_server_url")
    url_str = unicom_url.setting_value unless unicom_url.nil?
    url_str

  end


  def nick_name(nick_name)
    r =nil
    words = BanWord.all
    words.each do |word|
      r = nick_name.match(word.zz_word)
      unless r.nil?
        break
      end
    end
    r
  end

  def self.get_new_notify_id
    key = "hall_notify_id"
    notify_id = Redis.current.incr(key)
  end

end




