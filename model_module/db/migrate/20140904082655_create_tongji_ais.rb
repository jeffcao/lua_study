class CreateTongjiAis < ActiveRecord::Migration
  def change
    create_table :tongji_ais do |t|
      t.string :match_seq
      t.string :role
      t.string :flag

      t.timestamps
    end
  end
end
