class LoginLog < ActiveRecord::Base
  attr_accessible :appid, :brand, :city_id, :display, :fingerprint, :imei, :imsi, :login_ip, :login_time, :mac, :nick_name, :os_release, :province_id, :user_id, :version

  def self.check_table_name
    log_table_name = Time.now.strftime("login_logs_%Y%m")

    unless self.table_name == log_table_name
      self.table_name = log_table_name
      unless self.table_exists?
        self.connection.execute("create table #{log_table_name} like login_logs;")
        self.table_name = log_table_name
        self.reset_column_information
      end
    end

  end

  def self.log_login(user)
    check_table_name
    log_params = {}
    log_params = log_params.merge({:appid => user.appid,
                                   :brand => user.brand,
                                   :display => user.display,
                                   :imei => user.imei,
                                   :imsi => user.imsi,
                                   :login_time => Time.now,
                                   :mac =>user.mac,
                                   :nick_name=>user.nick_name,
                                   :os_release => user.os_release,
                                   :user_id => user.user_id,
                                   :version =>user.user_profile.version
                                  })
    login_log_attrs = self.accessible_attributes.to_a
    log_params = log_params.select {|k, v| login_log_attrs.include?(k.to_s) }
    create(log_params)
  end




end
