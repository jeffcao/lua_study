require "mongoid"

class DeviceNotifyQueue
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :msg_seq, type: Integer
  field :user_id, type: Integer
  field :sys_msg_id, type: String
  field :msg_content, type: String
  field :time_stampe, type: String
  field :priority, type: Integer
  field :state, type: Integer
end