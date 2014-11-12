class AddGameTypeToGameToom < ActiveRecord::Migration
  def change
    add_column :game_rooms, :room_type, :integer,:default => 1
  end
end
