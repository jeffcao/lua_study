#encoding: utf-8

require "net/http"
require "em-http-request"
require "sms_config"
require 'digest'


include BasicPaymentHelper
include DadouPaymentHelper


class MobileMokeController < ApplicationController

  def get_sms_contain
    logger.debug("get_sms_contain_param : #{params.to_json}")
    return_xml = ""
    mobile_nm =  params["msisdn"].to_s
    sms_content = params["sms"].to_s
    charge_url = params["charge_url"].to_s
    client_app_id = params["client_app_id"].to_s
    skip = params["skip"].to_s
    payment = params["payment"].to_s
    logger.debug("[MobileMokeController.get_sms_contain] params[sms] =>#{sms_content}" )
    logger.debug("[MobileMokeController.get_sms_contain] payment=>#{payment}" )

    respond_to do |format|
      format.json  { render :xml => {:result=>"ok"} }
      format.text  { render :text => 'ok' }
    end

    return if skip != "0"


    #大豆模拟数据
    if payment == SMSConfig::DADOU
      dadou_msg = JSON.parse(sms_content)
      logger.debug("SMSConfig::DADOU, dadou_msg=>#{dadou_msg}")
      dadou_charge_url, return_data = create_dadou_data(charge_url, dadou_msg)

      EventMachine.run {
        http = EventMachine::HttpRequest.new(dadou_charge_url).post :body => return_data

      }
      return
    else
      base_msg = JSON.parse(sms_content)
      base_charge_url, return_data = create_sync_basic_data(charge_url, base_msg)
      
      EventMachine.run {
        http = EventMachine::HttpRequest.new(base_charge_url).post :body => return_data

      }
    end


  end

  def create_trans_id
    o =  [('A'..'Z'),(1..9)].map{|i| i.to_a}.flatten
    (0...17).map{ o[rand(o.length)] }.join
  end

end
