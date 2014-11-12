class CreateGameProducts < ActiveRecord::Migration
  def change
    create_table :game_products do |t|
      t.integer :game_id
      t.string :product_name
      t.integer :product_type
      t.string :price
      t.integer :sale_limit
      t.string :note
      t.integer :state, :default=>0

      t.timestamps
    end
  end
end
