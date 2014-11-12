class AddLastActionTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_action_time, :datetime
  end
end
