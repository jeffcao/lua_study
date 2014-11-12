class AddColumnAvatarToUseProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :avatar, :integer, :default => 0
  end
end
