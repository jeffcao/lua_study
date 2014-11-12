class CreateGetSalaries < ActiveRecord::Migration
  def change
    create_table :get_salaries do |t|
      t.integer :user_id
      t.string :date

      t.timestamps
    end
  end
end
