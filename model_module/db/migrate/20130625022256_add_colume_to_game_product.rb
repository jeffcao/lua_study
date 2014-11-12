class AddColumeToGameProduct < ActiveRecord::Migration
  def change
    add_column :game_products, :icon, :integer, :default => 0
    add_column :game_products, :product_sort, :integer, :default => 0
    add_column :game_product_items, :icon, :integer, :default => 0
    add_column :game_product_items, :item_sort, :integer, :default => 0
  end
end
