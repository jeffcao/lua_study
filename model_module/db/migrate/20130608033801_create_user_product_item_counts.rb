class CreateUserProductItemCounts < ActiveRecord::Migration
  def change
    create_table :user_product_item_counts do |t|
      t.integer :user_id
      t.integer :user_product_item_id
      t.integer :item_count,:default => 0

      t.timestamps
    end
  end
end
