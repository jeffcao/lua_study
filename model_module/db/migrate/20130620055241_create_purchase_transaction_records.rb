class CreatePurchaseTransactionRecords < ActiveRecord::Migration
  def change
    create_table :purchase_transaction_records do |t|
      t.string :request_id
      t.integer :operator_user_id
      t.string :request_url
      t.string :request_message
      t.string :response_message
      t.string :request_ip
      t.datetime :request_time
      t.datetime :response_time
      t.datetime :elapsed_time

      t.timestamps
    end
  end
end
