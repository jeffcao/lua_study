class ChangeColumnToUserProfile < ActiveRecord::Migration
  def up
    change_column :user_profiles, :gender, :integer,:default=>1
  end

  def down
  end
end
