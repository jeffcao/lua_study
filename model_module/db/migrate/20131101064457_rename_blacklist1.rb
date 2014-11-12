class RenameBlacklist1 < ActiveRecord::Migration
  def up
    rename_column :blacklists,:black_id , :u_id

  end

  def down
  end
end
