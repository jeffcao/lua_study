module ActivityAddScore
  def take_effect(user_id, args)

  end
end
module DiZhuAddScore
  def take_effect(user_id, args)
    beans = args[:beans]
    score = args[:score]
    role = args[:role]
    is_win = args[:is_win]
    if  role.nil? or (role.to_i == 1 and is_win) or (role.to_i == 2 and !is_win)
      return beans
    end
    rate = self.feature["rate"].to_f
    Rails.logger.info("[DiZhuAddScore.take_effect]beans=>#{beans},score=>#{score},is_win=>#{is_win}.role=>#{role},rate=>#{rate}")

    if role.to_i == 2 and is_win
      #beans = beans + (beans.to_i*rate.to_f).to_i
      beans = beans.to_i + (score.to_i*rate.to_f).to_i
      Rails.logger.info("[DiZhuAddScore.take_effect]beans=>#{beans}")

    end
    if role.to_i == 1 and !is_win
      #beans = beans + (beans.to_i*rate.to_f).to_i
      beans = beans.to_i - (score.to_i*rate.to_f).to_i
      Rails.logger.info("[DiZhuAddScore.take_effect]beans=>#{beans}")

    end
    beans.to_i
  end
end

module NongMingAddScore
  def take_effect(user_id, args)
    beans = args[:beans]
    score = args[:score]
    role = args[:role]
    is_win = args[:is_win]
    if  role.nil? or (role.to_i == 2 and is_win) or (role.to_i == 1 and !is_win)
      return beans
    end
    rate = self.feature["rate"].to_f
    Rails.logger.info("[NongMingAddScore.take_effect]beans=>#{beans},score=>#{score},is_win=>#{is_win}.role=>#{role},rate=>#{rate}")
    if role.to_i == 1 and is_win
      #beans = beans + (beans.to_i*rate.to_f).to_i
      beans = beans.to_i + (score.to_i*rate.to_f).to_i
      Rails.logger.info("[NongMingAddScore.take_effect]beans=>#{beans}")
    end
    if role.to_i == 2 and !is_win
      #beans = beans + (beans.to_i*rate.to_f).to_i
      beans = beans.to_i - (score.to_i*rate.to_f).to_i
      Rails.logger.info("[NongMingAddScore.take_effect]beans=>#{beans}")
    end
    beans.to_i
  end
end

module WinnerAddScore
  def take_effect(user_id,args)
    beans = args[:beans]
    score = args[:score]
    role = args[:role]
    is_win = args[:is_win]

    rate = self.feature["rate"].to_f
    Rails.logger.info("[WinnerAddScore.take_effect]beans=>#{beans},score=>#{score},is_win=>#{is_win}.role=>#{role},rate=>#{rate}")

    if is_win
      beans = beans.to_i + (score*rate.to_f).to_i
    end
    if !is_win and  role.to_i == 1
      #beans = beans.to_i - (score*rate.to_f/2).to_i
      beans = beans.to_i - (score*rate.to_f).to_i
      Rails.logger.info("[WinnerAddScore.take_effect farmer]beans=>#{beans}")

    end
    if !is_win and  role.to_i == 2
      #beans = beans.to_i - (score*rate.to_f*2).to_i
      beans = beans.to_i - (score*rate.to_f).to_i

      Rails.logger.info("[WinnerAddScore.take_effect]beans=>#{beans}")
    end
    Rails.logger.info("[WinnerAddScore.take_effect]beans=>#{beans}.")

    beans.to_i

  end
end

module ThursdayActivity
  def take_effect(user_id,args)
    Rails.logger.info("[ThursdayActivity.take_effect]")
    player =  args[:player]
    Rails.logger.info("[ThursdayActivity.take_effect], user_id=>#{player.player_info.user_id}")

    str_sql = "select a.* from game_product_items a, user_used_props b
      where a.id = b.game_product_item_id and a.item_type =3 and b.state=1 and b.user_id = #{user_id}"

    used_props = GameProductItem.find_by_sql(str_sql)
    unless used_props.blank?
      Rails.logger.info("[ThursdayActivity.take_effect], jipaiqi is in using.")
      return false
    end

    jpq_prop = GameProductItem.find_by_item_type(3)
    str_sql = "select a.* from user_product_item_counts a, game_product_items b
      where a.game_product_item_id= b.id and a.user_id=#{user_id} and b.item_type=3"
    user_prod_items = UserProductItemCount.find_by_sql(str_sql)
    user_prod_item = nil
    user_prod_item = user_prod_items.first if user_prod_items.length > 0
    user_prod_item_count = user_prod_item || UserProductItemCount.new
    user_prod_item_count.user_id = user_id
    user_prod_item_count.game_product_item_id = jpq_prop.id
    Rails.logger.info("[ThursdayActivity.take_effect],user_prod_item_count.item_count=>#{user_prod_item_count.item_count} .")
    unless user_prod_item.nil?
      Rails.logger.info("[ThursdayActivity.take_effect],user_prod_item?.count=>#{user_prod_item.item_count} .")
    end
    user_prod_item_count.item_count = user_prod_item_count.item_count + (user_prod_item.nil? ? 1 : user_prod_item.item_count)
    Rails.logger.info("[ThursdayActivity.take_effect],user_prod_item_count.item_count=>#{user_prod_item_count.item_count}")

    user_prod_item_count.save


    used_record = UserUsedProp.new
    used_record.user_id = user_id
    used_record.game_product_item_id = jpq_prop.id
    used_record.use_time = Time.now
    used_record.state = 1
    used_record.save

    player.set_day_activity_done
    true
  end
end

module SaturdayActivity

  def take_effect(user_id,args=nil)
    4
  end
end

module UnknownEffect

  def take_effect(user_id,args=nil)

  end

end
