class GameScoreInfo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :all_count, :all_count, :flee_count, :lost_count, :score, :user_id, :win_count
end
