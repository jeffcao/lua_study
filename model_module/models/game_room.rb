class GameRoom < ActiveRecord::Base
  attr_accessible :ante, :max_qualification, :min_qualification, :name, :status,:fake_online_count,:limit_online_count,:room_type
  has_many :game_room_url, :dependent => :destroy,:conditions => {:status => 0}
  # room_type, 1--normal_room, 2--bean_competition_room, 3--money_competition_room
end
