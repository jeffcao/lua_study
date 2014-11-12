module UserProfileHelper
  def complete_user_info_type(user)
    @user = user
    if @user
      @user_profile = @user.user_profile
      old_avatar = @user_profile.avatar
      @user_profile.avatar = message[:avatar] unless message[:avatar].nil?
      avatar_changed = old_avatar != @user_profile.avatar
      @user_profile.gender = message[:gender] unless message[:gender].nil?
      @user_profile.birthday = message[:birthday] unless message[:birthday].nil?
      @user.nick_name = @user_profile.nick_name = message[:nick_name] unless message[:nick_name].nil?
      #@user_profile.email = message[:email] unless message[:email].nil?
      unless message[:email].nil?
        @user_profile.email = message[:email]
        user.game_score_info.score = user.game_score_info.score + 5000
        user.game_score_info.save
        channel_name = "#{user.user_id}_hall_channel"
        notify_data = {:user_id => user.user_id, :score=>user.reload(:lock=>true).game_score_info.score,:beans=>5000,:notify_type=>ResultCode::COMPLETE_PROFILE_GET_BEANS}
        WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
      end
      @user.password_digest = ::Digest::MD5.hexdigest(message[:password]<<@user.password_salt) unless message[:password].nil?
      @user.save
      @user_profile.save
      data = back_message(@user)
      [data, avatar_changed]
    else
      {:result_code => ResultCode::UPDATE_USER_PROFILE_FAIL}
    end
  end

  def reset_password_type(user, password, newpassword)
    @user = user
    if @user
      if Digest::MD5.hexdigest(password<<@user.password_salt.to_s) == @user.password_digest.to_s
        @user.password_digest = Digest::MD5.hexdigest(newpassword << @user.password_salt.to_s)
        @user.save
        message = {:result_code => ResultCode::SUCCESS}
      else
        message = {:result_code => ResultCode::RESET_PASSWORD_FAIL}
      end
    end
    message
  end

  def back_message(user)
    @user = user
    if user.password_digest.nil?
      profile_flag = {:flag => 0} #个人资料需要完善
    else
      profile_flag = {:flag => 1} #个人资料已经完善
    end
    @user_profile = @user.user_profile
    msg = {:user_id => @user.user_id,
           :game_level => @user.game_level,
           :birthday => @user_profile.birthday,
           :gender => @user_profile.gender,
           :nick_name => @user_profile.nick_name,
           :email => @user_profile.email,
           :avatar => @user_profile.avatar,
           :result_code => ResultCode::SUCCESS
    }
    msg = msg.merge(profile_flag)
    msg
  end

end
