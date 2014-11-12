class CreateGameRooms < ActiveRecord::Migration
  def change
    create_table :game_rooms do |t|
      t.string :name
      t.integer :ante
      t.integer :min_qualification
      t.integer :max_qualification
      t.integer :status

      t.timestamps
    end
  end
end
