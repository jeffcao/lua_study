class GiftMap < ActiveRecord::Base
  attr_accessible :game_shop_cate_id, :count, :gift_bag_id
  belongs_to :cate, :class_name => "GameShopCate", :foreign_key => "game_shop_cate_id"
end
