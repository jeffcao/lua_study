#encoding: utf-8
class GameShopPropController < BaseController
  include BaseHelper
  include GameShopPropHelper
  include BuyPropHelper

  def shop_prop_list #商城道具列表

    user_id = message[:user_id]
    User.record_user_game_teach(user_id,"shop")

    id = redis_key_value(user_id, event.id)
    if message[:retry] ==ResultCode::CONNECTION_RETRY_BEGIN
      msg = get_all_prop
      trigger_success(msg)
      Redis.current.set "#{id}", msg
      Redis.current.expire("#{id}", ResultCode::REDIS_KEY_VALUE_LOST)
    elsif Redis.current.exists("#{id}")
      msg = Redis.current.get("#{id}")
      trigger_success(msg)
    end

    player = Player.get_player(user_id)
    player.on_enter_prop_store do |text, voice, u_id|
      channel_name = "#{u_id}_hall_channel"
      Rails.logger.debug("[player.on_enter_prop_store], channel_name=>#{channel_name}")
      notify_data = {:user_id=>u_id, :text=> text, :voice=> voice,:notify_type=>ResultCode::PROP_VOICE}
      Rails.logger.debug("[player.on_enter_prop_store], notify_data=>#{notify_data}")
      WebsocketRails[channel_name].trigger("ui.routine_notify",notify_data)
    end
  end


end
