class CreatePartnerMonthAccounts < ActiveRecord::Migration
  def change
    create_table :partner_month_accounts do |t|
      t.integer :appid
      t.string :name
      t.string :date
      t.float :account

      t.timestamps
    end
  end
end
