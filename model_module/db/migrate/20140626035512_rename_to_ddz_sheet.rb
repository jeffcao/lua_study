class RenameToDdzSheet < ActiveRecord::Migration
  def up
    rename_column :ddz_sheets,:erpu,:arpu
  end

  def down
  end
end
