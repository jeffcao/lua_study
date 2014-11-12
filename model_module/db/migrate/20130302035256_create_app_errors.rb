class CreateAppErrors < ActiveRecord::Migration
  def change
    create_table :app_errors do |t|
      t.datetime :raise_time
      t.integer :appid
      t.string :appname
      t.string :version
      t.string :imei
      t.string :mac
      t.string :net_type
      t.string :model
      t.string :manufactory
      t.string :brand
      t.string :os_release
      t.string :fingerprint
      t.string :exception_info
      t.string :app_bulid

      t.timestamps
    end
  end
end
