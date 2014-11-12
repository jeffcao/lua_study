class UserCreditSetup < ActiveRecord::Base
  def self.columns
    @columns ||=[]
  end
end