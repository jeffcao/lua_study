class DefaultValueToGame < ActiveRecord::Migration
  def change
    change_column :game_score_infos, :score, :integer,:default=>0

  end

  def down
  end
end
