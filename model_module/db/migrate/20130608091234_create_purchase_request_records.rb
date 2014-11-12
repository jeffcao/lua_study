class CreatePurchaseRequestRecords < ActiveRecord::Migration
  def change
    create_table :purchase_request_records do |t|
      t.integer :user_id
      t.integer :user_product_id
      t.integer :game_product_id
      t.integer :product_count
      t.string :request_seq
      t.string :request_type
      t.string :request_command
      t.datetime :request_time
      t.string :operator_type
      t.integer :state
      t.string :reason

      t.timestamps
    end
  end
end
