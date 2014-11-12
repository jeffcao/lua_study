class AddColumnsToPartnerSheet < ActiveRecord::Migration
  def up
    add_column :partner_sheets,:one_day_left_user_rate,:integer,:default => 0
    add_column :partner_sheets,:three_day_left_user_rate,:integer,:default => 0
    add_column :partner_sheets,:seven_day_left_user_rate,:integer,:default => 0
  end

  def down
  end
end
