class CreateMsisdnRegions < ActiveRecord::Migration
  def change
    create_table :msisdn_regions do |t|
      t.references :province
      t.references :city
      t.string :operator

      t.timestamps
    end
    add_index :msisdn_regions, :province_id
    add_index :msisdn_regions, :city_id
  end
end
