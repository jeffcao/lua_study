class GameRoomUrl < ActiveRecord::Base
  belongs_to :game_room
  attr_accessible :domain_name, :game_room_id, :port, :status
end
