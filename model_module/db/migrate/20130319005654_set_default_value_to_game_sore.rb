class SetDefaultValueToGameSore < ActiveRecord::Migration
  def change
    change_column :game_score_infos, :win_count, :integer,:default=>0
    change_column :game_score_infos, :lost_count, :integer,:default=>0
    change_column :game_score_infos, :flee_count, :integer,:default=>0
    change_column :game_score_infos, :all_count, :integer,:default=>0
    change_column :game_user_cates, :cate_count, :integer,:default=>0
  end

  def down
  end
end
