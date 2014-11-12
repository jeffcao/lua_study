class AddColumnSignUpGetChargetouserprofile < ActiveRecord::Migration
  def up
    add_column :user_profiles,:sign_up_get_charge,:integer,:default=>0
  end

  def down
  end
end
