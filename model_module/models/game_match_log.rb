class GameMatchLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :user_id, type: Integer
  field :content, type: String
  field :match_type, type: Integer
end
