class CreateTreasureBoxes < ActiveRecord::Migration
  def change
    create_table :treasure_boxes do |t|
      t.string :name
      t.integer :beans
      t.integer :price
      t.string :note
      t.integer :give_beans
      t.integer :sale_limit
      t.integer :sale_count

      t.timestamps
    end
  end
end
