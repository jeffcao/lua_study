class CreateUseCateLogs < ActiveRecord::Migration
  def change
    create_table :use_cate_logs do |t|
      t.integer :user_id
      t.integer :cate_id
      t.string :used_date
      t.string :datetime

      t.timestamps
    end
  end
end
