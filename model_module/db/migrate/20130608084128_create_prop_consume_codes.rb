class CreatePropConsumeCodes < ActiveRecord::Migration
  def change
    create_table :prop_consume_codes do |t|
      t.integer :game_product_id
      t.string :consume_code
      t.string :operator_type

      t.timestamps
    end
  end
end
