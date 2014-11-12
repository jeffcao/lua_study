class Changeuserprofile < ActiveRecord::Migration
  def up
    change_column :user_profiles,:total_balance,:integer
  end

  def down
  end
end
