class CreatePartmers < ActiveRecord::Migration
  def change
    create_table :partmers do |t|
      t.integer :appid
      t.string :name
      t.string :link_man
      t.string :telephone
      t.string :address

      t.timestamps
    end
  end
end
