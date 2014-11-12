class CreateDialogueCounts < ActiveRecord::Migration
  def change
    create_table :dialogue_counts do |t|
      t.integer :dialogue_id
      t.integer :count

      t.timestamps
    end
  end
end
