class AddColumnRealAmountToPurchaseRequestRecord < ActiveRecord::Migration
  def change
    add_column :purchase_request_records,:real_amount,:float,:default => 0
  end
end
