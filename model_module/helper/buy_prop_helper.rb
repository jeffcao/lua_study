#encoding: utf-8

module BuyPropHelper
  def buy_prop
    user_id = message[:user_id]
    #type = message[:type]
    prop_id = message[:prop_id]

    payment = message[:payment]
    prop = GameProduct.find(prop_id)
    @consume_code = "000000000000"
    @consume_code = prop.prop_consume_code.consume_code unless  prop.prop_consume_code.nil?
    s_f_setting = SystemSetting.find_by_setting_name("ddz_server_flag")
    server_flag = "0"
    server_flag = s_f_setting.setting_value.to_s unless s_f_setting.nil?

    seq_time = user_id.to_s + server_flag + Time.now.to_i.to_s
    seq_time = Digest::MD5.hexdigest("#{user_id}#{Time.now.to_i}")

    logger.debug("[buy_prop] seq_time=> #{seq_time.to_s}")
    logger.debug("[buy_prop] client_app_id=> #{client_app_id.to_s}")
    logger.debug("[buy_prop] payment=> #{payment.to_s}")
    seq_time = seq_time[8,16]
    logger.debug("[buy_prop] seq_time=> #{seq_time.to_s}")

    if payment.to_s == ResultCode::DADOU
      dadou_buy_handler(prop_id,seq_time,user_id)
    elsif payment.to_s == ResultCode::PAYMENT_BASIC_DEMO
      basic_buy_handler(prop_id,seq_time,user_id,server_flag)
    end

    player = Player.get_player(user_id)
    #player.on_after_shopping do |text, voice, u_id|
    #  channel_name = "#{u_id}_hall_channel"
    #
    #  notify_data = {user_id:u_id, :text=> text, :voice=> voice, :notify_type=>ResultCode::PROP_VOICE}
    #  WebsocketRails[channel_name].trigger("ui.routine_notify",notify_data)
    #end

  end

  
  def buy_prop_timing(trade_id, prop_id, user_id, sms, need_timer=true,phonenumber=nil)
    #sms = JSON.parse(sms.to_json)
    new_purchase_record(prop_id, sms, trade_id, user_id)
    Rails.logger.debug("[GameShopPropHelper.buy_prop_timing], sms=>#{sms}.")

    Rails.logger.debug("[GameShopPropHelper.buy_prop_timing], saved.")
    Rails.logger.debug("[GameShopPropHelper.buy_prop_timing], client_run_evn=>#{client_run_evn}")

    allow_test_buy_set = SystemSetting.find_by_setting_name("allow_test_buy")
    allow_test_buy = 0
    allow_test_buy = allow_test_buy_set.setting_value.to_i unless allow_test_buy_set.nil?
    Rails.logger.debug("[GameShopPropHelper.buy_prop_timing], allow_test_buy=>#{allow_test_buy}")

    if allow_test_buy == 1 and client_run_evn == "test" or sms[:payment] ==ResultCode::PAYMENT_BASIC_DEMO
      notify_3d_market(sms)
    else
      if sms[:payment] == ResultCode::UNICOM
        unicom_notify_3d_market(sms)
      end

    end
    Rails.logger.debug("[GameShopPropHelper.buy_prop_timing], sms=>#{sms[:payment]}.")


    logger.debug("[buy_prop_timing] trade_id=>#{trade_id}, prop_id=>#{prop_id}")
    logger.debug("[buy_prop_timing] timeout=>#{ResultCode::TIMING_BUY_PROP}")

  end

  def new_purchase_record(prop_id, sms, trade_id, user_id)
    trade = PurchaseRequestRecord.new
    trade.user_id = user_id
    trade.user_product_id = 1
    trade.game_product_id = prop_id
    trade.product_count =1
    trade.request_seq = trade_id
    trade.request_type = client_app_id
    trade.server_flag = sms[:server_flag]
    trade.request_command = sms.to_json
    trade.appid = User.find_by_user_id(user_id).appid unless User.find_by_user_id(user_id).nil?
    trade.price = GameProduct.find(prop_id).price.to_i unless GameProduct.find(prop_id).nil?
    Rails.logger.debug("[GameShopPropHelper.timing_buy_prop], sms:#{sms}")
    trade.request_time = Time.now
    trade.operator_type = "CP"
    trade.state = 0
    trade.save
  end

  
  def notify_3d_market(sms)
    Rails.logger.debug("[notify_3d_market], sms=>#{sms}")

    EventMachine.add_timer(1) do

      url_str = get_server_rul
      charge_url_str = get_charge_server_rul
      Rails.logger.debug("[timing_buy_prop], url_str=>#{url_str}")
      url = "http://#{url_str}/getsmscontain"
      tmp_sms = sms
      unless sms.class == String
        tmp_sms = sms.to_json
      end
      Rails.logger.debug("[timing_buy_prop], payment=>#{JSON.parse(tmp_sms)["payment"]}")

      Rails.logger.debug("[timing_buy_prop], url=>#{url}")
      EventMachine.run {

        http = EventMachine::HttpRequest.new(url).get :query => {:msisdn => "13510419952", :skip => 0, :sms => tmp_sms,
                                                                 :charge_url => charge_url_str,
                                                                 :client_app_id => client_app_id,
                                                                 :payment =>JSON.parse(tmp_sms)["payment"]}
        http.errback {
          logger.debug("[GameShopPropController.timing_buy_prop] http.errback, #{http.error}/#{http.response}")
          #EM.stop
        }
        http.callback {
          logger.debug("[GameShopPropController.timing_buy_prop], http.callback, response.content=>#{http.response}")
          #EventMachine.stop
        }
      }

    end
  end

 
  def check_record(user_id, prop_id)
    Rails.logger.debug("[GameShopPropHelper.check_record], user_id:#{user_id},prop_id:#{prop_id}")
    record = PurchaseRequestRecord.where(["user_id=? and game_product_id=? and state=?", user_id, prop_id, 0]).count
    Rails.logger.debug("[GameShopPropHelper.check_record], record:#{record}")

    if record < 1
      true
    else
      false
    end

  end

  def cancel_buy_prop
    result_code = ResultCode::SUCCESS
    trade_id = message[:trade_num]
    prop_id = message[:prop_id]
    user_id = trade_id[0..4]
    msg = {
      :result_code => result_code
    }
    logger.debug("[cancel_buy_prop] trade_id=>#{trade_id}, prop_id=>#{prop_id}")
    trigger_success(msg)
    record = PurchaseRequestRecord.find_by_request_seq(trade_id)
    unless record.nil? or record.reload(:lock => true).nil? or record.reload(:lock => true).state != 0
      record.state = 2
      record.save
    end
    buy_timer = connection_store["buy_timer_#{trade_id}"]
    unless buy_timer.nil?
      buy_timer.cancel
    end
  end


  def get_charge_server_rul
    url_str = "http://localhost:5001"
    hall_server = SystemSetting.find_by_setting_name("ddz_charge_server_url")

    url_str = hall_server.setting_value unless hall_server.nil?
    url_str
  end

  
  def dadou_buy_handler(prop_id,seq_time,user_id)
    prop = GameProduct.find(prop_id)
    Rails.logger.debug("[dadou_buy_handler.prop]=>#{prop.id}")
    price = prop.price.to_i

    productName = prop.product_name unless prop.nil?
    msg = {:prop_id=>prop_id,
           :cpparam=>seq_time,
           :productName =>productName,
           :price=>price,
           :trade_num => seq_time
    }
    msg_clone = msg.clone.merge({:payment =>ResultCode::DADOU})
    Rails.logger.debug("[dadou_buy_handler.msg]=>#{msg}")
    trigger_success({:result_code=>ResultCode::SUCCESS,:orderInfo =>msg})

    buy_prop_timing(seq_time, prop_id, user_id, msg_clone)

  end

  def basic_buy_handler(prop_id,seq_time,user_id,server_flag)
    prop = GameProduct.find(prop_id)
    Rails.logger.debug("[basic_buy_handler.prop]=>#{prop.id}")
    price = prop.price.to_i

    productName = prop.product_name unless prop.nil?
    msg = {:prop_id=>prop_id,
           :cpparam=>seq_time,
           :productName =>productName,
           :price=>price,
           :trade_num => seq_time,
           :server_flag=>server_flag
    }
    msg_clone = msg.clone.merge({:payment =>ResultCode::PAYMENT_UNICOM_TEST})
    Rails.logger.debug("[basic_buy_handler.msg]=>#{msg}")
    trigger_success({:result_code=>ResultCode::SUCCESS,:orderInfo =>msg})

    buy_prop_timing(seq_time, prop_id, user_id, msg_clone)
  end

end