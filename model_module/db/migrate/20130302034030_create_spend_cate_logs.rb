class CreateSpendCateLogs < ActiveRecord::Migration
  def change
    create_table :spend_cate_logs do |t|
      t.integer :user_id
      t.integer :cate_id
      t.integer :cate_count
      t.string :spend_count
      t.datetime :add_date

      t.timestamps
    end
  end
end
