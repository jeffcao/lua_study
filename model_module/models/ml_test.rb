class MlTest < ActiveRecord::Base
  def self.columns
    @columns ||=[]
  end
end