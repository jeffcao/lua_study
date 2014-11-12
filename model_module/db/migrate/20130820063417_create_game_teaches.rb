class CreateGameTeaches < ActiveRecord::Migration
  def change
    create_table :game_teaches do |t|
      t.string :content
      t.string :moment

      t.timestamps
    end
  end
end
