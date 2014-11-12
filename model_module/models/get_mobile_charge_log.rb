class GetMobileChargeLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :status, type: Integer, :default => 0
  field :user_id, type: Integer
  field :fee, type: Integer
end
