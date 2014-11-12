class VipCount < ActiveRecord::Base
  attr_accessible :count, :vip_level
  def self.check_table_name(table_name = nil)
    table_name = Time.now.strftime("vip_count_%Y%m") if table_name.nil?
    unless self.table_name == table_name
      self.table_name = table_name
      unless self.table_exists?
        self.connection.execute("create table #{table_name} like vip_counts;")
        self.table_name = table_name
        self.reset_column_information
      end
    end
  end

  def self.count(level)
    level = level.downcase()
    check_table_name
    flag = VipCount.find_by_vip_level(level)
    if flag.nil?
      vip = VipCount.new
      vip.vip_level = level
      vip.count = 1
      vip.save
    else
      flag.count = flag.count + 1
      flag.save
    end
  end
end
