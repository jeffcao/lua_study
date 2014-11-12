class UserProductItemCount < ActiveRecord::Base
  attr_accessible :item_count, :user_id, :game_product_item_id
end
