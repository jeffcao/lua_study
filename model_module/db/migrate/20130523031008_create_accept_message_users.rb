class CreateAcceptMessageUsers < ActiveRecord::Migration
  def change
    create_table :accept_message_users do |t|
      t.string :name
      t.string :mobile

      t.timestamps
    end
  end
end
