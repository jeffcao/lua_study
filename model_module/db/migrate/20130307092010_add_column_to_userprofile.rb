class AddColumnToUserprofile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :birthday, :datetime

  end
end
