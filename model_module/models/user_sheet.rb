class UserSheet < ActiveRecord::Base
  attr_accessible :bank_broken_count, :date, :login_count, :online_time_count, :paiju_break_count, :paiju_count, :paiju_time_count
  def self.user_sheet_init
    date = Time.now.strftime("%Y-%m-%d")
    record = UserSheet.find_by_date(date)
    if record.nil?
      record = UserSheet.new
      record.date = date
      record.save
    end
    record
  end

  def self.count_user_online_time(time)
    record = user_sheet_init
    record.online_time_count = record.online_time_count.to_i + time.to_i
    record.save
  end

  def self.count_user_login
    record = user_sheet_init
    record.login_count = record.login_count.to_i + 1
    record.save
  end

  def self.count_bank_broken_count
    record = user_sheet_init
    record.bank_broken_count = record.bank_broken_count.to_i + 1
    record.save
  end

  def self.count_paiju
    record = user_sheet_init
    record.paiju_count= record.paiju_count.to_i + 1
    record.save
  end

  def self.paiju_time_count(time)
    record = user_sheet_init
    record.paiju_time_count = record.paiju_time_count.to_i + time
    record.save

  end


end
