#encoding: utf-8

module BasicChargeHelper

  def basic_pay_sync
    @request_time = Time.now
    logger.debug("[basic_pay_sync], request_time: #{@request_time}")
    @request_ip = request.env["REMOTE_ADDR"]
    logger.debug("[basic_pay_sync], request_ip: #{@request_ip }")
    @request_body = request.body.gets() if request.post?
    @request_body = request.url if request.get?
    logger.debug("request => #{@request_body}")
    logger.debug("get_msg: #{params}")

    render :text => 'success', :content_type => 'application/text'

    @operator_data = params

    basic_charge
  end

  def basic_charge
    logger.debug("[basic_charge]")

    @cpparam = @operator_data["cpparam"]
    @status = @operator_data["status"]
    record = PurchaseRequestRecord.find_by_request_seq(@cpparam)
    #@user_id = @cpparam.to_s[0, 5]
    @user_id = record.user_id
    @real_amount = @operator_data["price"].to_i

    if @status=="success"
      @hRet = 0
    else
      @hRet =1
    end

    @purchase_r = PurchaseRequestRecord.where({:request_seq => @cpparam}).first

    if @purchase_r.blank?
      logger.debug("[SmsChargeController.basic_charge] purchase does not exist.")
      return
    else
      @product_id = @purchase_r.game_product_id
      prop = GameProduct.find(@product_id)
      logger.debug("[SmsChargeController.basic_charge=>#{@product_id}")

      @consume_code = prop.prop_consume_code.nil? ? 0 : prop.prop_consume_code.consume_code
    end

    if @purchase_r.game_product_id.blank?
      logger.debug("[SmsChargeController.basic_charge] product_id does not exist.")
      return
    end

    if @purchase_r.state == 1
      logger.debug("[SmsChargeController.basic_charge] purchase already was finished.")
      return
    end

    if @purchase_r.state == 2
      logger.debug("[SmsChargeController.basic_charge] purchase already was cancelled.")
      return
    end
    logger.debug("[SmsChargeController.basic_charge]user_id=>#{@user_id},@product_id=>#{@product_id},@hRet=>#{@hRet},consumeCode=>#{@consume_code},@cpparam=>#{@cpparam}")

    @response_time = Time.now
    update_purchase_records
    new_p_transaction_record

    publish_result_to_hall_server unless @purchase_r.blank?
    publish_vip_level_notify() if @hRet == 0

  end
end