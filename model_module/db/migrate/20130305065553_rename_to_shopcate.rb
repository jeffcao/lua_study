class RenameToShopcate < ActiveRecord::Migration
  def up
    rename_column :game_shop_cates,:valid,:cate_valid

  end

  def down
  end
end
