#encoding: utf-8
module SessionsHelper
  def sign_in_type(user, id, message)
    version = message[:version]
    if id == ResultCode::FAST_SIGN_IN and user #fast_login 快速登陆
      Rails.logger.debug("[SessionsHelper:sign_in_type] fast_login, user_id=>#{user.user_id}, token=>#{message[:token]}")
      token = message[:token]
      msg=login_by_token(user, token, version)
    elsif id == ResultCode::NORMAL_SIGN_IN and user
      password = message[:password]
      msg = login_by_password(user, password, version) #普通登陆
    elsif id == ResultCode::THE_MARKET_USER_SIGN_IN
      msg = login_by_market_user(user, version)
    end
    user = User.find(user.id)
    user.version = version
    user.save
    msg
  end

  def login_by_market_user(user, version)
    @user = user
    get_user_consecutive(user) #统计用户连续登陆天数

    @user.user_profile.version = version
    @user.user_profile.last_login_at = Time.now
    @user.user_profile.save
    login_token(@user, "market_user")
    message = back_message(user)

    message
  end

  def login_by_token(user, token, version)
    @user = user
    #login_token = Digest::MD5.hexdigest(@user.user_profile.reload(:lock => true).last_login_at.to_s<<@user.user_id.to_s<<@user.password_salt.to_s)
    login_token = user.login_token
    Rails.logger.debug("[SessionsHelper.login_by_token] last_login_at=>#{@user.user_profile.last_login_at.to_s}")
    Rails.logger.debug("[SessionsHelper.login_by_token] password_salt=>#{@user.password_salt.to_s}")
    Rails.logger.debug("[SessionsHelper.login_by_token] login_token=>#{login_token}")
    if login_token == token
      get_user_consecutive(user) #统计用户连续登陆天数

      @user.user_profile.version = version
      @user.user_profile.last_login_at = Time.now
      @user.user_profile.save
      user=login_token(@user,"token")
      message = back_message(user)
    else
      message = {:result_code => ResultCode::TOKEN_IS_LOST}
      Rails.logger.debug("[SessionsHelper.login_by_token] ResultCode::TOKEN_IS_LOST")
    end
    message
  end

  def login_by_password(user, pwd, version)

    @user = user
    if Digest::MD5.hexdigest(pwd.to_s << @user.password_salt.to_s) == @user.reload(:lock => true).password_digest
      get_user_consecutive(user) #统计用户连续登陆天数

      Rails.logger.debug("[login_by_password] pwd =>#{Digest::MD5.hexdigest(pwd.to_s << @user.password_salt.to_s)}")
      Rails.logger.debug("[login_by_password] dbpwd =>#{@user.reload(:lock => true).password_digest}")
      @user.user_profile.version = version
      @user.user_profile.last_login_at = Time.now
      @user.user_profile.save
      login_token(@user, "password")
      message = back_message(user)
    else
      message = {:result_code => ResultCode::LOGIN_FAIL}
    end
    message
  end

  def sign_up_type(id, message)
    if id == ResultCode::FAST_SIGN_UP #快速注册
      user = fast_sign_up(message)
    elsif id == ResultCode::THE_MARKET_USER_SIGN_IN #第三方ID快速注册
      user = fast_sign_up(message)
      map_market_user_user(user, message[:market_user_id], message[:app_id])
    elsif id == ResultCode::NORMAL_SIGN_UP
      user = normal_sign_up(message[:nick_name], message[:password], message)
    end
    user
  end

  def map_market_user_user(user, market_user_id, app_id)
    Rails.logger.info("map_market_user_user")
    market_user = UserOfMarket.new
    market_user.app_id = app_id
    market_user.market_user_id = market_user_id
    market_user.user_id = user.user_id
    market_user.save

  end

  def fast_sign_up(message)
    #user = User.new
    Rails.logger.debug("[SessionsHelper.fast_sign_up] fast_sign_up=>#{message}")

    br_attrs = User.accessible_attributes.to_a
    br_params = message.select { |k, v| br_attrs.include?(k.to_s) }
    user = User.create_new_user(br_params)
    user.password_salt = Guid.new.hexdigest
    user.user_id = UserId.generate_next_id
    user.nick_name = user.user_id
    user.save
    user.game_score_info||user.build_game_score_info
    user.game_score_info.score = ResultCode::USER_INITIAL_SCORE
    user.game_score_info.save
    user.user_profile|| user.build_user_profile
    user.user_profile.user_id = user.id
    user.user_profile.appid = user.appid
    user.user_profile.version = user.version
    user.user_profile.nick_name = user.user_id
    user.user_profile.save
    sign_up_get_money(user)

    user
    login_token(user)
  end

  def normal_sign_up(name, pwd, message)
    Rails.logger.debug("[SessionsHelper.normal_sign_up] normal_sign_up=>#{message}")
    br_attrs = User.accessible_attributes.to_a
    br_params = message.select { |k, v| br_attrs.include?(k.to_s) }
    br_params[:nick_name] = name
    user = User.create_new_user(br_params)
    user.user_profile.gender = message[:gender] unless message[:gender].nil?
    user.user_profile.nick_name = name
    user.user_profile.version = message[:version] unless message[:version].nil?
    user.user_profile.appid = user.appid
    user.user_profile.last_login_at = Time.now
    user.user_profile.save
    user.password_salt = Guid.new.hexdigest
    user.password_digest = ::Digest::MD5.hexdigest(pwd<<user.password_salt)
    user.save
    user.game_score_info||user.build_game_score_info
    user.game_score_info.score = ResultCode::USER_INITIAL_SCORE
    user.game_score_info.save
    sign_up_get_money(user)
    user = login_token(user)
  end

  def judge_shouchong_display(payment)
    Rails.logger.debug("[SessionsHelper.judge_shouchong_display] payment=>#{payment}")
    record = SystemSetting.find_by_setting_name(payment)
    return 0 if record.nil?
    value = JSON.parse(record.setting_value)
    Rails.logger.debug("[SessionsHelper.judge_shouchong_display] value=>#{value}")
    params_value = value["#{payment}"]
    return 0 if params_value["shouchong_libao"].nil?
    Rails.logger.debug("[SessionsHelper.judge_shouchong_display] params_value=>#{params_value}")
    params_value["shouchong_libao"].to_i
  end

  def login_token(user, login_type=nil) #每次登陆生成login_token
    player = Player.get_player(user.user_id)
    Rails.logger.debug("[SessionsHelper.login_token] payment=>#{message[:payment]}")
    user_profile = user.user_profile
    user_profile.payment = message[:payment] unless message[:payment].nil?
    unless message[:payment].nil?
      user_profile.first_buy = judge_shouchong_display(message[:payment]) if user_profile.first_buy.to_i==0
    end

    user_profile.save

    if player.nil?
      trigger_failure()
      return
    end

    player.on_login_in


    key = "user_online_time_#{user.user_id}"
    Rails.logger.debug("login_token_key=>#{key}")
    Redis.current.set(key, Time.now.to_i)
    UserSheet.count_user_login
    game_count
    LoginLog.log_login(user)
    set_user_active_time(user)
    @user = user
    if login_type.nil?
      @user.login_token = Digest::MD5.hexdigest(@user.user_profile.last_login_at.to_s<<@user.user_id.to_s<<@user.password_salt.to_s)
    elsif (login_type == "password" or login_type == "market_user" )  and user.imei.to_s != message[:imei].to_s
      @user.login_token = Digest::MD5.hexdigest(@user.user_profile.last_login_at.to_s<<@user.user_id.to_s<<@user.password_salt.to_s)
    end
    @user.save
    redis_user_message(@user)
    @user
  end

  def back_message(user)
    score = User.back_msg_user_score(user)
    logger.debug("back_message_score_#{score}")
    cate = User.back_msg_user_cate(user)
    logger.debug("back_message_cate_#{cate}")
    profile = User.back_msg_user_profile(user)
    logger.debug("back_message_profile_#{profile}")
    system_settings = SystemSetting.where(["enabled=? and flag=?", 1, 0])
    settings_msg = {}
    system_settings.each do |system_setting|
      settings_msg= settings_msg.merge({:"#{system_setting.setting_name}" => system_setting.setting_value})
    end
    logger.debug("back_message_score_#{settings_msg}")
    system_url = []
    hall_urls = SystemSetting.where(["setting_name=? and enabled=?", "ddz_hall_url", 1])
    hall_urls.each do |hall_url|
      system_url.push(hall_url.setting_value)
      settings_msg.merge!({:ddz_hall_url => hall_url.setting_value})
    end

    msg_server_url = "http://localhost:5003"
    msg_server = SystemSetting.find_by_setting_name("ddz_msg_server_url")
    msg_server_url = msg_server.setting_value unless msg_server.nil?

    logger.debug("back_message_score_#{system_url}")
    notify_id = get_notify_id(user.user_id)
    #teach_msg = game_teaching(user)

    teach_msg = {}
    specify_prop_list = prop_list(nil,user.user_profile.payment)

    shouchong_ordered = shouchong_ordered?(user, specify_prop_list)
    message = {:result_code => ResultCode::SUCCESS,
               :user_id => user.user_id,
               :token => user.login_token,
               :score => score,
               :game_level => user.game_level,
               :prop => cate,
               :user_profile => profile,
               :vip_level => user.vip_level.to_i,
               :system_settings => settings_msg,
               :url => system_url,
               :msg_server_url => msg_server_url,
               :notify_id => notify_id,
               :teach_msg => teach_msg,
               :total_consume => user.total_consume.to_f,
               :weibo => weibo,
               :message_time => Time.now.to_s,
               :vip => vip_level(user.user_id),
               :joined_match => user_get_match_seq(user.user_id),
               :l_cpparam => "#{Time.now.strftime("%y%m%d%H%M")}0#{user.user_id}",
               :me_phone_num => ResultCode::MOBILE,
               :prop_list => specify_prop_list,
               :shouchong_finished => user.user_profile.first_buy,
               :shouchong_ordered => shouchong_ordered,
               :min_charge_get_limit => get_min_charge_get_limit,
               :play_card_wait_time => get_play_card_wait_time
    }
    if user.user_profile.first_buy.to_i ==0
      prop = GameProduct.find_by_product_name("首充大礼包")
      prop_id = prop.id unless prop.nil?
      message = message.merge(:shouchong_prop_id => prop_id)
    end
    User.record_user_game_teach(user.user_id, "sign")
    message
  end

  def redis_key_pro(user_id, event_id)
    id = user_id.to_s + event_id.to_s
    id
  end

  def shouchong_ordered?(user, specify_prop_list)
    return true if user.user_profile.first_buy == 1

    record = PurchaseRequestRecord.where(["user_id=? and game_product_id=? and state=?", user.user_id, specify_prop_list[:shouchongdalibao][:id], 0]).count
    return true if record > 0

    false
  end

  def redis_user_message(user)
    key = user.login_token
    value ={:nick_name => user.nick_name,
            :gender => user.user_profile.gender,
            :avatar => user.user_profile.avatar,
            :user_id => user.user_id
    }
    Redis.current.mapped_hmset(key, value)
    Redis.current.expire(key, 3600*8)
  end

  def get_notify_id(user_id)
    key = "login_" + user_id.to_s
    if connection_store[key].nil?
      connection_store[key] = 0
    else
      connection_store[key] = connection_store[key].to_i + 1
    end
    connection_store[key]
  end

  def send_message_to_manager(user_id)
    #Rails.logger.debug("send_message_to_manager_user_id#{user_id}")
    #user = Player.get_player(user_id)
    #
    #
    #DdzLoginServer::Synchronization.publish({:user_id=>user_id,
    #                                         :notify_type=>GameTable::GameTimingNotifyType::LOGIN_TYPE,
    #                                         :nick_name=>user.player_info.nick_name
    #                                       })
    #
    #Rails.logger.debug("send_message_to_manager_user_id#{user_id}")


  end

  def set_user_active_time(user)
    if user.user_profile.last_active_at.nil?
      user.user_profile.last_active_at = Time.now
      user.user_profile.online_time = 1
    elsif user.user_profile.last_active_at.to_s[0, 10] != Time.now.to_s[0, 10]
      user.user_profile.last_active_at = Time.now
      user.user_profile.online_time = 1
    else
      user.user_profile.last_active_at = Time.now
    end
    user.user_profile.save
  end

  def game_teaching(user)
    user_id = user.user_id
    teaching = GameTeach.all
    msg = {}
    return if teaching.nil?
    teaching.each do |item|
      tmp_msg = {}
      record = UserGameTeach.find_by_user_id_and_game_teach_id(user_id, item.id)
      if record.nil?
        key = item.moment
        tmp_msg = {:id => item.id, :content => item.content}
        tmp_msg ={"#{key}" => tmp_msg}
        msg.merge!(tmp_msg)
      end
    end
    msg
  end

  def game_count #count day max online players
    login_con_count = Redis.current.get(ResultCode::LOGIN_SERVER_CONNECTIONS_COUNT_KEY) if Redis.current.exists(ResultCode::LOGIN_SERVER_CONNECTIONS_COUNT_KEY)
    hall_con_count = Redis.current.get(ResultCode::HALL_SERVER_CONNECTIONS_COUNT_KEY) if Redis.current.exists(ResultCode::HALL_SERVER_CONNECTIONS_COUNT_KEY)
    game_con_count = Redis.current.get(ResultCode::GAME_SERVER_CONNECTIONS_COUNT_KEY) if Redis.current.exists(ResultCode::GAME_SERVER_CONNECTIONS_COUNT_KEY)
    msg_con_count = Redis.current.get(ResultCode::MSG_SERVER_CONNECTIONS_COUNT_KEY) if Redis.current.exists(ResultCode::MSG_SERVER_CONNECTIONS_COUNT_KEY)

    date = Time.now.strftime("%Y-%m-%d").to_s
    now_online_user = msg_con_count.to_i + login_con_count.to_i
    flag = DdzSheet.find_by_date(date)
    logger.debug("game_count#{now_online_user}")

    if flag.nil?
      ddz_sheet = DdzSheet.new
      ddz_sheet.game_id = "我爱斗地主"
      ddz_sheet.platform = "移动MM"
      ddz_sheet.date = date
      ddz_sheet.day_max_online = now_online_user
      ddz_sheet.save
    else
      flag.day_max_online = now_online_user > flag.day_max_online ? now_online_user : flag.day_max_online
      flag.save
    end
  end

  def user_login_count
    date = Time.now.strftime("%Y-%m-%d")
    flag = UserSheet.find_by_date(date)
    if flag.nil?
      user_sheet = UserSheet.new
      user_sheet.date = date
      user_sheet.login_count = 1
      user_sheet.save
    else
      flag.login_count = flag.login_count + 1
    end

  end

  def vip_get_beans(user)
    beans = [0, 1200, 3500, 7000, 13000]
    date = Time.now.strftime("%Y%m")
    table = "login_logs_#{date}"
    record = LoginLog.connection.execute("select * from #{table} where user_id = #{user.user_id} and created_at like '%#{Time.now.strftime("%Y-%m-%d")}%'")
    if record.size < 1
      user.game_score_info = user.game_score_info + beans[user.vip_level.to_i]
      user.game_score_info.save
    end
  end

  def weibo
    sina = link(ShareWeibo.find_by_weibo_type("sina"))
    tencent = link(ShareWeibo.find_by_weibo_type("qq"))
    message = {
      :sina_weibo => sina,
      :tencent_weibo => tencent
    }
    message
  end

  def link(record)
    unless record.nil?
      if record.weibo_type.to_s.downcase=="qq"
        url = record.url+"?c=share&a=index&appkey=" + record.appkey + "&title=" + record.title + "&ralateUid=" + record.ralate_uid
      else
        url = record.url+"?appkey=" + record.appkey + "&title=" + record.title + "&ralateUid=" + record.ralate_uid
      end
    end
    url
  end

  def vip_level(user_id)
    msg = {}
    user = User.find_by_user_id(user_id)
    if user.vip_level.to_i == 0
      msg
      return
    end
    get_salary = 0
    vip = ResultCode::VIP
    money = vip[user.vip_level.to_i].split("-")[1].to_i
    salary = vip[user.vip_level.to_i].split("-")[2].to_i
    next_key = user.vip_level.to_i + 1
    if next_key < 5
      next_money = vip[next_key].split("-")[1].to_i - money
      lv = percent(user.vip_level.to_i, user.total_consume.to_f)
    else
      lv = 100
      next_money = 0
    end
    date = Time.now.strftime("%Y-%m-%d")
    record = GetSalary.find_by_user_id_and_date(user_id, date)
    get_salary = 1 unless record.nil?
    msg = {:vip_level => user.vip_level.to_i, :total_consume => user.total_consume.to_f, :salary => salary, :next_money => next_money, :get_salary => get_salary, :percent => lv}
    msg

  end

  def percent(vip_level, total_consume)
    vip = ResultCode::VIP

    last_index = vip_level-1
    next_index = vip_level
    last_money = vip[last_index].split("-")[1].to_i
    next_money = vip[next_index].split("-")[1].to_i
    result = (total_consume-last_money).to_f/(next_money-last_money)
    result = result*0.25 + (last_index/4.0)
    result=result*100
    result.to_i


  end

  def check_version(version, appid, run_env)
    Rails.logger.debug("login.check_version, version=#{version}, appid=#{appid}, run_env=#{run_env}")
    message = {:kind => "none"}

    Rails.logger.debug("check_version_message#{message}")
    message
  end

  def return_array(s_code)
    return_code = []
    return return_code if s_code.nil?
    s_code.each_byte do |c|
      return_code.push(c)
    end
    return_code
  end

  def black_user(user_id, imsi)
    flag = false
    record = Blacklist.where(["black_user=? or imsi=?", user_id, imsi])
    unless record.blank?
      flag = true
    end
    flag
  end

  def get_user_consecutive(user)
    user_profile = user.user_profile unless user.user_profile.nil?
    return if user_profile.nil?
    Rails.logger.debug("get_user_consecutive_last_login_at=>#{user.user_profile.last_login_at}.")

    return if user_profile.last_login_at.to_s[0, 10] == Time.now.to_s[0, 10]

    if 24.hours.since(user_profile.last_login_at) < Time.now
      user_profile.consecutive = 1
    else
      user_profile.consecutive =user_profile.consecutive + 1
    end

    user_profile.save

  end

  def user_get_match_seq(user_id)
    joined_match = []
    match_seqs = MatchMember.where(:user_id => user_id, :status => 0)
    unless match_seqs.nil?
      match_seqs.each do |seqs|
        joined_match.push(seqs.match_seq)
      end
    end
    joined_match
  end

  def prop_list(flag = nil,payment=nil)
    name = ResultCode::JIPAIQI
    msg = {}
    prop = GameProduct.find_by_product_name(name)
    consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code
    unless prop.nil?
      j_msg = {note: prop.note, icon: prop.icon, id: prop.id, name: prop.product_name, price: prop.price, rmb: prop.price.to_f/100, consume_code: consume_code}
    end

    name = ResultCode::HUANGJINBAOXIANG
    prop = GameProduct.find_by_product_name(name)
    consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code
    unless prop.nil?
      b_msg = {note: prop.note, icon: prop.icon, id: prop.id, name: prop.product_name, price: prop.price, rmb: prop.price.to_f/100, consume_code: consume_code}
    end
    msg = {jipaiqi: j_msg, douzi: b_msg}
    if flag.to_i ==0
      name = ResultCode::SHOUCHONGDALIBAO
      prop = GameProduct.find_by_product_name(name)
      consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code
      unless prop.nil?
        s_msg = {note: prop.note, icon: prop.icon, id: prop.id, name: prop.product_name, price: prop.price, rmb: prop.price.to_f/100, consume_code: consume_code}
      end
      msg = msg.merge({shouchongdalibao: s_msg})
    end
    msg
  end

  def get_min_charge_get_limit
    base_mobile = ResultCode::USER_GET_MOBILE_CHARGE
    record = MatchSystemSetting.first
    if record.nil?
      base_mobile
    else
      base_mobile = record.mobile_charge.nil? ? base_mobile : record.mobile_charge
    end
    base_mobile
  end

  def get_play_card_wait_time
    wait_time = ResultCode::PLAY_CARD_TIMEOUT
    record = MatchSystemSetting.first
    if record.nil?
      wait_time
    else
      wait_time = record.play_card_timing.nil? ? wait_time : record.play_card_timing
    end
    wait_time
  end

  def sign_up_get_money(user)
    return if user.nil?
    record = SystemSetting.find_by_setting_name("sign_up_get_money")
    return if record.nil?
    user_mobile_source_log(user.user_id,record.setting_value)
    user.user_profile.balance = user.user_profile.balance.to_i + record.setting_value.to_i
    user.user_profile.total_balance = user.user_profile.total_balance.to_i + record.setting_value.to_i
    user.user_profile.save
  end

  def user_mobile_source_log(user_id,num)
    user = User.find_by_user_id(user_id)
    return if user.robot==1
    Rails.logger.debug("user_mobile_source_log user_id=>#{user_id},num=>#{num}")
    record = UserMobileSource.new
    record.user_id = user_id
    record.num = num.to_f
    record.source = "#{num}元来源于注册"
    record.mobile_type = 1
    record.save
  end


end
