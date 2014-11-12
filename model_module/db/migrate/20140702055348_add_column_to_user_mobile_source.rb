class AddColumnToUserMobileSource < ActiveRecord::Migration
  def change
    add_column :user_mobile_sources,:type,:Integer,:default=>0
  end
end
