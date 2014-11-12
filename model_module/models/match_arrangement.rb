class MatchArrangement
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :room_type, type: Integer
  field :monday, type: Hash
  field :tuesday, type: Hash
  field :wednesday, type: Hash
  field :thursday, type: Hash
  field :friday, type: Hash
  field :saturday, type: Hash
  field :sunday, type: Hash
  field :created_by, type: String

# note: monday={"entry_fee"=>10000, "match_ante"=>1000,
# "time_plan"=>[{"begin_time"=>"12:00", "duration"=>40, "count"=>3},{"begin_time"=>"15:00", "duration"=>30, "count"=>5}]}
end