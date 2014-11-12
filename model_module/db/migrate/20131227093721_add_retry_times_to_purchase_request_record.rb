class AddRetryTimesToPurchaseRequestRecord < ActiveRecord::Migration
  def change
    add_column :purchase_request_records, :retry_times, :integer, :default=>0
  end
end
