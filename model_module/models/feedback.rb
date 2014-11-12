class Feedback < ActiveRecord::Base
  attr_accessible :brand, :content, :display, :manufactory, :model, :os_release, :string, :user_id
end
