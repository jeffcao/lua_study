class GameUserCate < ActiveRecord::Base
  attr_accessible :cate_count, :cate_id, :game_id, :used_flag, :user_id, :gift_bag_id,:treasure_box_id
  belongs_to :cate, :class_name => "GameShopCate", :foreign_key => "cate_id"
  belongs_to :gift_bag, :class_name => "GiftBag", :foreign_key => "gift_bag_id"
  belongs_to :treasure_box, :class_name => "TreasureBox", :foreign_key => "treasure_box_id"
end
