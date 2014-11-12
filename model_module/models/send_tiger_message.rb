class SendTigerMessage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :user_id, type: Integer
  field :data, type: Hash
  field :status, type: Integer,:default => 0
end
