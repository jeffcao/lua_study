class CreateVipCounts < ActiveRecord::Migration
  def change
    create_table :vip_counts do |t|
      t.string :vip_level
      t.integer :count

      t.timestamps
    end
  end
end
