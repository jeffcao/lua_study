class UsedCate < ActiveRecord::Base
  attr_accessible :cate_last, :cate_begin, :cate_id, :user_id, :valid
  belongs_to :cate, :class_name => "GameShopCate", :foreign_key => "cate_id"

end
