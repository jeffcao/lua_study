class AddPaymentToSystemSetting < ActiveRecord::Migration
  def change
    add_column :system_settings,:payment,:string
  end
end
