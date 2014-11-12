class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      t.integer :id
      t.string :content
      t.integer :type

      t.timestamps
    end
  end
end
