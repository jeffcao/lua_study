class UserTotalConsumeList
  # attr_accessible :title, :body
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :rank, type: Integer
  field :user_id, type: Integer
  field :nick_name, type: String
  field :total_consume, type: Integer
  field :total_balance, type: Integer
  field :get_balance, type: Integer
  field :mobile, type: String


end
