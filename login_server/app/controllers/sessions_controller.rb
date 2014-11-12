#encoding: utf-8
require "game_table.rb"

class SessionsController < BaseController
  include SessionsHelper
  include GameTimingNotifyType

  def sign_in
    logger.info("[sign_in_message=>#{message}")
    unless @sign_type == ResultCode::THE_MARKET_USER_SIGN_IN
      @sign_type = message[:login_type].to_s
      @user_id = message[:user_id]
    end


    logger.info("[sign_in], user_id=>#{@user_id}")
    set_user_day_key(@user_id)
    s_name = message[:s_name]
    s_token = message[:s_token]
    clinet_app_id = message[:app_id]
    version = message[:version]
    discard_version = SystemSetting.find_by_setting_name("discard_version").reload(:lock=>true)
    discard_version = discard_version.setting_value unless discard_version.nil?
    logger.info("[sign_in_discard_version=>#{discard_version}")

    discard_version ="2.1.2" if discard_version.nil?
    if version > discard_version
      unless verify_client(s_name, s_token, clinet_app_id)
        return
      end
    end
    set_current_user(@user_id)
    id = redis_key_pro(@user_id, event.id)
    player = Player.get_player(@user_id)

    if player.nil?
      trigger_failure()
      return
    end
    return_sign_type = {:sign_type => @sign_type.to_i}
    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      black_message = {:result_code => ResultCode::USER_IN_BLACK_LIST, :text => "用户或者设备列入黑名单"}
      black_flag = black_user(@user_id, message[:imsi])
      if black_flag
        trigger_success(black_message)
        return
      end
      @user = User.find_by_user_id(@user_id) unless @user_id.nil?
      msg = sign_in_type(@user, @sign_type, message.dup)
      msg = msg.merge(return_sign_type)

      Redis.current.set "#{id}", msg
      Redis.current.expire("#{id}", ResultCode::REDIS_KEY_VALUE_LOST)
      if msg[:result_code] == ResultCode::SUCCESS


        if player.in_game?
          instances = get_game_server_instances
          Rails.logger.debug("[sign_in] instances: "+instances.to_json)
          server_id = instances[rand(0..instances.length-1)]
          Rails.logger.debug("[sign_in] server_id: "+server_id)
          table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
          alive_player_id = table.get_alive_player_id
          unless alive_player_id.nil?
            alive_player = Player.get_player(alive_player_id)
            server_id = alive_player.player_info.game_server_id
            Rails.logger.debug("[sign_in] alive_player.game_server_id: "+server_id)
          end

          DdzLoginServer::Synchronization.publish({:user_id => @user_id,
                                                   :notify_type => GameTable::GameTimingNotifyType::KICK_USER,
                                                   :server_id => server_id
                                                  })
        end
        trigger_success(msg)
        send_message_to_manager(@user_id)
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

    #player.on_login_in

  end

  def sign_up_up
    Rails.logger.debug("GameTimingNotifyType::LOGIN_TYPE#{GameTimingNotifyType::LOGIN_TYPE}")
    Rails.logger.debug("sign_up_up_message#{message}")
    unless @sign_type == ResultCode::THE_MARKET_USER_SIGN_IN
      @sign_type = message[:sign_type].to_s
    end

    id = connection.id.to_s + event.id.to_s

    s_name = message[:s_name]
    s_token = message[:s_token]
    clinet_app_id = message[:app_id]
    version = message[:version]
    Rails.logger.debug("sign_up_up_version#{version}")

    discard_version = SystemSetting.find_by_setting_name("discard_version").reload(:lock=>true)
    discard_version = discard_version.setting_value unless discard_version.nil?
    logger.info("[sign_in_discard_version=>#{discard_version}")

    discard_version ="2.1.2" if discard_version.nil?

    if version.to_s > discard_version
      unless verify_client(s_name, s_token, clinet_app_id)
        return
      end
    end

    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      if @sign_type == ResultCode::NORMAL_SIGN_UP
        Rails.logger.debug("sign_up_name =>#{message[:nick_name]}")

        name = nick_name(message[:nick_name])
        Rails.logger.debug("zheng ze sign_up_name=>#{name}")

        unless name.nil?
          trigger_failure({:result_code => ResultCode::HAVE_BAN_WORD, :result_message => ResultCode::HAVE_BAN_WORD_WARN})
          return
        end
      end
      Rails.logger.debug("sign_up_up,  @sign_type=>#{@sign_type}")
      user = sign_up_type(@sign_type, message.dup)
      p user
      set_user_day_key(user.user_id)
      sign_type = {:sign_type => @sign_type.to_i}
      msg = back_message(user)
      msg = msg.merge(sign_type)
      Redis.current.set "#{id}", msg
      Redis.current.expire("#{id}", ResultCode::REDIS_KEY_VALUE_LOST)
      send_message_to_manager(user.user_id)
      trigger_success(msg)
      logger.info("[sign_up_up], trigger_success, msg=>#{msg}")
    elsif Redis.current.exists("#{id}")
      msg = Redis.current.get("#{id}")
      trigger_success(msg)
    end
  end

  def sign_in_with_market_id
    logger.info("[sign_with_market_id]")
    logger.debug("[sign_with_market_id] message=>#{message.to_json}")

    market_user_id = message[:market_user_id]
    if market_user_id.blank?

      logger.info("[sign_with_market_id], the market_user_id is null. market_user_id=>#{market_user_id}")
      trigger_failure({:result_code => ResultCode::USER_INFO_BLANK, :result_message => ResultCode::LOGIN_IN_USER_INFO_BLANK_F})
      return
    end
    app_id = message[:app_id]
    market_user_info = UserOfMarket.find_by_market_user_id_and_app_id(market_user_id, app_id)

    @sign_type = ResultCode::THE_MARKET_USER_SIGN_IN
    if market_user_info.blank?
      sign_up_up
    else
      @user_id = market_user_info.user_id
      sign_in
    end
  end


  def verify_client(s_name, s_token, clinet_app_id)
    unless ClientVerify.verify_client(s_name, s_token, connection.id, clinet_app_id)
      check_result = ResultCode::CLIENT_VERIFY_FAILED
      result_msg = ResultCode::CLIENT_VERIFY_FAILED_TEXT
      trigger_failure({:result_code => check_result, :result_message => result_msg})
      connection.on_error({connection_closed: true, error: "Invalidate client: #{self}"})
      true
    end
    true
  end

  def on_client_error
    logger.error "[on_client_error] #{event.connection} got error: " + (message.blank? ? "empty" : message.to_json)
  end

  def get_game_server_instances
    tmp_instances = `ps aux |grep thin |grep ddz_game_server | awk '{print $2}'`
    tmp_instances = tmp_instances.split("\n")
    tmp_instances = tmp_instances - [tmp_instances.last]
  end

  def forget_password
    msg = {:result_code => ResultCode::SUCCESS}
    user_id = message[:user_id]
    email = message[:email]
    user = User.find_by_user_id(user_id)
    Rails.logger.debug("[forget_password] user_id=>#{user_id},email=>#{email}")

    if user.nil?
      trigger_failure({:result_code => 1})
    end

    unless user.nil?
      if user.user_profile.reload(:lock => true).email.to_s.downcase == email.to_s.downcase
        new_pass = ""
        chars =("0".."9").to_a
        1.upto(8) { |i| new_pass << chars[rand(chars.size-1)].to_s }
        user.password_digest = Digest::MD5.hexdigest(new_pass+user.password_salt)
        user.save
        UserMailer.delay.send_email(email, new_pass)
        trigger_success(msg)
      else
        trigger_failure({:result_code => 1})
      end
    end
  end

  def check_update
    version = message[:pkg_resource_version]
    appid = message[:appid]
    run_env = message[:run_env].to_s
    # run_env = "test"
    msg = check_version(version, appid, run_env)
    trigger_success(msg)
  end

  def set_user_day_key(user_id)
    key = "#{user_id}_#{Time.now.to_s.gsub!("-", "")[0, 8]}"
    if Redis.current.exists(key)
      return
    else
      Redis.current.set(key, 0)
      Redis.current.expire(key, 24*3600)
    end
  end


end