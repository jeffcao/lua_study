class AppError < ActiveRecord::Base
  attr_accessible :app_bulid, :appid, :appname, :brand, :exception_info, :fingerprint, :imei, :mac, :manufactory, :model, :net_type, :os_release, :raise_time, :version
end
