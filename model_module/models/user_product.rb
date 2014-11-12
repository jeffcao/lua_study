class UserProduct < ActiveRecord::Base
  attr_accessible :game_id, :note, :product_name, :product_type, :user_id, :price, :sale_limit, :state, :icon,:product_sort, :request_seq
end
