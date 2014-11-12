class CreateMatchSystemSettings < ActiveRecord::Migration
  def change
    create_table :match_system_settings do |t|

      t.timestamps
    end
  end
end
