class UserProfileController < BaseController
  include BaseHelper
  include UserProfileHelper
  def complete_user_info        #完善个人资料
    user_id = message[:user_id]
    id = redis_key_pro(user_id,event.id)
    @user = User.find_by_user_id(user_id)
    avatar_changed = false
    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      unless message[:nick_name].nil?
        name = nick_name(message[:nick_name])
        unless name.nil?
          trigger_failure({:result_code=>ResultCode::HAVE_BAN_WORD, :result_message=>ResultCode::HAVE_BAN_WORD_WARN})
          return
        end
      end
      msg, avatar_changed = complete_user_info_type(@user)
      Redis.current.set "#{id}",msg
      Redis.current.expire("#{id}",ResultCode::REDIS_KEY_VALUE_LOST)
      trigger_success(msg)
    elsif Redis.current.exists("#{id}")
      msg = Redis.current.get("#{id}")
      trigger_success(msg)
    end
    if avatar_changed
      player = Player.get_player(user_id)
      player.on_changed_avatar do |text, voice, u_id|
        channel_name = "#{u_id}_hall_channel"
        notify_data = {:user_id=>u_id, :text=> text, :voice=> voice,:notify_type=>ResultCode::PROP_VOICE}
        WebsocketRails[channel_name].trigger("ui.routine_notify",notify_data)
      end
    end
  end

  def reset_password           #重置密码
    id = redis_key_pro(message[:user_id],event.id)
    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      @user = User.find_by_user_id(message[:user_id])
      msg = reset_password_type(@user,message[:oldpassword],message[:newpassword])
      Redis.current.set "#{id}",message
      Redis.current.expire("#{id}",ResultCode::REDIS_KEY_VALUE_LOST)
      if msg[:result_code] == ResultCode::SUCCESS
        trigger_success(msg)
      else
        trigger_failure(msg)
      end
    elsif Redis.current.exists("#{id}")
      msg = Redis.current.get("#{id}")
      if msg[:result_code] == ResultCode::SUCCESS
        trigger_success(msg)
      else
        trigger_failure(msg)
      end
    end
  end

  def get_user_profile
    logger.debug("[get_user_profile]_user_id:#{message[:user_id]}")

    user_id = message[:user_id]
    user = get_user(user_id)
    msg = {score:user.game_score_info.reload(:lock => true).score,
           win_count:user.game_score_info.reload(:lock => true).win_count,
           lost_count:user.game_score_info.reload(:lock => true).lost_count,
           flee_count:user.game_score_info.reload(:lock => true).flee_count
           }
    trigger_success(msg)
  end



  def back_password_by_email
    #p message
    #email = message[:email].try("downcase")
    #id = redis_key_value(email,event.id)
    #if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
    #  user_profile = UserProfile.find_by_email(email)
    #  unless user_profile.nil?
    #    user = User.find(user_profile.user_id)
    #    p user
    #    msg = {:email=>message[:email],:result_code=>ResultCode::SUCCESS}
    #    trigger_success(msg)
    #    UserMailer.delay.back_password
    #  else
    #    msg = {:result_code=>ResultCode::EMAIL_IS_NOT_BIND}
    #    trigger_failure(msg)
    #  end
    #  Redis.current.set "#{id}",msg
    #  Redis.current.expire("#{id}",ResultCode::REDIS_KEY_VALUE_LOST)
    #elsif Redis.current.exists(id)
    #  msg = Redis.current.get(id)
    #  if msg[:result_code] == ResultCode::SUCCESS
    #    trigger_success(msg)
    #  else
    #    trigger_failure(msg)
    #  end
    #end
  end
end

