class Addcolumntouserprofile < ActiveRecord::Migration
  def up
    add_column :user_profiles,:balance,:integer,:default =>0
  end

  def down
  end
end
