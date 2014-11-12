class Addtotalprizetouserprofile < ActiveRecord::Migration
  def up
    add_column :user_profiles,:total_prize,:string
  end

  def down
  end
end
