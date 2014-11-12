class AddColumnToUserConsume < ActiveRecord::Migration
  def change
    add_column :users,:vip_level,:integer
    add_column :users,:total_consume,:float
  end
end
