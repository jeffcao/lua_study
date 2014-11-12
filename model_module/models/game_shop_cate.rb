class GameShopCate < ActiveRecord::Base
  attr_accessible :cate_id, :cate_name, :cate_note, :game_id, :price, :sale_count, :valid
end
