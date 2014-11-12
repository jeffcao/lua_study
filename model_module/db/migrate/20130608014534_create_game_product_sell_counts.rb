class CreateGameProductSellCounts < ActiveRecord::Migration
  def change
    create_table :game_product_sell_counts do |t|
      t.integer :game_product_id
      t.integer :sell_count

      t.timestamps
    end
  end
end
