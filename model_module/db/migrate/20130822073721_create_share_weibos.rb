class CreateShareWeibos < ActiveRecord::Migration
  def change
    create_table :share_weibos do |t|
      t.string :url
      t.string :appkey
      t.string :title
      t.string :ralate_uid

      t.timestamps
    end
  end
end
