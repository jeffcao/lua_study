class UserMobileList
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  # attr_accessible :title, :body
  field :user_id, type: Integer
  field :nick_name, type: String
  field :balance, type: Integer
  field :position,type: Integer
end
