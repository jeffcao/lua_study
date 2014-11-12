class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :brand
      t.string :model
      t.string :display
      t.string :os_release
      t.text :content
      t.string :manufactory
      t.string :string

      t.timestamps
    end
  end
end
