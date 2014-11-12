class ChangeCloumnToGiftbag < ActiveRecord::Migration
  def up
    rename_column :gift_maps,:gift_id,:gift_bag_id
    rename_column :gift_maps,:cate_id,:game_shop_cate_id
  end

  def down
  end
end
