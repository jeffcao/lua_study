class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.integer :min_score
      t.integer :max_score

      t.timestamps
    end
  end
end
