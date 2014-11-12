class AddToUserProfile < ActiveRecord::Migration
  def up
    add_column  :user_profiles, :last_active_at, :datetime
    add_column  :user_profiles, :online_time, :integer
  end

  def down
  end
end
