class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :nick_name
      t.integer :game_id
      t.string :password_digest
      t.string :password_salt
      t.string :msisdn
      t.string :imsi
      t.string :mac
      t.string :os_release
      t.string :manufactory
      t.string :brand
      t.string :model
      t.string :display
      t.string :fingerprint
      t.integer :appid
      t.string :version

      t.timestamps
    end
  end
end
