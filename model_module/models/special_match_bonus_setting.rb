class SpecialMatchBonusSetting
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :room_type, type: Integer
  field :special_day, type: Date
  field :first, type: Integer
  field :second, type: Integer
  field :third, type: Integer
  field :fourth, type: Integer
  field :fifth, type: Integer
  field :created_by, type: String

end