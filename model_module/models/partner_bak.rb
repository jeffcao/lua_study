class PartnerBak
  include Mongoid::Document
  field :appid, type: Integer
  field :constme_code, type: String
  field :enable, type: String
end
