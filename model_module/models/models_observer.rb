#encoding: utf-8

class ModelsObserver < ActiveRecord::Observer
  observe :GameRoom, :GameRoomUrl, :GameScoreInfo, :UserProfile, :GameScoreInfo, :Blacklist


  def after_create(model)
    init_black_list(model)
    init_game_info_cache(model)
    Rails.logger.debug("[ModelsObserver] after_create=> "+model.class.to_s)
  end

  def after_update(model)
    init_game_score_info(model)
    #init_game_info_cache(model)
    #after_update_action(model)
    Rails.logger.debug("[ModelsObserver] after_update=> "+model.class.to_s)
  end

  def init_game_score_info(model)
    if model.is_a?(GameScoreInfo)
      user = User.find(model.user_id)
      score = user.game_score_info.reload(:lock => true).score
      Rails.logger.debug("[ModelsObserver] init_game_score_info_user_id=> "+model.user_id.to_s)
      level = "短工"
      if score < 0
        level = "短工"
      elsif score > 1216700000
        level = "仁主"
      else
        level_result = Level.where(["min_score<=? and max_score>=?", score, score]).first
        level = level_result.name unless level_result.nil?
      end
      user.game_level = level
      channel = "channel_#{user.user_id}"
      notify_data = {:level => level, :notify_type => 0}
      Rails.logger.debug("[ModelsObserver] init_game_score_info_notify_data=> "+notify_data.to_s)
      WebsocketRails[channel].trigger("ui.routine_notify", notify_data)
      user.save
    end
  end

  def init_game_info_cache(model)
    if model.is_a?(GameRoom)
      init_rooms_cache()
    elsif model.is_a?(GameRoomUrl)
      Redis.current.del("#{model.game_room_id}_#{ResultCode::ROOM_KEY_SUFFIX}")
      Rails.logger.debug("[init_game_info_cache] clear room => "+model.game_room_id.to_s)
    end
  end

  def init_black_list(model)

    if model.is_a?(Blacklist)
      user = User.find_by_user_id(model.black_user)
      channel = "channel_#{user.user_id}"
      hall_channel = "#{user.user_id}_hall_channel"
      notify_data = {:text=>"用户或者设备列入黑名单", :notify_type=>ResultCode::USER_LOCKED }
      Rails.logger.debug("[init_black_list] notify_data => #{notify_data},channel=>#{channel}")
      WebsocketRails[hall_channel].trigger("ui.routine_notify", notify_data)

      WebsocketRails[channel].trigger("ui.routine_notify", notify_data)
    end


  end

  def after_update_action(model)
    if model.is_a?(UserProfile)
      user = User.find(model.user_id)
      user_id = user.user_id
      if Redis.current.exists("#{user_id}_#{ResultCode::USER_STATE_KEY_SUFFIX}")
        user_msg = JSON.parse(Redis.current.get("#{user_id}_#{ResultCode::USER_STATE_KEY_SUFFIX}"))
        Rails.logger.debug("after_update_action_user_msg=>#{user_msg}")
        user_msg["avatar"] = user.user_profile.avatar
        user_msg["gender"] = user.user_profile.gender
        user_msg["nick_name"] = user.user_profile.nick_name
        Redis.current.set "#{user_id}_#{ResultCode::USER_STATE_KEY_SUFFIX}", user_msg.to_json
      end
    end
  end

  def init_rooms_cache
    rooms = GameRoom.all
    room_msg =[]
    rooms.each do |room|
      msg = {:room_id => room.id,
             :ante => room.ante,
             :name => room.name,
             :min_qualification => room.min_qualification,
             :max_qualification => room.max_qualification,
             :status => room.status,
             :online_count => 0
      }
      room_msg.push(msg)
    end
    Rails.logger.debug("[init_rooms_cache] room_msg=> "+room_msg.to_json)
    Redis.current.set "room_msg", room_msg.to_json
  end

end