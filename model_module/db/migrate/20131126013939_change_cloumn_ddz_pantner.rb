class ChangeCloumnDdzPantner < ActiveRecord::Migration
  def up
    change_column :ddz_partners,:appid,:string
  end

  def down
  end
end
