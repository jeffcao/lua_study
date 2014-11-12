class CreateLoginLogs < ActiveRecord::Migration
  def change
    create_table :login_logs do |t|
      t.string :appid
      t.string :string
      t.string :imsi
      t.string :string
      t.string :mac
      t.string :string
      t.string :nick_name
      t.string :string
      t.string :brand
      t.string :string
      t.string :display
      t.string :string
      t.string :fingerprint
      t.string :string
      t.string :imei
      t.string :string
      t.string :os_release
      t.string :string
      t.string :version
      t.string :string
      t.string :city_id
      t.string :integer
      t.string :province_id
      t.string :integer
      t.string :user_id
      t.string :integer
      t.string :login_ip
      t.string :string
      t.string :login_time
      t.string :datetime

      t.timestamps
    end
  end
end
