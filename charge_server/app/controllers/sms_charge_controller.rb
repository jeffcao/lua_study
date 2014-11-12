#encoding: utf-8
require "net/http"
require "synchronization"
require "charge_config"
require "result_code"

require 'digest'


class SmsChargeController < ApplicationController

  include SmsChargeHelper
  include BasicChargeHelper
  include DadouChargeHelper


  def publish_vip_level_notify
    user_id = @user_id
    logger.debug("publish_vip_level_notify,user_id=>#{user_id},product_id=>#{@product_id}")

    user = User.find_by_user_id(user_id)
    if not @product_id.blank?
      prop = GameProduct.find(@product_id)
      buy_shop_prop(user, prop)
      flag, vip = save_user_consume(user, prop.id)
      logger.debug("vip_level_url,flag=>#{flag}")

      if flag
        url_str = get_server_rul
        url = "http://#{url_str}/hall/vip_level_notify"
        logger.debug("vip_level_url=>#{url}")
        EventMachine.run {
          http = EventMachine::HttpRequest.new(url).get :query => {:userid => "#{user_id}", :vip_level => "#{vip}"}
          http.errback {
            logger.debug("[SmsChargeController.publish_vip_level_notify] http.errback, #{http.error}/#{http.response}")
            #EM.stop
          }
          http.callback {
            logger.debug("[SmsChargeController.publish_vip_level_notify], http.callback, response.content=>#{http.response}")
            #EventMachine.stop
          }
        }
      end
    end
  end



  def get_response_data(h_ret, message)
    tmp_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    tmp_xml = tmp_xml + " <response>"
    #tmp_xml = tmp_xml + " <transIDO>#{trans_id}</transIDO>"
    tmp_xml = tmp_xml + " <hRet>#{h_ret}</hRet>"
    tmp_xml = tmp_xml + " <message>#{message}</message>"
    @return_xml = tmp_xml + " </response>"
  end

  def check_request_valid?
    return false if @operator_data.nil?
    #if @operator_data["cpid"] != ChargeConfig::CP_ID
    #  logger.debug("[SmsChargeController.check_request_valid] cpid does not match.")
    #  return [false, "cpid does not match"]
    #end

    get_product_id_by_consume_code

    if @product_id.blank?
      logger.debug("[SmsChargeController.check_request_valid] product_id does not exist.")
      return [false, "product_id does not exist"]
    end

    get_purchase_record
    if @purchase_r.blank?
      logger.debug("[SmsChargeController.check_request_valid] purchase does not exist.")
      return [false, "purchase does not exist"]
    end

    if @purchase_r.state == 1
      logger.debug("[SmsChargeController.check_request_valid] purchase already was finished.")
      return [false, "purchase had been cancelled"]
    end
    if @purchase_r.state == 2
      logger.debug("[SmsChargeController.check_request_valid] purchase already was cancelled.")
      return [false, "purchase had been cancelled"]
    end

    [true, "Successful"]

  end

  def update_purchase_r_retry
    unless @purchase_r.blank?
      @purchase_r.retry_times = @purchase_r.retry_times + 1
      @purchase_r.save
    end
  end

  def update_purchase_records
    unless @purchase_r.blank?
      if @hRet.to_i == 0
        @purchase_r.state = 1
        game_prop= GameProduct.find(@purchase_r.game_product_id)
        @purchase_r.real_amount = @real_amount.nil? ? game_prop.price : @real_amount

        #user_id = @purchase_r.request_seq.to_s[0, 5]
        user_id = PurchaseRequestRecord.find_by_request_seq(@purchase_r.request_seq).user_id
        logger.debug("[SmsChargeController.update_purchase_records] game_product_id=>#{@purchase_r.game_product_id}")
        logger.debug("[SmsChargeController.update_purchase_records] product_name=>#{game_prop.product_name}")
        if game_prop.product_name == ResultCode::SHOUCHONGDALIBAO
          user = User.find_by_user_id(user_id)
          user.user_profile.first_buy = 1
          shouchong_money = ResultCode::SHOUCHONG_GET_MONEY
          user_mobile_source_log(user.user_id, shouchong_money.to_i)
          user.user_profile.balance = shouchong_money.to_i + user.user_profile.balance.to_i
          user.user_profile.total_balance = shouchong_money + user.user_profile.total_balance.to_i
          #user.user_profile.balance = user.user_profile.balance + ResultCode::SHOUCHONG_GET_MONEY.to_i
          user.user_profile.save
        end
      else
        @purchase_r.state = 2
      end
      @purchase_r.save
    end
  end


  def user_mobile_source_log(user_id, num)
    user = User.find_by_user_id(user_id)
    return if user.robot==1
    Rails.logger.debug("user_mobile_source_log user_id=>#{user_id},num=>#{num}")
    record = UserMobileSource.new
    record.user_id = user_id
    record.num = num.to_f
    record.source = "#{num}元来源于首充大礼包"
    record.mobile_type = 2
    record.save
  end

  def new_p_transaction_record
    purchase_request_id = nil
    purchase_request_id = @purchase_r.id unless @purchase_r.blank?

    purchase_transaction_r = PurchaseTransactionRecord.new

    purchase_transaction_r.operator_user_id = @user_id
    purchase_transaction_r.request_id = purchase_request_id unless purchase_request_id.blank?
    purchase_transaction_r.request_ip = @request_ip
    purchase_transaction_r.request_message = @request_body.to_json
    logger.debug("[SmsChargeController.new_p_transaction_record] request_message =>" +
                   purchase_transaction_r.request_message.to_json)
    purchase_transaction_r.request_time = @request_time
    #purchase_transaction_r.request_url = nil.to_s
    purchase_transaction_r.response_message = @return_xml
    logger.debug("[SmsChargeController.new_p_transaction_record] response_message =>" +
                   purchase_transaction_r.response_message.to_s)
    purchase_transaction_r.response_time = @response_time
    purchase_transaction_r.elapsed_time = @response_time - @request_time

    purchase_transaction_r.save
  end

  def get_product_id_by_consume_code
    p_c_map = PropConsumeCode.where({:consume_code => @consume_code}).first
    @product_id = p_c_map.game_product_id unless p_c_map.blank?
  end

  def get_purchase_record
    @purchase_r = PurchaseRequestRecord.where({:request_seq => @cpparam}).first
  end

  def publish_result_to_hall_server(options=nil)

    #EventMachine.add_timer(2) do
    logger.debug("[SmsChargeController.publish_result_to_hall_server] ")
    logger.debug("[SmsChargeController.publish_result_to_hall_server], options=>#{options.to_json}")
    url_str = get_server_rul

    url = "http://#{url_str}/hall/tran_notify"

    logger.debug("[SmsChargeController.publish_result_to_hall_server], url=>#{url_str}")
    event_data = {:userid => "#{@user_id}", :propid => "#{@product_id}",
                  :resultcode => "#{@hRet}",
                  :status => "#{@status}",
                  :consumeCode => "#{@consume_code}",
                  :tranId => "#{@cpparam}"}

    event_data.merge!(options) unless options.nil?

    logger.debug("[SmsChargeController.publish_result_to_hall_server], event_data=>#{event_data.to_json}")

    EventMachine.run {
      http = EventMachine::HttpRequest.new(url).get :query => event_data

      http.errback {
        logger.debug("[SmsChargeController.publish_result_to_hall_server] http.errback, #{http.error}/#{http.response}")
      }
      http.callback {
        logger.debug("[SmsChargeController.publish_result_to_hall_server], http.callback, response.content=>#{http.response}")
      }
    }

    logger.debug("[SmsChargeController.publish_result_to_hall_server] user_id=>#{@user_id},game_product_id=>#{@product_id}")

  end

  def xml_test
    h_ret = "aaabbb"
    message = "cccdddd"
    tmp_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    tmp_xml = tmp_xml + " <response>"
    #tmp_xml = tmp_xml + " <transIDO>#{trans_id}</transIDO>"
    tmp_xml = tmp_xml + " <hRet>#{h_ret}</hRet>"
    tmp_xml = tmp_xml + " <message>#{message}</message>"
    @return_xml = tmp_xml + " </response>"
    render :xml => @return_xml
  end

  

end
