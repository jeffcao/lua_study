#encoding: utf-8

module BasicPaymentHelper

  def create_sync_basic_data(charge_url, basic_msg)

    charge_url = "http://#{charge_url}/basictest/pay_sync"

    logger.debug("create_sync_basic_data] =>#{charge_url}" )

    return_parameter ={"status" =>"success",
                       "cpparam" => basic_msg["cpparam"],
                       "price"=>basic_msg["price"],
                       "testMode"=>1,
                       "skip_forward"=>1}

    [charge_url, return_parameter]
  end
end