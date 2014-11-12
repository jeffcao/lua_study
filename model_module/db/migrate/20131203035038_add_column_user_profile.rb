class AddColumnUserProfile < ActiveRecord::Migration
  def up
    add_column :user_profiles,:day_total_game,:integer,:default => 0
    add_column :user_profiles,:day_continue_win,:integer,:default => 0
  end

  def down
  end
end
