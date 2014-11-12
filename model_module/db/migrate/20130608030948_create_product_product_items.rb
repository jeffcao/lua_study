class CreateProductProductItems < ActiveRecord::Migration
  def change
    create_table :product_product_items do |t|
      t.integer :game_product_id
      t.integer :game_product_item_id

      t.timestamps
    end
  end
end
