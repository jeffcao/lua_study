class MatchCounter
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :seq_key, type: String
  field :seq_offset, type: Integer, default: 0
end