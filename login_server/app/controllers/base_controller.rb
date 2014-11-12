require "result_code"
require "synchronization"

#require 'models/game_table'
class BaseController < WebsocketRails::BaseController
  def redis_key_pro(user_id, event_id)
    key = "#{user_id.to_s}_#{event_id.to_s}"
    key
  end

  def get_user(id)
    logger.debug("get_user_id=>#{id}")
    user = User.find_by_user_id(id)
    logger.debug("get_user_id=>#{id}")
    p user.id
    user
  end

  def redis_key_value(key, value)

    p key
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
    key = "#{user_id}_push_prop"
    Redis.current.set(key,0)
    #day_act_key = "#{user_id}_day_act"
    #if Redis.current.exists(day_act_key)
    #else
    #  Redis.current.set(day_act_key,0)
    #  Redis.current.expire(day_act_key,24*3600)
    #end
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

  def on_client_disconnected
    user_id = connection_store[:this_user] unless connection_store[:this_user].nil?
    key = "user_online_time_#{user_id}"
    unless user_id.nil?
      online_time = Time.now.to_i - Redis.current.get(key).to_i
      UserSheet.count_user_online_time(online_time)
      #Redis.current.del(key)
    end

    # Redis.current.decr(ResultCode::LOGIN_SERVER_CONNECTIONS_COUNT_KEY)
  end

  def on_client_connected
    # Redis.current.incr(ResultCode::LOGIN_SERVER_CONNECTIONS_COUNT_KEY)
    characteristic_code = ClientVerify.produce_verify_info(connection.id)
    logger.info("[on_client_connected] characteristic_code=>#{characteristic_code}")
    e_data = {v_code: characteristic_code}
    options = {connection: connection, data: e_data }

    hs_en =  WebsocketRails::Event.new("ui.hand_shake", options)
    hs_en.trigger

    logger.info("[on_client_connected] trigger ui.hand_shake")
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

end




