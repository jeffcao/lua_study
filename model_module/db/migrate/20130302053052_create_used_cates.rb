class CreateUsedCates < ActiveRecord::Migration
  def change
    create_table :used_cates do |t|
      t.integer :user_id
      t.integer :cate_id
      t.integer :valid
      t.datetime :cate_begin
      t.datetime :cate_last

      t.timestamps
    end
  end
end
