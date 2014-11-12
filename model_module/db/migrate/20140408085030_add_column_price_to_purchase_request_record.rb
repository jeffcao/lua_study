class AddColumnPriceToPurchaseRequestRecord < ActiveRecord::Migration
  def change
    add_column :purchase_request_records,:price,:float,:default => 0
  end
end
