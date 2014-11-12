#encoding: utf-8
module PropHelper


  def cate_list_type(user)
    msg = []
    #props = user.user_product_item_count.order("created_at desc")
    props = UserProductItemCount.where(user_id:user.id).order("created_at desc")
    props.reload unless props.nil?
    props.each do |prop|
      if prop.item_count <= 0
        next
      end
      msg_item = {}
      item_id = prop.game_product_item_id
      use_prop = UserUsedProp.where(user_id: user.id, game_product_item_id:item_id, state:1).order("use_time desc").first
      use_prop.reload(:lock=>true) unless use_prop.nil?
      item = GameProductItem.find(item_id)
      remaining_time_str = get_remaining_time_str(item.remaining_time(user.id))
      using_me = false
      unless use_prop.nil?
        using_me = item.expired?(user.id, use_prop.use_time)? false:true
      end
      sql_str="select a.game_product_id, c.product_name, c.price from product_product_items a, (select game_product_id from product_product_items group by game_product_id having count(game_product_id)=1) b, game_products c where a.game_product_id = b.game_product_id and a.game_product_item_id=#{item_id} and c.id=a.game_product_id;"
      sql_result = ActiveRecord::Base.connection.execute(sql_str, :as=> :hash)
      # Rails.logger.debug("cate_list_type, sql_result=>#{sql_result}")
      r_prop_id=item_id
      r_prop_price = 200
      sql_result.each(:as => :hash) do |row|
        r_prop_id = row["game_product_id"]
        r_prop_price = row["price"]
      end
      msg_item = {:user_id => user.user_id,
                 :prop_id => item.id,
                 :r_prop_id => r_prop_id,
                 :prop_name => item.item_name,
                 :price => r_prop_price,
                 :prop_note => item.item_note,
                 :prop_count => prop.item_count,
                 :prop_icon => item.icon,
                 :using_me => using_me,
                 :remaining_time => remaining_time_str,
                 #:prop_icon => icons[0],
                 :result_code => ResultCode::SUCCESS

      }
      msg.push(msg_item)
    end

    Rails.logger.debug("[PropHelper:cate_list_type] msg=> "+msg.to_json)
    msg

  end

  def get_remaining_time_str(remaining_s)
    ma = remaining_s.div(60)
    seconds = remaining_s.to_i.modulo(60)
    hours = ma.div(60)
    minutes = ma.modulo(60)
    hours_s = hours < 10? "0#{hours.to_s}":hours.to_s
    minutes_s =   minutes < 10? "0#{minutes.to_s}":minutes.to_s
    seconds_s =  seconds < 10? "0#{seconds.to_s}":seconds.to_s
    "剩余时间: #{hours_s}:#{minutes_s}:#{seconds_s}"
  end

  def use_cate_type(user, cate_id)
    flag = user_have_cate(user, cate_id)
    result = false
    result_message = "无法使用此道具."
    item_flag = true
    p_item = GameProductItem.find(cate_id)
    Rails.logger.debug("[PropHelper:use_cate_type] p_item=> "+p_item.to_json)
    if p_item.using_point.nil? or p_item.item_type.nil? or p_item.feature.empty?
      result_message = "此道具属性定义不完整，无法使用此道具."
      item_flag = false
    end
    if item_flag
      used_p_items = UserUsedProp.where(user_id: user.id, state:1)
      Rails.logger.debug("[PropHelper:use_cate_type] used_p_items=> "+used_p_items.to_json)
      used_p_items.each do |u_item|
        item =  GameProductItem.find(u_item.game_product_item_id)
        Rails.logger.debug("[PropHelper:use_cate_type] item=> "+item.to_json)
        if not item.expired?(user.id, u_item.use_time) and item.item_type == p_item.item_type
          result_message = "有相同类型的道具正在使用，无法使用此道具."
          item_flag = false
        end
      end
    end
    if flag and item_flag
      save_user_used_prop(user,cate_id)
      remaining_time_str = get_remaining_time_str(p_item.remaining_time(user.id))
      record = UserProductItemCount.find_by_user_id_and_game_product_item_id(user.id, cate_id)
      msg = {:user_id => user.user_id,
             :prop_count => record.item_count,
             :prop_id => cate_id,
             :remaining_time => remaining_time_str,
             :result_code => ResultCode::SUCCESS
      }
      result = true
    else
      msg = {:result_code => ResultCode::PROP_IS_NULL, :result_message=>result_message}
    end
    #if flag
    #  used_cate = UsedCate.new
    #  used_cate.user_id = user.id
    #  used_cate.cate_id = cate_id
    #  used_cate.cate_valid = 1
    #  used_cate.cate_begin = Time.now
    #  used_cate.cate_last = Time.now + 1.day
    #  used_cate.save
    #  msg = {:user_id => user.user_id,
    #         :prop_begin => used_cate.cate_begin,
    #         :prop_end => used_cate.cate_last,
    #         :prop_name => used_cate.cate.cate_name,
    #         :result_code => ResultCode::SUCCESS
    #  }
    #  game_user_cate = GameUserCate.find_by_user_id_and_cate_id(user.id,cate_id)
    #  game_user_cate.cate_count = game_user_cate.cate_count - 1
    #  game_user_cate.save
    Rails.logger.debug("[PropHelper:use_cate_type] msg=> "+msg.to_json)
    [result, msg]
  end

  def user_have_cate(user, prop_id) #先判断用户是否有此道具
    count = UserProductItemCount.where(["user_id=? and game_product_item_id=? and item_count>?", user.id, prop_id, 0]).count
    if count > 0
      true
    else
      false
    end
  end

  def save_user_used_prop(user,item_id)
    used_record = UserUsedProp.new
    used_record.user_id = user.id
    used_record.game_product_item_id = item_id
    used_record.use_time = Time.now
    used_record.state = 1
    used_record.save
  end



end
