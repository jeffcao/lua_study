class CreateUserTotalConsumeLists < ActiveRecord::Migration
  def change
    create_table :user_total_consume_lists do |t|

      t.timestamps
    end
  end
end
