class ChangeColumnToUserUsedProp < ActiveRecord::Migration
  def up
    rename_column :user_used_props, :user_product_item_id, :game_product_item_id
  end

  def down
  end
end
