class MatchBonusSetting
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :room_type, type: Integer
  field :first, type: String
  field :second, type: String
  field :third, type: String
  field :fourth, type: String
  field :fifth, type: String
  field :created_by, type: String
  field :short_name,type:String
  field :bonus_desc,type:String

end