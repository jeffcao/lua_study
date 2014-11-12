class MsisdnRegion < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :province
  belongs_to :city
  attr_accessible :operator
end
