class SystemSetting < ActiveRecord::Base
  attr_accessible :description, :enabled, :setting_name, :setting_value, :flag,:payment
end
