class PartnerSheet < ActiveRecord::Base
  attr_accessible :email,:add_count, :appid, :consume_count, :date, :login_count, :month,:total_users_count,:one_day_left_user,:three_day_left_user,:seven_day_left_user
end
