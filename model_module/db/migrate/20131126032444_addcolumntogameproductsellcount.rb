class Addcolumntogameproductsellcount < ActiveRecord::Migration
  def up
    add_column :game_product_sell_counts,:cp_sell_count,:integer,:default => 0
  end

  def down
  end
end
