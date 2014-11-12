#encoding: utf-8
module MobileChargeHelper
  def mobile_charge_list
    user_id = message[:user_id]
    user = User.find_by_user_id(user_id)
    if UserMobileList.first.nil?
      trigger_success({result_code:ResultCode::SUCCESS,list:[],position:0,next_time:30.minutes.to_i,balance:user.user_profile.balance.to_i})
      return
    end
    next_time = 7.5.hours.ago(UserMobileList.first.created_at).to_s
    time = (DateTime.parse(next_time) - DateTime.parse(Time.now.to_s))* 24 * 60 * 60
    time = time.to_i


    my_self = UserMobileList.where("user_id"=>user.id).first
    unless my_self.nil?
      position = my_self.position
    else
      position = 0
    end
    return_msg = []
    records = UserProfile.offset(0).limit(50).order("total_balance desc")
    id = 1
    records.each do |record|
      return_msg = return_msg.push({id:id,user_id:record.user_id,balance:record.balance.to_i,nick_name:record.nick_name,total_balance:record.total_balance.to_i})
      id = id + 1
    end
    logger.debug("[controller.mobile_charge_list] return_msg=>#{return_msg}")

    trigger_success({result_code:ResultCode::SUCCESS,list:return_msg,position:position,next_time:time,balance:user.user_profile.balance.to_i})
  end

  def get_mobile_charge
    user_id = message[:user_id]
    mobile = message[:mobile]
    if mobile.nil?
      m_log = GetMobileChargeLog.where("user_id"=>user_id).first

      if m_log.nil? or m_log["mobile"].nil?
        trigger_failure({result_code:ResultCode::USER_HAVE_NO_MOBILE})
        return
      else
        mobile = m_log["mobile"]
      end
    end



    flag = mobile.match(/^[1][3458][0-9]{9}$/)
    if flag.nil?
      trigger_failure({result_code:ResultCode::USER_HAVE_NOT_ENOUGH_MOBILE,content:ResultCode::ERR_MOBILE})
      return
    end
    user = User.find_by_user_id(user_id)
    logger.debug("[controller.get_mobile_charge] user_id=>#{user_id}")
    base_mobile = MatchSystemSetting.first.mobile_charge unless MatchSystemSetting.first.nil?
    base_mobile = base_mobile.nil? ? "#{ResultCode::USER_GET_MOBILE_CHARGE}":base_mobile
    base_mobile = base_mobile.to_i
    can_get_mobile = user.reload(:lock=>true).user_profile.balance.to_i/base_mobile
    logger.debug("[controller.get_mobile_charge] can_get_mobile=>#{can_get_mobile}")

    if can_get_mobile == 0
      get_charge_fail = ResultCode::GET_CHARGE_FAIL
      system_mobile = ResultCode::USER_GET_MOBILE_CHARGE
      base_mobile = MatchSystemSetting.first.mobile_charge unless MatchSystemSetting.first.nil?
      base_mobile = base_mobile.nil? ?  system_mobile:base_mobile
      get_charge_fail = get_charge_fail.gsub("money",base_mobile.to_s)
      trigger_failure({result_code:ResultCode::USER_HAVE_NOT_ENOUGH_MOBILE,content:get_charge_fail})
    else
      content = ResultCode::GET_CHARGE_TEXT
      content = content.gsub("n","#{can_get_mobile*base_mobile}")
      get_charge = can_get_mobile*base_mobile
      user.user_profile.balance = user.user_profile.balance-get_charge
      user.user_profile.save
      record = GetMobileChargeLog.new
      record.user_id = user_id
      record.fee = can_get_mobile*base_mobile
      record.update_attributes("mobile"=>mobile)
      record.save
      logger.debug("[controller.get_mobile_charge] mobile_charge=>#{can_get_mobile*base_mobile},left_charge=>#{user.reload(:lock=>true).user_profile.balance}")
      trigger_success({result_code:ResultCode::SUCCESS,mobile_charge:get_charge,left_charge:user.reload(:lock=>true).user_profile.balance.to_i,content:content})
    end

  end

  def user_score_list
    user_id = message[:user_id]
    next_time = 7.5.hours.ago(UserScoreList.first.created_at).to_s
    time = (DateTime.parse(next_time) - DateTime.parse(Time.now.to_s))* 24 * 60 * 60
    time = time.to_i
    #result = GameScoreInfo.limit(ResultCode::PAGE_SIZE).offset(page*ResultCode::PAGE_SIZE).order("score desc").order("created_at asc")
    #page = page.to_i
    result = UserScoreList.limit(50).offset(0).order("id asc")
    Rails.logger.debug("user_score_list.user_id=>#{user_id}")

    #result = UserScoreList.all
    notify_data = Array.new
    i = 1
    result.each do |item|
      message = {
          :id => i,
          :user_id => item.user_id,
          :nick_name => item.nick_name,
          :score => item.score
      }
      i = i + 1
      notify_data.push(message)
    end
    Rails.logger.debug("user_score_list.notify_data=>#{notify_data}")

    myself = UserScoreList.find_by_user_id(user_id)

    unless myself.nil?
      position =myself.id - UserScoreList.first.id + 1
    else
      position = 0
    end
    #time = 15  # 测试时间
    result = {:list => notify_data, :next_time => time, :position => position,result_code:ResultCode::SUCCESS}
    trigger_success(result)
  end

end
