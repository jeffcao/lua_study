class ChangeColumn < ActiveRecord::Migration
  def up
    change_column :purchase_transaction_records,:elapsed_time,:float
  end

  def down
  end
end
