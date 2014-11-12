class CreateGameRoomUrls < ActiveRecord::Migration
  def change
    create_table :game_room_urls do |t|
      t.integer :domain_name
      t.string :port
      t.integer :status
      t.integer :game_room_id

      t.timestamps
    end
  end
end
