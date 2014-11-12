class UserScoreList < ActiveRecord::Base
  attr_accessible :nick_name, :score, :user_id
end
