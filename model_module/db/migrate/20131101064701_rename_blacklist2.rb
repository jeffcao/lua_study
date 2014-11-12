class RenameBlacklist2 < ActiveRecord::Migration
  def up
    rename_column :blacklists,:u_id , :black_user
  end

  def down
  end
end
