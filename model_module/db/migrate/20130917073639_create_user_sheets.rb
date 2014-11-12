class CreateUserSheets < ActiveRecord::Migration
  def change
    create_table :user_sheets do |t|
      t.string :date
      t.integer :online_time_count, :default=>0
      t.integer :login_count, :default=>0
      t.integer :paiju_time_count,:default=>0
      t.integer :paiju_count,:default=>0
      t.integer :paiju_break_count,:default=>0
      t.integer :bank_broken_count,:default=>0

      t.timestamps
    end
  end
end
