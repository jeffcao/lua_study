class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :user_id
      t.string :imsi

      t.timestamps
    end
  end
end
