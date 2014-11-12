require "rubygems"
gem 'activerecord', '3.2.12'
require 'mongoid'
require 'yaml'
require "json"
require "time"
require "active_record"
require "active_support"
require "mysql2"
require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"

require 'active_support'
require 'active_model'
require 'active_support/concern'
require 'active_model/dirty'


require "../../model_module/models/partner_sheet"
require "../../model_module/models/partmer"
require "../../model_module/models/partner_month_account"

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])
data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))

partners = Partmer.all
partners.each do |partner|
  date = Time.now.strftime("%Y-%m")
  flag = PartnerMonthAccount.find_by_appid_and_date(partner.appid,date)
  if flag.nil?
    record = PartnerMonthAccount.new
    record.appid = partner.appid
    record.name = partner.name
    record.date = date
    record.save
  end
  p "success"

end
