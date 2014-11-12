class CreateHuoYueUsers < ActiveRecord::Migration
  def change
    create_table :huo_yue_users do |t|
      t.string :date
      t.integer :hour
      t.integer :count_1
      t.integer :count_2
      t.integer :count_3
      t.integer :count_4

      t.timestamps
    end
  end
end
