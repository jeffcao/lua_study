class UserProductItem < ActiveRecord::Base
  attr_accessible :beans, :cate_module, :game_id, :item_feature, :item_name, :item_note, :user_id, :using_point,:game_item_id,:request_seq,:state
end
