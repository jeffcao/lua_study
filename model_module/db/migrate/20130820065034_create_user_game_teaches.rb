class CreateUserGameTeaches < ActiveRecord::Migration
  def change
    create_table :user_game_teaches do |t|
      t.integer :user_id
      t.integer :game_teach_id

      t.timestamps
    end
  end
end
