class AddLimitToGameRoom1 < ActiveRecord::Migration
  def change
    change_column :game_rooms, :limit_online_count, :integer
  end
end
