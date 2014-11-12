class UserConsumeList < ActiveRecord::Base
  def self.columns
    @columns ||=[]
  end
end