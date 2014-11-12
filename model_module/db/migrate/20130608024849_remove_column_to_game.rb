class RemoveColumnToGame < ActiveRecord::Migration
  def up
    remove_column :game_product_items, :game_product_id
  end

  def down
  end
end
