class AddColumnToGameRoom < ActiveRecord::Migration
  def change
    add_column :game_rooms, :fake_online_count, :integer,:default => 0
  end
end
