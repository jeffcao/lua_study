class CreateVisitUiCounts < ActiveRecord::Migration
  def change
    create_table :visit_ui_counts do |t|
      t.integer :ui_id
      t.integer :click_count
      t.integer :time_count

      t.timestamps
    end
  end
end
