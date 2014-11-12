class CreateBankrupts < ActiveRecord::Migration
  def change
    create_table :bankrupts do |t|
      t.integer :user_id
      t.string :date
      t.integer :count

      t.timestamps
    end
  end
end
