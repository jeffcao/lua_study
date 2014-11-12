class AddColumnToddzsheet < ActiveRecord::Migration
  def up
    add_column :ddz_sheets, :platform, :string
    change_column :ddz_sheets, :day_max_online, :integer, :default => 0
  end

  def down
  end
end
