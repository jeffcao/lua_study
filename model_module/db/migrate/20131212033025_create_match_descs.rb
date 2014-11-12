class CreateMatchDescs < ActiveRecord::Migration
  def change
    create_table :match_descs do |t|

      t.timestamps
    end
  end
end
