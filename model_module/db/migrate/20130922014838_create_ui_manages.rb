class CreateUiManages < ActiveRecord::Migration
  def change
    create_table :ui_manages do |t|
      t.integer :id
      t.string :content

      t.timestamps
    end
  end
end
