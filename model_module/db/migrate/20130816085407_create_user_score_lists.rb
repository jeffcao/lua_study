class CreateUserScoreLists < ActiveRecord::Migration
  def change
    create_table :user_score_lists do |t|
      t.integer :user_id
      t.string :nick_name
      t.integer :score

      t.timestamps
    end
  end
end
