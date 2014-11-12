class SystemMessage < ActiveRecord::Base
  attr_accessible :content, :failure_time, :message_type
end
