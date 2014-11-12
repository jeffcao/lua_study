class ChangeProductAndItemIconToString < ActiveRecord::Migration
  def up
    change_column :game_products, :icon, :string, :default => "0"
    change_column :game_product_items, :icon, :string, :default => "0"
  end

  def down
  end
end
