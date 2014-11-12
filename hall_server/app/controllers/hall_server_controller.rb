#encoding: utf-8

class HallServerController < ApplicationController
  include BuyPropHelper
  @@tran_channel = "hall"

  def transaction_notify

    respond_to do |format|
      format.text { render :text => 'nk' }
    end

    logger.debug("[transaction_notify] params => #{params.to_json}")
    notify_data = {:user_id => params["userid"],
                   :game_product_id => params["propid"], :result_code => params["resultcode"],
                   :status=>params["status"], :consumeCode => params["consumeCode"],
                   :tran_id => params["tranId"]}

    trade_record = PurchaseRequestRecord.find_by_request_seq(params["tranId"])
    sms = trade_record.request_command
    sms = JSON.parse(sms)
    logger.debug("[vip_level_up_notify] check_type => #{sms["check_type"]}")
    unless params["check_type"].nil?
      logger.debug("[transaction_notify] check_type => #{sms["check_type"]}")

      code_type = ['','sms_password','sms_code','voice_code' ]
      type = params["check_type"].to_i
      notify_data = {:user_id => params["userid"],
                     :game_product_id => params["propid"], :result_code => params["resultcode"],
                     :status=>params["status"], :consumeCode => params["consumeCode"],
                     :tran_id => params["tranId"],:type=>code_type[type]} if params["status"].to_i == 0
      notify_data = {:user_id => params["userid"],
                     :game_product_id => params["propid"], :result_code => params["resultcode"],
                     :status=>params["status"], :consumeCode => params["consumeCode"],
                     :tran_id => params["tranId"],:content=>"获取验证码失败."} if params["status"].to_i != 0
      logger.debug("[transaction_notify] notify_data => #{notify_data}")

      channel = "#{params["userid"]}_hall_channel"

      logger.debug("[transaction_notify] channel => #{channel}")

      HallLogic.unicom_code(notify_data,channel)
      return
    end


    HallLogic.do_transaction_notify notify_data
  end

  def vip_level_up_notify
    logger.debug("[vip_level_up_notify] params => #{params.to_json}")
    get_salary = 0
    date = Time.now.strftime("%Y-%m-%d")
    salary_record = GetSalary.find_by_date_and_user_id(date,params["userid"])
    get_salary = 1 unless salary_record.nil?
    respond_to do |format|
      format.text { render :text => 'nk' }
    end
    vips = ResultCode::VIP
    salary = 0
    vips.each do |salary_vip|
       vip = salary_vip.split("-")
       salary = vip[2]
       break if vip[0].to_i == params["vip_level"].to_i
    end

    user_id = params["userid"]
    true_user = User.find_by_user_id(user_id)
    user = Player.get_player(user_id)
    unless user.nil?
      user.player_info.vip_level = params["vip_level"]
      user.player_info.save
    end
    lv = percent(params["vip_level"].to_i,true_user.total_consume.to_f)
    notify_data = {:user_id => params["userid"],
                   :vip_level => params["vip_level"],
                   :notify_type => ResultCode::VIP_UP_TYPE,
                   :percent => lv,
                   :salary => salary,
                   :get_salary=>get_salary
                  }
    HallLogic.do_vip_level_notify notify_data
  end

  def prop_expired_notify
    logger.debug("[prop_expired_notify] params => #{params.to_json}")
    notify_data = {:user_id => params["userid"], :prop_id =>params["propid"], :notify_type => ResultCode::PROP_EXPIRED_TYPE}

    respond_to do |format|
      format.text  { render :text => 'nk' }
    end

    HallLogic.do_prop_expired_notify notify_data

  end

  def new_activity
    day = Time.now.wday
    record = Activity.find_by_week_date(day)
    return if record.nil?
    notify_data = {
                    :week=>day,
                    :object=>record.activity_object,
                    :content => record.activity_content,
                    :name => record.activity_name,
                    :result_code => params[:result_code],
                    :notify_type => ResultCode::NEW_ACTIVITY_TYPE

    }
    event_name = "ui.routine_notify"
    respond_to do |format|
      format.text { render :text => 'ok' }
    end
    GameHallController.broadcast_message(event_name,notify_data)

  end

  def score_level_notify
    logger.debug("[HallServerController.score_level_notify]")
    user_id = params[:user_id]
    score = params[:score].to_i
    logger.debug("[HallServerController.score_level_notify], user_id=>#{user_id}, scpre=>#{score}")
    respond_to do |format|
      format.text { render :text => 'nk' }
    end
    logger.debug("[HallServerController.score_level_notify], user_id=>#{user_id}, scpre=>#{score}")


    return if user_id.nil?
    user = User.find_by_user_id(user_id)
    level = new_level = user.game_level
    logger.debug("[HallServerController.score_level_notify], level=>#{level}")
    if score < 0
      new_level = "短工"
    elsif score > 1216700000
      new_level = "仁主"
    else
      level_result = Level.where(["min_score<=? and max_score>=?",score,score]).first
      new_level = level_result.name  unless level_result.nil?
    end
    logger.debug("[HallServerController.score_level_notify], new_level=>#{new_level}")
    if level!=new_level
      notify_data = {:user_id => user_id,
                     :game_level => new_level

      }
      user.game_level = new_level
      user.save
      HallLogic.do_user_level_notify(notify_data)
    end


  end


  def percent(vip_level, total_consume)
    vip = ResultCode::VIP

    last_index = vip_level - 1
    next_index = vip_level
    last_money = vip[last_index].split("-")[1].to_i
    next_money = vip[next_index].split("-")[1].to_i
    result = (total_consume - last_money).to_f/(next_money - last_money)
    result = result*0.25 + (last_index/4.0)
    result=result*100
    result.to_i
  end



end