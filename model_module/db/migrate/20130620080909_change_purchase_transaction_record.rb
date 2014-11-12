class ChangePurchaseTransactionRecord < ActiveRecord::Migration
  def up
    change_column :purchase_transaction_records,:request_message,:text
  end

  def down
  end
end
