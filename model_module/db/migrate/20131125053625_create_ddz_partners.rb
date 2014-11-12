class CreateDdzPartners < ActiveRecord::Migration
  def change
    create_table :ddz_partners do |t|
      t.integer :appid
      t.string :consume_code
      t.string :enable

      t.timestamps
    end
  end
end
