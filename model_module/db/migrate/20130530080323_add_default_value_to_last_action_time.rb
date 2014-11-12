class AddDefaultValueToLastActionTime < ActiveRecord::Migration
  def change
    change_column :users, :last_action_time, :datetime, :default => Time.now
  end
  User.update_all({:last_action_time=>Time.now})
end
