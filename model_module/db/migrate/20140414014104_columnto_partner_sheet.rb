class ColumntoPartnerSheet < ActiveRecord::Migration
  def up
    add_column :partner_sheets,:email,:string
  end

  def down
  end
end