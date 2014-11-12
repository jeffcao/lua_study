class CreateEveryHourOnlineUsers < ActiveRecord::Migration
  def change
    create_table :every_hour_online_users do |t|

      t.timestamps
    end
  end
end
