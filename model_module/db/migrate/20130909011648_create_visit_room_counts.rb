class CreateVisitRoomCounts < ActiveRecord::Migration
  def change
    create_table :visit_room_counts do |t|
      t.integer :game_room_id
      t.integer :user_id
      t.integer :count
      t.string :date

      t.timestamps
    end
  end
end
