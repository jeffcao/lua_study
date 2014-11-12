class RenameBlacklist < ActiveRecord::Migration
  def up
    rename_column :blacklists,:user_id,:black_id
  end

  def down
  end
end
