class DdzSheet < ActiveRecord::Base
  attr_accessible :add_day_user, :add_exp_user, :avg_hour_online, :date, :day_exp_user, :day_login_user, :day_max_online, :arpu, :game_id, :total_day_money, :total_exp_user, :total_online_time, :total_user
end
