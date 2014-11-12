class AddColumnToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :version, :string

  end
end
