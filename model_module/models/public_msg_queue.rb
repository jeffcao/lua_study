class PublicMsgQueue
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :msg_seq, type: Integer
  field :user_id, type: Integer
  field :sys_msg_id, type: String
  # msg_type, 1--push_msg, 2--tiger_msg, 3--bean_competition_msg, 4--money_competition_msg
  field :msg_type, type: Integer
  field :msg_content, type: String
  field :time_stampe, type: String
  field :priority, type: Integer
  field :state, type: Integer
  field :display_flag,type:Integer,:default=>0
end