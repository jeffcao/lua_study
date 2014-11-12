class AddColumnToGameProductItem < ActiveRecord::Migration
  def change
    add_column :game_product_items, :item_type, :integer ,:default => 0
  end
end
