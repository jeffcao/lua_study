class AddFirstBuyToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles,:first_buy,:integer,:default=>0
  end
end
