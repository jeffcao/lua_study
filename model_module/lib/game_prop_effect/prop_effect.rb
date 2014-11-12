#encoding: utf-8

module PropExpire
  def expired?(user_id, begin_use_time=nil)
    Rails.logger.debug("[expired?], user_id=>#{user_id.to_s}")
    u_items = UserUsedProp.where(user_id: user_id, game_product_item_id: self.id, state: 1)
    u_items.blank?
  end

  def expired_notify(user_id, args, &block)

    Rails.logger.debug("[expired?], #{self.item_name} has expired.")

    v_prop = GameProductItem.find_by_item_name("专属音效27")
    v_prop.take_effect(user_id, nil, &block)

    on_expired_notify user_id
  end

  def on_expired_notify(user_id)

  end

  def remaining_time(user_id)
    user = User.find(user_id)
    Rails.logger.debug("[remaining_time], user_id=>#{user_id.to_s},game_product_item_id=>#{self.id}")
    u_item = UserUsedProp.where(user_id: user_id, game_product_item_id: self.id, state: 1).order("use_time desc").first
    user_product_item = UserProductItem.where(user_id: user.user_id, game_item_id: self.id, state: 0).order("created_at asc")
    unless user_product_item.blank?
      item = user_product_item.first
      request_seq = item.request_seq
    end
    unless item.nil?
      Rails.logger.debug("[remaining_time], request_seq=>#{request_seq}")
      feature = JSON.parse(item["item_feature"])
      Rails.logger.debug("[item.request_seq=>#{request_seq}]")
      game_product_id = PurchaseRequestRecord.find_by_request_seq(request_seq).game_product_id
      product = GameProduct.find(game_product_id)
      Rails.logger.debug("[remaining_time], product_name=>#{product.product_name}")
      Rails.logger.debug("[remaining_time], feature=>#{feature}")

      if product.product_name == ResultCode::SHOUCHONGDALIBAO
        unless u_item.nil?
          unless feature["shouchong_valid_period"].nil?
            time_return = feature["shouchong_valid_period"].to_i * 60 * 60 - (Time.now - u_item.use_time)
            Rails.logger.debug("[remaining_time], time_return=>#{time_return}")
            return time_return
          end
        end
      end
      unless feature["valid_period"].nil?
        time_return = feature["valid_period"].to_i * 60 * 60
        return (time_return - (Time.now - u_item.use_time)) unless u_item.nil?
      end

    end
    if u_item.nil?
      Rails.logger.debug("[remaining_time], can not found the using prop.")
      return self.feature["valid_period"].to_i * 60 * 60
    end
    self.feature["valid_period"].to_i * 60 * 60 - (Time.now - u_item.use_time)
  end

end

module DouziEffect
  include PropExpire
  # To change this template use File | Settings | File Templates.
  def take_effect(user_id, args=nil)
    beans = args[:beans]
    Rails.logger.debug("[DouziEffect.take_effect] user_id=>#{user_id.to_s}")
    if user_id.blank? or beans.blank?
      return
    end
    user = User.find(user_id)

    user.game_score_info.score = user.game_score_info.score + self.beans.to_i
    user.game_score_info.save
  end

end

module DoubleJifenkaEffect
  include PropExpire

  def take_effect(user_id, args)
    is_win = args[:is_win]
    beans = args[:beans]
    Rails.logger.debug("[DoubleJifenkaEffect.take_effect] user_id=>#{user_id.to_s},
        is_win=#{is_win.to_s}, benas=>#{beans.to_s}")
    if user_id.blank? or is_win.nil? or beans.blank?
      Rails.logger.debug("[HushenkaEffect.take_effect] user_id.blank?, return")
      return beans.to_i
    end
    user = User.find(user_id)
    if user.blank?
      Rails.logger.debug("[HushenkaEffect.take_effect] user.blank?, return")
      return beans.to_i
    end
    if expired?(user_id)
      return beans.to_i
    end

    if is_win
      return 2*beans.to_i
    end
    beans.to_i
  end
end

module HushenkaEffect
  include PropExpire

  def take_effect(user_id, args)
    is_win = args[:is_win]
    beans = args[:beans]
    Rails.logger.debug("[HushenkaEffect.take_effect] user_id=>#{user_id.to_s},
        is_win=#{is_win.to_s}, benas=>#{beans.to_s}")
    if user_id.blank? or is_win.nil? or beans.blank?
      Rails.logger.debug("[HushenkaEffect.take_effect] user_id.blank?, return")
      return beans.to_i
    end
    user = User.find(user_id)
    Rails.logger.debug("[HushenkaEffect.take_effect] user=>#{user.to_json}")
    if user.blank?
      Rails.logger.debug("[HushenkaEffect.take_effect] user.blank?, return")
      return beans.to_i
    end
    if self.expired?(user_id)
      return beans.to_i
    end

    0 if is_win
    #probability = rand(1..100)
    #affect_ratio = self.feature["affect_ratio"].to_i
    #Rails.logger.debug("[HushenkaEffect.take_effect] probability=>#{probability.to_s},
    #    affect_ratio=>#{affect_ratio.to_s}")
    #if probability <= affect_ratio and not is_win
    #   return 0
    #end
    beans.to_i
  end
end

module JifenkaEffect
  include PropExpire

  def take_effect(user_id, args)
    is_win = args[:is_win]
    beans = args[:beans]
    Rails.logger.debug("[JifenkaEffect.take_effect] user_id=>#{user_id.to_s},
        is_win=#{is_win.to_s}, benas=>#{beans.to_s}")
    if user_id.blank? or is_win.blank? or beans.blank?
      Rails.logger.debug("[HushenkaEffect.take_effect] user_id.blank?, return")
      return beans.to_i
    end
    user = User.find(user_id)
    if user.blank?
      Rails.logger.debug("[HushenkaEffect.take_effect] user.blank?, return")
      return beans.to_i
    end
    if expired?(user_id)
      return beans.to_i
    end
    if is_win
      return beans.to_i * 1.5 #+ self.feature["beans"].to_i
    end
    beans.to_i
  end

end

module JipaiqiEffect
  include PropExpire

  def take_effect

  end

  def on_expired_notify(user_id)
    player = Player.get_player(user_id)
    return if player.day_activity_done?
    day = Time.now.wday
    return if day != 4

    a_prop = Activity.find_by_week_date(day)
    a_prop.take_effect(player.player_info.user_id, {:player => player})

  end

end

module VipCardEffect
  include PropExpire

  def take_effect

  end

end

module UnknownEffect
  include PropExpire

  def take_effect

  end

end

