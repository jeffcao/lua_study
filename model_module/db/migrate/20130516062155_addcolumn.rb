class Addcolumn < ActiveRecord::Migration
  def up
    add_column :super_users, :superadmin, :boolean,
               :null => false,
               :default => false
    #User.create! do |r|
    #  r.email      = 'default@example.com'
    #  r.password   = 'password'
    #  r.superadmin = true
    #end
  end

  def down
    remove_column :super_users, :superadmin
    SuperUser.find_by_email('default@example.com').try(:delete)
  end
end
