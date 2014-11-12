class GameView < ActiveRecord::Base
   def self.columns
     @columns ||=[]
   end
end