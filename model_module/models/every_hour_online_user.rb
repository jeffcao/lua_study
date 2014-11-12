class EveryHourOnlineUser
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :date, type: String
  field :zero, type: Integer,:default=>0
  field :one, type: Integer,:default=>0
  field :two, type: Integer,:default=>0
  field :three, type: Integer,:default=>0
  field :fourth, type: Integer,:default=>0
  field :fifth, type: Integer,:default=>0
  field :sixth, type: Integer,:default=>0
  field :seventh, type: Integer,:default=>0
  field :eighth, type: Integer,:default=>0
  field :ninth, type: Integer,:default=>0
  field :tenth, type: Integer,:default=>0
  field :eleventh, type: Integer,:default=>0
  field :twelfth, type: Integer,:default=>0
  field :thirteenth, type: Integer,:default=>0
  field :fourteenth, type: Integer,:default=>0
  field :fifteenth, type: Integer,:default=>0
  field :sixteenth, type: Integer,:default=>0
  field :seventeenth, type: Integer,:default=>0
  field :eighteenth, type: Integer,:default=>0
  field :nineteenth, type: Integer,:default=>0
  field :twentieth, type: Integer,:default=>0
  field :twenty_first, type: Integer,:default=>0
  field :twenty_second  , type: Integer,:default=>0
  field :twenty_third, type: Integer,:default=>0
  # attr_accessible :title, :body
end
