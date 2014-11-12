class UserMobileSource < ActiveRecord::Base
  attr_accessible :num, :source, :user_id,:mobile_type
end
