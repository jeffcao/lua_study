class CreateGameMatchLogs < ActiveRecord::Migration
  def change
    create_table :game_match_logs do |t|

      t.timestamps
    end
  end
end
