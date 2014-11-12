class CreateGameScoreInfos < ActiveRecord::Migration
  def change
    create_table :game_score_infos do |t|
      t.integer :user_id
      t.integer :score
      t.integer :win_count
      t.integer :lost_count
      t.integer :flee_count
      t.integer :all_count
      t.integer :all_count

      t.timestamps
    end
  end
end
