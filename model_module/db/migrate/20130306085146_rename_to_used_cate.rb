class RenameToUsedCate < ActiveRecord::Migration
  def up
    rename_column :used_cates,:valid,:cate_valid

  end

  def down
  end
end
