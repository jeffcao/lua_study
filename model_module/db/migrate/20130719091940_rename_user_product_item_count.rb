class RenameUserProductItemCount < ActiveRecord::Migration
  def up
    rename_column :user_product_item_counts, :user_product_item_id, :game_product_item_id
  end

  def down
  end
end
