class ColumnToPartnerSheet < ActiveRecord::Migration
  def up
    add_column :partner_sheets,:total_users_count,:integer,:default => 0
  end

  def down
  end
end
