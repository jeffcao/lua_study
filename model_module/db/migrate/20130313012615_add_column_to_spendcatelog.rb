class AddColumnToSpendcatelog < ActiveRecord::Migration
  def change
    add_column :spend_cate_logs, :gift_bag_id, :integer
    add_column :spend_cate_logs, :treasure_box_id, :integer
  end
end
