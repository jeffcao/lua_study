class AddColumnToGameShopCate < ActiveRecord::Migration
  def change
    add_column :game_shop_cates, :used_limit, :string

  end
end
