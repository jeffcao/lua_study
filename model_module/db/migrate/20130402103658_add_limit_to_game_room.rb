class AddLimitToGameRoom < ActiveRecord::Migration
  def change
    add_column :game_rooms, :limit_online_count, :integer,:default => 0
  end
end
