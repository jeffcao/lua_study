class CreateUserProducts < ActiveRecord::Migration
  def change
    create_table :user_products do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :product_name
      t.integer :product_type
      t.string :note

      t.timestamps
    end
  end
end
