class CreateUserMobileSources < ActiveRecord::Migration
  def change
    create_table :user_mobile_sources do |t|
      t.integer :user_id
      t.float :num
      t.text :source

      t.timestamps
    end
  end
end
