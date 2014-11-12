require "result_code"
require "game_security/client_verify"
require "logic/synchronization"

class BaseController < WebsocketRails::BaseController
  def on_client_disconnected
    logger.debug("[on_client_disconnected")
    #logger.error "[on_client_disconnected] #{event.connection} got msg: " + (message.blank? ?  "empty" : message.inspect)
  end

  def on_client_error
    logger.debug("[on_client_error")
    #logger.error "[on_client_error] #{event.connection} got error: " + (message.blank? ?  "empty" : message.inspect)
  end

  def client_run_evn
    connection_store["client_run_evn"]
  end

  def client_app_id
    connection_store["client_app_id"]
  end

  def execute_observers(event)
    logger.debug("[execute_observers=>#{event.to_json}]")
    if event.to_s == "check_connection" or event.to_s == "restore_connection" or event.to_s == "client_connected" or
      event.to_s == "client_disconnected" or event.to_s == "client_error"
      logger.debug("[execute_observers=>true]")
      true
    else
      if connection_store["authorized"].nil? or connection_store["authorized"] == false
        logger.debug("[execute_observers=>false]")
        return false
      else
        logger.debug("[execute_observers=>true]")
      end
    end
  end

  def restore_connection
    logger.debug("[controller.restore_connection] user_id=>#{message[:user_id].to_s}]")
    user_id = message[:user_id].to_s
    run_env = message[:run_env].to_s
    client_app_id = message[:app_id].to_s
    Rails.logger.debug("[restore_connection] false , user_id=>#{user_id.to_s}, process_id=>#{Process.pid.to_s}")
    Rails.logger.debug("[restore_connection], client_run_evn=>#{run_env}")
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
      logger.debug("[restore_connection]=>#{message[:token]}")
      connection_store["authorized"] = true
      trigger_success()
      return true
    end
    logger.debug("[restore_connection]=>false")
    connection_store["authorized"] = false
    trigger_failure()
  end

  def check_connection
    key = "msg_server_" + message[:user_id].to_s
    user_id = message[:user_id].to_s
    run_env = message[:run_env].to_s
    client_app_id = message[:app_id].to_s
    connection_store["client_app_id"] = client_app_id
    connection_store["client_run_evn"] = run_env
    Rails.logger.debug("[check_connection], client_run_evn=>#{run_env}")

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

    connection_store[key] = 0
    if Redis.current.exists(message[:token])
      logger.debug("[check_connection]=>#{message[:token]}")

      connection_store["authorized"] = true
      trigger_success()
      return true
    end
    logger.debug("[check_connection]=>false")
    connection_store["authorized"] = false
    trigger_failure()
  end

  def on_client_connected
      characteristic_code = ClientVerify.produce_verify_info(connection.id)
      logger.info("[on_client_connected] characteristic_code=>#{characteristic_code}")
      e_data = {v_code: characteristic_code}
      options = {connection: connection, data: e_data }

      hs_en =  WebsocketRails::Event.new("ui.hand_shake", options)
      hs_en.trigger

      logger.info("[on_client_connected] trigger ui.hand_shake")
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

  def self.trigger_match_notify(notify_name, notify_data, channel_name)
    WebsocketRails[channel_name].trigger(notify_name, notify_data)
    Rails.logger.debug("[trigger_match_notify] channel=>#{channel_name}, #{notify_name}, data=> #{notify_data.to_json}")
    #}
  end
end




