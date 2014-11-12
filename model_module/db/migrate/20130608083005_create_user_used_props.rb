class CreateUserUsedProps < ActiveRecord::Migration
  def change
    create_table :user_used_props do |t|
      t.integer :user_id
      t.integer :user_product_item_id
      t.datetime :use_time
      t.integer :state

      t.timestamps
    end
  end
end
