#encoding: utf-8
module GameShopPropHelper
  def get_all_prop
    user_id =message[:user_id]
    user = User.find_by_user_id(user_id)
    show_flag = judge_show_prop(user_id,"show_props")
    type = message[:prop_type]
    props = GameProduct.where(["state!=?", 2]).order("product_type,product_sort,id asc")
    unless type.nil?
      props = GameProduct.where(["state!=? and product_type=?", 2, type.to_i]).order("product_type,product_sort,id asc")
    end
    shop_prop = []
    if show_flag
      props.each do |prop|
        name = ResultCode::SHOUCHONGDALIBAO
        if prop.product_name.to_s == name.to_s
          next
        end

        consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code

        prop_msg = {:id => prop.id,
                    :name => prop.product_name,
                    :price => prop.price,
                    :note => prop.note,
                    :rmb => prop.price.to_f/100,
                    :type => "box",
                    :icon => prop.icon,
                    :consume_code => consume_code
        }
        shop_prop.push(prop_msg)
      end
    end
    # GameTeaching.user_game_teach(user_id, "shop")
    msg = {:commodity => shop_prop, :type => type}
    logger.debug "get_all_prop_msg #{msg.to_json}"

    msg
  end

  def buy_shop_prop(user, prop_id)
    prop = GameProduct.find(prop_id)
    if prop.state == 0 #    the product can be soled
      prop_sell_count(prop)
      user_product_save(user, prop)
      prop_items = prop.product_product_item
      buy_product_item(user, prop_items)
    end
  end


  def buy_product_item(user, prop_items)

    prop_items.each do |prop_item|
      item = GameProductItem.find(prop_item.game_product_item_id)
      user_product_item_save(user, item)
      if item.beans.to_i > 0
        user.game_score_info.score = user.game_score_info.score + item.beans
        user.game_score_info.save
      else
        user_product = UserProductItemCount.find_by_user_id_and_user_product_item_id(user.id, item.id)
        user_product_count = user_product || UserProductItemCount.new
        user_product_count.user_id = user.id
        user_product_count.user_product_item_id = item.id
        user_product_count.item_count = user_product_count.item_count + 1
        user_product_count.save
      end
    end

  end


  def prop_sell_count(prop)
    prop_count = prop.game_product_sell_count || GameProductSellCount.new
    prop_count.game_product_id = prop.id
    prop_count.sell_count = prop_count.sell_count.to_i + 1
    prop_count.save
  end

  def user_product_save(user, prop)
    user_product = UserProduct.new
    user_product.user_id = user.id
    user_product.game_id = prop.game_id
    user_product.product_name = prop.product_name
    user_product.product_type = prop.product_type
    user_product.note = prop.note
    user_product.price = prop.price
    user_product.sale_limit = prop.sale_limit
    user_product.state = prop.state
    user_product.save
  end

  def user_product_item_save(user, prop_item)
    user_product_item = UserProductItem.new
    user_product_item.user_id = user.id
    user_product_item.game_id = prop_item.game_id
    user_product_item.item_name = prop_item.item_name
    user_product_item.item_note = prop_item.item_note
    user_product_item.cate_module = prop_item.cate_module
    user_product_item.using_point = prop_item.using_point
    user_product_item.beans = prop_item.beans
    user_product_item.save
  end


  def buy_treasure_box(user, box_id)
    treasure_box = TreasureBox.find(box_id)
    treasure_box.sale_count = 0 if treasure_box.sale_count.nil?
    treasure_box.sale_count = treasure_box.sale_count + 1
    treasure_box.save
    logger.debug "buy_treasure_box_treasure_box#{treasure_box}"
    game_user = GameScoreInfo.find_by_user_id(user.id)
    game_user = GameScoreInfo.new if game_user.nil?
    game_user.user_id = user.id
    game_user.score = 0 if game_user.score.nil?
    game_user.score = game_user.score + treasure_box.beans + treasure_box.give_beans
    game_user.save
    logger.debug "buy_treasure_box_game_user#{game_user}"
    log = SpendCateLog.new
    log.user_id = user.id
    log.treasure_box_id = box_id
    log.add_date = Time.now
    log.spend_count = 1
    log.save
    list = cate_list(user)
    msg = {:result_code => ResultCode::SUCCESS,
           :score => game_user.score,
           :name => treasure_box.name,
           :list => list
    }

    msg
  end

  def buy_gift_bag(user, gift_id)
    gift_bag = GiftBag.find(gift_id)
    gift_bag.sale_count = gift_bag.sale_count.to_i + 1
    gift_bag.save #礼包卖出数量加1
    logger.debug "gift_msg#{gift_bag}"
    game_user = GameScoreInfo.find_by_user_id(user.id)
    game_user = GameScoreInfo.new if game_user.nil?
    game_user.user_id = user.id
    game_user.score = 0 if game_user.score.nil?
    game_user.score = game_user.score + gift_bag.beans
    game_user.save #玩家积分增加
    logger.debug "user_msg#{game_user}"
    props = gift_bag.gift_map
    p props
    props.each do |prop|
      user_prop = GameUserCate.find_by_user_id_and_cate_id(user.id, prop.cate.id)
      user_prop = GameUserCate.new if user_prop.nil?
      user_prop.user_id = user.id
      user_prop.cate_id = prop.cate.id
      user_prop.cate_count = 0 if user_prop.cate_count.nil?
      user_prop.cate_count = prop.count + user_prop.cate_count
      user_prop.used_flag = 0
      user_prop.save #更新玩家道具列表
    end
    log = SpendCateLog.new
    log.user_id = user.id
    log.gift_bag_id= gift_id
    log.add_date = Time.now
    log.spend_count = 1
    log.save
    list = cate_list(user)
    msg = {:result_code => ResultCode::SUCCESS,
           :score => game_user.score,
           :name => gift_bag.name,
           :list => list
    }
    msg
  end

  def buy_cate(user, cate_id)
    cate = GameShopCate.find(cate_id)
    user_prop = GameUserCate.find_by_user_id_and_cate_id(user.id, cate_id)
    user_prop = GameUserCate.new if user_prop.nil?
    user_prop.user_id = user.id
    user_prop.cate_id = cate.id
    user_prop.cate_count = 0 if user_prop.cate_count.nil?
    user_prop.cate_count = user_prop.cate_count + 1
    user_prop.used_flag = 0
    user_prop.save
    log = SpendCateLog.new
    log.user_id = user.id
    log.cate_id = cate_id
    log.add_date = Time.now
    log.spend_count = 1
    log.save
    list = cate_list(user)
    msg = {:result_code => ResultCode::SUCCESS,
           :score => user.game_score_info.score,
           :name => cate.cate_name,
           :list => list
    }
    msg
  end

  def cate_list(user)
    i = 0
    msg = Array.new
    p user.id
    if user.game_user_cate
      user_cates = user.game_user_cate
      user_cates.each do |user_cate|
        if user_cate.cate_count <= 0
          next
        end
        msg[i] = {:user_id => user.user_id,
                  :prop_name => user_cate.cate.cate_name,
                  :prop_count => user_cate.cate_count,
                  :result_code => ResultCode::SUCCESS
        }
      end
      i = i + 1
    end
    msg
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

  def judge_show_prop(user_id,action)
    flag = false #do not show prop
    Rails.logger.debug("[GameShopPropHelper.judge_show_prop], user_id:#{user_id}")
    user = User.find_by_user_id(user_id)
    user_profile = user.user_profile
    payment = user_profile.payment
    Rails.logger.debug("[GameShopPropHelper.judge_show_prop], payment:#{payment}")
    if payment.nil?
      flag = true
      return flag
    end
    system_payment = {}
    record = SystemSetting.find_by_setting_name(payment)

    unless record.nil?
      return true if record.setting_value.nil?

      system_payment = JSON.parse(record.setting_value)
      unless system_payment["#{payment}"].nil?
        return true if system_payment["#{payment}"]["#{action}"].nil?
        flag = system_payment["#{payment}"]["#{action}"].to_i ==1 ? true : false
        return flag
      else
        flag = true
        return flag
      end
    else
       true
    end
  end
end
