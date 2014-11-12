class GiftBag < ActiveRecord::Base
  attr_accessible :beans, :name, :price, :sale_count, :sale_limit
  has_many :gift_map, :dependent => :destroy
end
