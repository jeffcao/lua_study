class SpecialMatchArrangement
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :room_type, type: Integer
  field :special_day, type: Date
  field :entry_fee, type: Integer
  field :match_ante, type: Integer
  field :time_plan, type: Hash
  field :state, type: Integer
  field :created_by, type: String

end