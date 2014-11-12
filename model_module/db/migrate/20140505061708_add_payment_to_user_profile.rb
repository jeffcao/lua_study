class AddPaymentToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles,:payment,:string
  end
end
