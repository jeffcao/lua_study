class CreateGiftMaps < ActiveRecord::Migration
  def change
    create_table :gift_maps do |t|
      t.integer :gift_id
      t.integer :cate_id
      t.integer :count

      t.timestamps
    end
  end
end
