class UserConsumeLimit < ActiveRecord::Base
  attr_accessible :day_limit, :month_limit, :user_id,:payment
end
