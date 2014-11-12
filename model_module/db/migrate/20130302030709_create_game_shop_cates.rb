class CreateGameShopCates < ActiveRecord::Migration
  def change
    create_table :game_shop_cates do |t|
      t.integer :cate_id
      t.string :cate_name
      t.integer :game_id
      t.string :price
      t.string :sale_count
      t.string :cate_note
      t.string :valid

      t.timestamps
    end
  end
end
