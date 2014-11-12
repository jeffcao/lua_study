class UserChangeMobile < ActiveRecord::Base
  def self.columns
    @columns ||=[]
  end
end