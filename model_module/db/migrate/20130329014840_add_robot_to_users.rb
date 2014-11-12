class AddRobotToUsers < ActiveRecord::Migration
  def change
    add_column :users, :robot, :integer,:default => 0
    add_column :users, :busy, :integer,:default => 0
  end
end
