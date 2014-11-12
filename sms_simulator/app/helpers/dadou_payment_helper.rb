#encoding: utf-8

module DadouPaymentHelper
  def create_dadou_data(charge_url, dadou_params)
    charge_url = "http://#{charge_url}/dadou/pay_sync"
    logger.debug("create_dadou_data] =>#{charge_url}" )

    pay_num = Time.now.strftime("%Y%m%d%H%M%S")

    return_parameter ={"addtime" => pay_num,
                       "money" => dadou_params["price"],
                       "customorderid"=> dadou_params["trade_num"],
                       "success"=>1,
                       "custominfo" => dadou_params["cpparam"],
                       "gameid" => "asdfas0df080asdf",
                       "testMode"=>1,
                       "skip_forward"=>1
    }


    [charge_url, return_parameter]
  end
end