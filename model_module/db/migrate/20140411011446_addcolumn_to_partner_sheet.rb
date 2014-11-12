class AddcolumnToPartnerSheet < ActiveRecord::Migration
  def up
    add_column :partner_sheets,:one_day_left_user,:integer,:default => 0
    add_column :partner_sheets,:three_day_left_user,:integer,:default => 0
    add_column :partner_sheets,:seven_day_left_user,:integer,:default => 0
  end

  def down
  end
end
