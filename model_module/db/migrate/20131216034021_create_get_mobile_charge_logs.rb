class CreateGetMobileChargeLogs < ActiveRecord::Migration
  def change
    create_table :get_mobile_charge_logs do |t|

      t.timestamps
    end
  end
end
