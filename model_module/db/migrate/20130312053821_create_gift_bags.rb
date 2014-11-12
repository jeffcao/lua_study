class CreateGiftBags < ActiveRecord::Migration
  def change
    create_table :gift_bags do |t|
      t.string :name
      t.string :price
      t.integer :beans
      t.integer :sale_limit
      t.integer :sale_count

      t.timestamps
    end
  end
end
