class ChangeGenderToUserProfile < ActiveRecord::Migration
  def up
    change_column :user_profiles, :gender, :integer,:default=>2
  end

  def down
  end
end
