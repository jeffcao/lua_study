class CreateKefuPayMobiles < ActiveRecord::Migration
  def change
    create_table :kefu_pay_mobiles do |t|
      t.string :mobile
      t.string :pay_type
      t.integer :status
      t.text :cause
      t.string :picture_path

      t.timestamps
    end
  end
end
