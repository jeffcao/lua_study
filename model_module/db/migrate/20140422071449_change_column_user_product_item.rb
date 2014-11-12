class ChangeColumnUserProductItem < ActiveRecord::Migration
  def up
    rename_column :user_product_items,:game_product_id,:game_item_id
    add_column :user_product_items,:state,:integer,:default=>0
  end

  def down
  end
end
