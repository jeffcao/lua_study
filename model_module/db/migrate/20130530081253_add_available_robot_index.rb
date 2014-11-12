class AddAvailableRobotIndex < ActiveRecord::Migration
  def up
    add_index :users, [:robot, :busy, :last_action_time], :name=>'available_robot'
  end

  def down
    remove_index :users,  'available_robot'
  end
end
