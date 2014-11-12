class Renametotalprizeuserprofile < ActiveRecord::Migration
  def up
    rename_column :user_profiles,:total_prize,:total_balance
  end

  def down
  end
end
