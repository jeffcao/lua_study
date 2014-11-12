class AddUsedCreditToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :used_credit, :integer, :default => 0
  end
end
