class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :nick_name
      t.string :gender
      t.string :email
      t.string :appid
      t.string :msisdn
      t.string :memo
      t.datetime :last_login_at

      t.timestamps
    end
  end
end
