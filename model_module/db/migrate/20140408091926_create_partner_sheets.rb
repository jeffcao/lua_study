class CreatePartnerSheets < ActiveRecord::Migration
  def change
    create_table :partner_sheets do |t|
      t.string :date
      t.integer :appid
      t.integer :add_count,:default => 0
      t.integer :login_count,:default =>0
      t.float :consume_count, :default =>0
      t.float :month,:default =>0

      t.timestamps
    end
  end
end
