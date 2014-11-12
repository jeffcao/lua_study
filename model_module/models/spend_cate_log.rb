class SpendCateLog < ActiveRecord::Base
  attr_accessible :add_date, :cate_count, :cate_id, :spend_count, :user_id,:gift_bag_id,:treasure_box_id
end
