class CreateGameUserCates < ActiveRecord::Migration
  def change
    create_table :game_user_cates do |t|
      t.integer :user_id
      t.integer :cate_id
      t.integer :game_id
      t.integer :cate_count
      t.integer :used_flag

      t.timestamps
    end
  end
end
