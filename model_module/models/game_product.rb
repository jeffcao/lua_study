class GameProduct < ActiveRecord::Base
  attr_accessible :game_id, :note, :price, :product_name, :product_type, :sale_limit, :state, :icon,:product_sort, :display_name
   has_one :game_product_sell_count, :dependent => :destroy
   has_many :product_product_item, :dependent => :destroy
   has_one  :prop_consume_code, :dependent => :destroy

  def display_name
    product_name
  end
end
