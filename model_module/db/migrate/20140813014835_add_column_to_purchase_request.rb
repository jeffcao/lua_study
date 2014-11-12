class AddColumnToPurchaseRequest < ActiveRecord::Migration
  def change
    add_column :purchase_request_records,:server_flag,:integer
  end
end
