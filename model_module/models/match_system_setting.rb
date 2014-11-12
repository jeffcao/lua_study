class MatchSystemSetting
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :join_match_user_count,type: Integer
  field :created_by, type: String
  field :mobile_charge,type:Integer
  field :play_card_timing,type:Integer

  # attr_accessible :title, :body
end
