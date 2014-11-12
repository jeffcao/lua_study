class AddColumnToPurchaseRequestRecord < ActiveRecord::Migration
  def change
    add_column :purchase_request_records,:appid,:integer,:default => 0
  end
end
