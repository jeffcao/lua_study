class AddconsecutivetoUserprofile < ActiveRecord::Migration
  def up
    add_column  :user_profiles, :consecutive, :integer, :default => 1
  end

  def down
  end
end
