require "em-http-request"

module SmsChargeHelper
  def buy_shop_prop(user,prop_id)
    logger.debug("[buy_shop_prop] => user_id =>#{user.user_id},prop_id=>#{prop_id}")
    prop = GameProduct.find(prop_id)
    if prop.state == 0   #    the product can be soled
      prop_sell_count(prop)
      #user_product_save(user,prop)
      prop_items  = prop.product_product_item
      buy_product_item(user,prop_items, prop)
    end
  end

  def buy_product_item(user,prop_items, prop)
    prop_items.each do |prop_item|
      logger.debug("[buy_product_item] prop_item.game_product_item_id=>#{prop_item.game_product_item_id}")

      item = GameProductItem.find(prop_item.game_product_item_id)
      logger.debug("[buy_product_item],user_id=>#{user.user_id},item_id=>#{item.id}")

      if not item.using_point.nil? and item.using_point.to_i == 1 and item.respond_to?(:take_effect)
        #user.game_score_info.score = user.game_score_info.score + item.beans
        #user.game_score_info.save
        logger.debug("[buy_product_item] call item.take_effect")
        item.take_effect(user.id, {:beans=>item.beans})
        url_str = get_server_rul
        url = "http://#{url_str}/hall/game_level_notify"
        logger.debug("[buy_product_item] url=>#{url}")

        EventMachine.run {
          http = EventMachine::HttpRequest.new(url).get :query =>{:user_id=>"#{user.user_id}",:score=>"#{user.reload(:lock=>true).game_score_info.score}"}
          http.errback {
            logger.debug("[SmsChargeHelper.buy_product_item] http.errback, #{http.error}/#{http.response}")
            #EM.stop
          }
          http.callback {
            logger.debug("[SmsChargeHelper.buy_product_item], http.callback, response.content=>#{http.response}")
            #EventMachine.stop
          }
        }
      else
        logger.debug("[buy_product_item] user_product_item_count_save")

        user_product = UserProductItemCount.find_by_user_id_and_game_product_item_id(user.id,item.id)
        user_product_count = user_product || UserProductItemCount.new
        user_product_count.user_id = user.id
        user_product_count.game_product_item_id = item.id
        user_product_count.item_count = user_product_count.item_count + prop_item.count
        user_product_count.save

      end
      user_product_info_save(user,item, prop)
    end

  end


  def prop_sell_count(prop)
    if /^.*[vV][iI][pP].*/.match(prop.product_name)
       VipCount.count(prop.product_name)
    end

    logger.debug("[prop_sell_count],prop=>#{prop.id}")
    prop_count = prop.game_product_sell_count || GameProductSellCount.new
    prop_count.game_product_id = prop.id
    prop_count.sell_count = prop_count.sell_count.to_i + 1
    prop_count.save
  end

  def user_product_info_save(user,prop_item, prop)
    logger.debug("[user_product_info_save],user=>#{user.user_id}")
    logger.debug("[user_product_info_save],prop_item=>#{prop_item.id}")

    user_product = UserProduct.new
    user_product.game_id = prop.game_id
    user_product.note = prop.note
    user_product.product_name = prop.product_name
    user_product.product_type = prop.product_type
    user_product.user_id = user.user_id
    user_product.price = prop.price
    user_product.sale_limit = prop.sale_limit
    user_product.state = prop.state
    user_product.icon = prop.icon
    user_product.product_sort = prop.product_sort
    user_product.request_seq = @purchase_r.request_seq
    user_product.save

    user_product_item = UserProductItem.new
    user_product_item.user_id = user.user_id
    user_product_item.game_id = prop_item.game_id
    user_product_item.item_name = prop_item.item_name
    user_product_item.item_note = prop_item.item_note
    user_product_item.cate_module = prop_item.cate_module
    user_product_item.using_point = prop_item.using_point
    user_product_item.beans = prop_item.beans
    user_product_item.item_feature = prop_item.item_feature
    user_product_item.game_item_id = prop_item.id
    user_product_item.request_seq = @purchase_r.request_seq
    user_product_item.save
  end

  def save_user_consume(user,prop_id)
    return if prop_id.nil?
    vip_level = user.vip_level
    prop = GameProduct.find(prop_id)

    logger.debug("[prop_sell_count],prop_id=>#{prop.id},user_id=>#{user.user_id}")
    price = prop.price.to_f/100
    user.total_consume = user.total_consume.to_f + price
    user_consume = user.total_consume
    if user_consume>0 && user_consume<=9
      user.vip_level = 1
    elsif user_consume >9 && user_consume<= 99
      user.vip_level = 2
    elsif user_consume >99 && user_consume<= 999
      user.vip_level = 3
    elsif user_consume > 999
      user.vip_level = 4
    end
    user.save
     if vip_level != User.find(user).reload(:lock=>true).vip_level
       [true,User.find(user).reload(:lock=>true).vip_level]
     else
       [true,User.find(user).reload(:lock=>true).vip_level]
     end
  end

  def get_server_rul
    url_str = "http://localhost:5001"
    sms_simulator =  SystemSetting.find_by_setting_name("ddz_hall_url")

    url_str = sms_simulator.setting_value unless sms_simulator.nil?
    url_str
  end

  def get_charge_url
    url_str = "charge-test.170022.cn"
    charge_setting =  SystemSetting.find_by_setting_name("ddz_charge_server_url")

    url_str = charge_setting.setting_value unless sms_simulator.nil?
    url_str
  end

  def get_oa_url
    url_str = "http://admin.cn6000.com/admin"
    sms_simulator =  SystemSetting.find_by_setting_name("ddz_oa_server_url")

    url_str = sms_simulator.setting_value unless sms_simulator.nil?
    url_str
  end

end
