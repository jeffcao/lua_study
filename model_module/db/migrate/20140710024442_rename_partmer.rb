class RenamePartmer < ActiveRecord::Migration
  def up
    rename_column :partmers,:appid,:partner_appid
    rename_column :partmers,:name,:partner_name
  end

  def down
  end
end
