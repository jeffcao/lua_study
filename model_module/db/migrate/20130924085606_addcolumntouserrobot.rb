class Addcolumntouserrobot < ActiveRecord::Migration
  def up
    add_column :users,:robot_type,:integer
  end

  def down
  end
end
