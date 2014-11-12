class MobileList < ActiveRecord::Base
  def self.columns
    @columns ||=[]
  end
end