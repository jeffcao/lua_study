class ChargeDdzSheetColumn < ActiveRecord::Migration
  def up
    change_column :ddz_sheets,:total_day_money,:float
  end

  def down
  end
end
