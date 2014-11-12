class RenameColumnToUserMobileSource < ActiveRecord::Migration
  def up
    rename_column :user_mobile_sources,:type,:mobile_type
  end

  def down
  end
end
