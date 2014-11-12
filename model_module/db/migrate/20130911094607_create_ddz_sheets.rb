class CreateDdzSheets < ActiveRecord::Migration
  def change
    create_table :ddz_sheets do |t|
      t.string :date
      t.string :game_id
      t.integer :day_max_online
      t.integer :avg_hour_online
      t.integer :day_login_user
      t.integer :total_online_time
      t.integer :total_user
      t.integer :add_day_user
      t.integer :total_exp_user
      t.integer :day_exp_user
      t.integer :add_exp_user
      t.integer :total_day_money
      t.float :erpu

      t.timestamps
    end
  end
end
