class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :week_date
      t.string :activity_name
      t.string :activity_content
      t.string :activity_object
      t.string :activity_memo
      t.string :activity_model
      t.string :activity_parm
      t.string :activity_type

      t.timestamps
    end
  end
end
