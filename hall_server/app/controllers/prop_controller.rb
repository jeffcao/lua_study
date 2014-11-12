class PropController < BaseController
  include BaseHelper
  include PropHelper

  def user_prop_list #个人道具列表
    id = redis_key_pro(message[:user_id], event.id)
    user = get_user(message[:user_id])
    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      msg = cate_list_type(user)
      redis_key_value(id, msg)
      msg = nil if msg.length ==0
      trigger_success({:cats => msg})
    elsif Redis.current.exists(id)
      msg = Redis.current.get(id)
      trigger_success({:cats => msg})
    end
  end


  def use_cate #用户使用道具
    id = redis_key_pro(message[:user_id], event.id)
    user = get_user(message[:user_id])
    cate_id = message[:prop_id]
    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      result, msg = use_cate_type(user, cate_id)
      redis_key_value(id, msg)
      if result
        trigger_success({:prop => msg})
      else
        trigger_failure(msg)
      end
    end
  end

  def self.shouchong_use_cate(user, cate_id)
    flag = false
    Rails.logger.debug("[PropHelper:self.shouchong_use_cate] user.id=>#{user.id},game_product_item_id=>#{cate_id} ")

    count = UserProductItemCount.where(["user_id=? and game_product_item_id=? and item_count>?", user.id, cate_id, 0]).count
    if count > 0
      flag = true
    end
    item_flag = true
    p_item = GameProductItem.find(cate_id)
    Rails.logger.debug("[PropHelper:use_cate_type] p_item=> "+p_item.to_json)
    if p_item.using_point.nil? or p_item.item_type.nil? or p_item.feature.empty?
      item_flag = false
    end
    if item_flag
      used_p_items = UserUsedProp.where(user_id: user.id, state: 1)
      Rails.logger.debug("[PropHelper:use_cate_type] used_p_items=> "+used_p_items.to_json)
      used_p_items.each do |u_item|
        item = GameProductItem.find(u_item.game_product_item_id)
        Rails.logger.debug("[PropHelper:use_cate_type] item=> "+item.to_json)
        if not item.expired?(user.id, u_item.use_time) and item.item_type == p_item.item_type
          item_flag = false
        end
      end
    end
    Rails.logger.debug("[PropHelper:self.shouchong_use_cate] flag=>#{flag},item_flag=>#{item_flag} ")
    if flag and item_flag
      #save_user_used_prop(user,cate_id)
      used_record = UserUsedProp.new
      used_record.user_id = user.id
      used_record.game_product_item_id = cate_id
      used_record.use_time = Time.now
      used_record.state = 1
      used_record.save
    end
  end

end
