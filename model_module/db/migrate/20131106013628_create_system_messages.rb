class CreateSystemMessages < ActiveRecord::Migration
  def change
    create_table :system_messages do |t|
      t.string :content
      t.integer :message_type
      t.integer :failure_time

      t.timestamps
    end
  end
end
