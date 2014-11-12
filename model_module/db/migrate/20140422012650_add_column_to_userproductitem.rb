class AddColumnToUserproductitem < ActiveRecord::Migration
  def change
    add_column :user_product_items,:game_product_id,:integer
    add_column :user_product_items,:request_seq,:string
  end
end
