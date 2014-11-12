class CreateUserProductItems < ActiveRecord::Migration
  def change
    create_table :user_product_items do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :item_name
      t.string :item_note
      t.string :cate_module
      t.string :using_point
      t.integer :beans
      t.string :item_feature

      t.timestamps
    end
  end
end
