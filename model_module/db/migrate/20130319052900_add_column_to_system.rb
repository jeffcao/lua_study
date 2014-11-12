class AddColumnToSystem < ActiveRecord::Migration
  def change
    add_column :system_settings, :flag, :integer,:default => 0
  end
end
