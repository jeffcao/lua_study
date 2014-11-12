class CreateUserMobileLists < ActiveRecord::Migration
  def change
    create_table :user_mobile_lists do |t|

      t.timestamps
    end
  end
end
