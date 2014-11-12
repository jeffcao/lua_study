class GameMatch
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :match_seq, type: Integer
  field :room_id, type: Integer
  field :entry_fee, type: Integer
  field :match_ante, type: Integer
  field :begin_time, type: DateTime
  field :end_time, type: DateTime
  field :status, type: Integer
  field :room_type, type: Integer
  field :rule_name,type:String
  field :bonus_name,type:String

#  note: status--0_ready_begin--1_in_match_can_join--2_in_match_cannot_join--3_ended_match
end