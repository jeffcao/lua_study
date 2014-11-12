class UserProfile < ActiveRecord::Base
  attr_accessible :appid, :email, :gender, :last_login_at, :memo, :msisdn, :nick_name, :user_id,
                  :birthday, :avatar, :last_active_at, :online_time, :consecutive,:day_total_game,
                  :day_continue_win,:balance,:total_balance,:first_buy, :used_credit,:payment,:sign_up_get_charge
end
