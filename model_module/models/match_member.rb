class MatchMember
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :user_id, type: Integer
  field :match_seq, type: Integer
  field :room_id, type: Integer
  field :room_type, type: Integer
  field :scores, type: Integer
  field :last_win_time, type: DateTime
  field :rank, type: Integer
  field :status, type: Integer

end