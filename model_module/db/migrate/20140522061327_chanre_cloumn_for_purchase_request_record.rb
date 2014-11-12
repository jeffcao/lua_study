class ChanreCloumnForPurchaseRequestRecord < ActiveRecord::Migration
  def up
    change_column :purchase_request_records,:request_command,:text
  end

  def down
  end
end
