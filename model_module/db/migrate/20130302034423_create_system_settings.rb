class CreateSystemSettings < ActiveRecord::Migration
  def change
    create_table :system_settings do |t|
      t.string :setting_name
      t.string :setting_value
      t.string :description
      t.string :enabled

      t.timestamps
    end
  end
end
