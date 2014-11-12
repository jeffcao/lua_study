class CreateSlotMachineLogs < ActiveRecord::Migration
  def change
    create_table :slot_machine_logs do |t|
      t.integer :user_id
      t.string :content

      t.timestamps
    end
  end
end
