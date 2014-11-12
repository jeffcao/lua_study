class ChangeDomainNameTypeInGameRoomUrl < ActiveRecord::Migration
  def up
    change_column :game_room_urls, :domain_name, :string
  end

  def down
  end
end
