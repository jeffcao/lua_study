class UserUsedProp < ActiveRecord::Base
  attr_accessible :state, :use_time, :user_id, :game_product_item_id, :game_id

  def user_prop_expired(user_id,item_id)
    item = GameProductItem.find(item_id)
    prop = UserUsedProp.find_by_user_id_and_user_product_item_id(user_id,item_id)
    feature = JSON.parse(item.item_feature)["valid_period"].to_i
    if Time.now > prop.use_time + feature.hour    #有效期已到
      prop.state = 2
      prop.save
      false
    else
      true
    end
  end


end
