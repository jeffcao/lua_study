class AddColumnToGameUserCateTrea < ActiveRecord::Migration
  def change
    add_column :game_user_cates, :gift_bag_id, :integer
    add_column :game_user_cates, :treasure_box_id, :integer
  end
end
