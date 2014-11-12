#require 'em-http-request'
#require 'em-synchrony/em-http'
class GameController < GameBaseController
  include BuyPropHelper
  include PropHelper
  include MobileChargeHelper

  def enter_room
    logger.debug("[controller.enter_room] user_id=>"+message["user_id"].to_s)
    @@connections[message["user_id"].to_s] = connection
    GameLogic.on_player_enter_game(message["user_id"].to_s, message["room_id"].to_s, event)
  end

  def player_ready
    logger.debug("[controller.player_ready] user_id=>"+message["user_id"].to_s)
    GameLogic.on_player_ready(message["user_id"].to_s, event)
  end

  def on_grab_lord
    logger.debug("[controller.on_grab_lord] user_id=>"+message["user_id"].to_s+"     lord_value=>#{message["lord_value"]}")
    GameLogic.on_grab_lord(message["user_id"].to_s, message["lord_value"], event)
  end

  def play_card
    logger.debug("[controller.play_card] user_id=>"+connection_store["current_user_id"].to_s+"poke_cards=>#{message["poke_cards"]}")
    GameLogic.on_play_card(connection_store["current_user_id"].to_s, message["poke_cards"], event)
  end

  def chat_in_playing
    logger.debug("[controller.chat_in_playing] user_id=>"+connection_store["current_user_id"].to_s+"poke_cards=>#{message["prop_id"]}")
    GameLogic.chat_in_playing(connection_store["current_user_id"].to_s, message["prop_id"], event)
  end

  def restore_connection
    logger.debug("[controller.restore_connection] user_id=>"+message["user_id"].to_s)

    s_name = message[:s_name]
    s_token = message[:s_token]
    run_env = message[:run_env].to_s
    connection_store["client_run_evn"] = run_env
    client_app_id = message[:app_id].to_s
    connection_store["client_app_id"] = client_app_id
    discard_version = SystemSetting.find_by_setting_name("discard_version").reload(:lock => true)
    discard_version = discard_version.setting_value unless discard_version.nil?
    version = User.find_by_user_id(message[:users_id]).user_profile.version
    if version.to_s > discard_version.to_s
      unless verify_client(s_name, s_token)
        return
      end
    end
    authenticate(message["user_id"].to_s, message["token"])

    if connection_store["authentication"]
      set_player_connection_info(message["user_id"].to_s)

      dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
      Rails.logger.debug("[restore_connection] @@connections_k_v=>" + dump_str)

      GameLogic.restore_connection(message["user_id"].to_s, message["game_id"].to_s, message["notify_id"].to_s, event)
    else
      trigger_failure({:msg => "failed to authenticate."})
    end
  end

  def player_timeout
    logger.debug("[controller.player_timeout] user_id=>#{message["user_id"].to_s}, timeout_user_id=>#{message["timeout_user_id"].to_s}")
    GameLogic.on_player_timeout(message["user_id"].to_s, message["timeout_user_id"].to_s, event)
  end

  def restore_game
    logger.debug("[controller.restore_game] user_id=>"+message["user_id"])
    GameLogic.restore_game(message["user_id"].to_s, message["game_id"].to_s, message["notify_id"].to_s, event)
  end

  def on_client_disconnected
    GameLogic.on_client_disconnected(connection_store["current_user_id"].to_s, connection.id.to_s)
    user_id = connection_store["current_user_id"].to_s
    key = "user_online_time_#{user_id}"
    unless user_id.nil?
      online_time = Time.now.to_i - Redis.current.get(key).to_i
      UserSheet.count_user_online_time(online_time)
    end

    logger.debug("[controller.on_client_disconnected] user_id=>#{user_id}, process_id=>#{Process.pid.to_s}")
    dump_str = @@connections.collect { |k, v| "#{k}=>#{v.try(:id)}" }.join(",")
    Rails.logger.debug("[controller.on_client_disconnected] @@connections_k_v=>" + dump_str)
    unless  @@connections[user_id].nil?
      logger.debug("[controller.on_client_disconnected] connections exist. ")
      if @@connections[user_id].id.to_s == connection.id.to_s
        logger.debug("[controller.on_client_disconnected] the same one connections. ")
        @@connections.delete(connection_store["current_user_id"].to_s)
      end
    end
    logger.debug("[controller.on_client_disconnected] connections deleted") if @@connections[user_id].nil?
    # Redis.current.decr(ResultCode::GAME_SERVER_CONNECTIONS_COUNT_KEY)
  end

  def get_rival_msg
    logger.debug("[controller.get_rival_msg] user_id=>"+message["user_id"].to_s)
    GameLogic.get_rival_msg(message["user_id"].to_s, event)
  end

  def player_leave_game
    logger.debug("[controller.player_leave_game] user_id=>"+message["user_id"].to_s)
    GameLogic.on_player_leave_game(message["user_id"].to_s, event)
  end

  def turn_on_guan
    logger.debug("[controller.turn_on_guan] user_id=>"+message["user_id"].to_s)
    GameLogic.on_turn_on_tuo_guan(message["user_id"].to_s, event)
  end

  def cancel_tuo_guan
    logger.debug("[controller.cancel_tuo_guan] user_id=>"+message["user_id"].to_s)
    GameLogic.on_cancel_tuo_guan(message["user_id"].to_s, event)
  end

  def player_change_game_table
    logger.debug("[controller.player_change_game_table] user_id=>"+message["user_id"].to_s)
    GameLogic.on_player_change_game_table(connection_store["current_user_id"].to_s, event)
  end

  def player_pause
    logger.debug("[player_pause] user_id=>"+connection_store["current_user_id"].to_s)
    GameLogic.set_player_pause(connection_store["current_user_id"].to_s, event)
  end

  def quit_pause
    logger.debug("[quit_pause] user_id=>"+connection_store["current_user_id"].to_s)
    GameLogic.set_player_quit_pause(connection_store["current_user_id"].to_s, event)
  end

  def on_client_error
    logger.error "[on_client_error] #{event.connection} got error: " + (message.blank? ? "empty" : message.to_json)
  end

  def user_score_list
    logger.debug("[controller.fetch_user_score_list] page_id=>"+message["user_id"].to_s)
    user_id = message["user_id"]
    GameLogic.user_score_list(user_id, event)
  end

  #def mobile_charge_list
  #  logger.debug("[controller.fetch_mobile_charge_list]=>")
  #  GameLogic.mobile_charge_list(event)
  #end


  def dialogue_count
    logger.debug("[controller.dialogue_count] dialogue_id=>"+message["id"].to_s)
    GameLogic.dialogue_count(message["id"])
  end

  def on_client_connected
    # Redis.current.incr(ResultCode::GAME_SERVER_CONNECTIONS_COUNT_KEY)
    Redis.current.incr(ResultCode::GAME_SERVER_CONNECTIONS_COUNT_KEY)
    characteristic_code = ClientVerify.produce_verify_info(connection.id)
    logger.info("[on_client_connected] characteristic_code=>#{characteristic_code}")
    e_data = {v_code: characteristic_code}
    options = {connection: connection, data: e_data }

    hs_en =  WebsocketRails::Event.new("ui.hand_shake", options)
    hs_en.trigger

    logger.info("[on_client_connected] trigger ui.hand_shake")
  end

  #def get_mobile_charge(user_id)
  #  user = User.find_by_user_id(user_id)
  #  can_get_mobile = user.reload(:lock=>true).user_profile.balance.to_i/10
  #  if can_get_mobile == 0
  #     trigger_failure({result_coed:ResultCode::USER_HAVE_NOT_ENOUGH_MOBILE})
  #  else
  #    user.user_profile.balance = user.reload(:lock=>true).user_profile.balance - can_get_mobile*10
  #    user.user_profile.save
  #    record = GetMobileChargeLog.new
  #    record.user_id = user_id
  #    record.fee = can_get_mobile*10
  #    record.save
  #    trigger_success({result_code:ResultCode::SUCCESS,mobile_charge:can_get_mobile*10,left_charge:user.reload(:lock=>true).user_profile.balance})
  #  end
  #
  #end


end