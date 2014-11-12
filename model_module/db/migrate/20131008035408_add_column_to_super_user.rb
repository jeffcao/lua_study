class AddColumnToSuperUser < ActiveRecord::Migration
  def change
    add_column :super_users,:role,:string
  end
end
