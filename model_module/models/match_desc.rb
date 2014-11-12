class MatchDesc
  # attr_accessible :title, :body
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, type: String
  field :match_type, type: Integer
  field :short_desc, type: String
  field :description, type: String
  field :rule_desc, type: String
  field :begin_date, type: DateTime
  field :end_date, type: DateTime
  field :image_id, type: String
  field :short_name,type: String
  field :state,type: Integer,:default=>0
  field :created_by,type: String
  field :png_name,type:String
end
