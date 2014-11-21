#encoding: utf-8
#require "rubygems"
#require "json"
#require "open-uri"
#require "yaml"
#require "mysql2"
#require "active_record"
#require "active_support"

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
require "../../model_module/models/user"
require "../../model_module/models/partmer"

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])
data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))

localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]

result = []
partner_appid = []
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")
date = Time.now.strftime("%Y-%m-%d").to_s
#date = "2014-08-20"
table = "login_logs_#{date[0..7].gsub("-","")}"

sql = "select distinct(appid) as appid from users"
array_appid = link.query(sql)
array_appid.each do |appid|
  partner_appid.push(appid["appid"]) if appid["appid"].to_s.length>0
end
appids = []
all_appid = Partmer.all
all_appid.each do |cp|
  appids.push(cp.partner_appid)
end

p partner_appid


sql = "select appid,sum(price) as sum_price from purchase_request_records where state=1 and date_add(request_time, interval 8 hour) like '#{date}%' group by appid "
p sql
result = link.query(sql)

partner_consume = {}
result.each do |data|
  if data["appid"].to_s.length>0
    partner_consume["#{data['appid']}"] = data['sum_price']
  end
end


one_day_date  = 1.day.ago(date.to_time).strftime("%Y-%m-%d")
three_day_date  = 3.days.ago(date.to_time).strftime("%Y-%m-%d")
seven_day_date  = 7.days.ago(date.to_time).strftime("%Y-%m-%d")
appids.each do |appid|
  p appid
  p date
  record = PartnerSheet.find_by_date_and_appid(date,appid)
  if record.nil?
    record = PartnerSheet.new
    record.date = date
  end
  record.appid = appid
  if appid.to_s.length>1
    email = Partmer.find_by_partner_appid(appid).email unless Partmer.find_by_partner_appid(appid).nil?
  end
  one_ago_add_count = User.find_by_sql("select * from users where appid='#{appid}' and date_add(created_at, interval 8 hour) like '#{one_day_date}%' ").count.to_i
  three_ago_add_count = User.find_by_sql("select * from users where appid='#{appid}' and date_add(created_at, interval 8 hour) like '#{three_day_date}%' ").count.to_i
  seven_ago_add_count = User.find_by_sql("select * from users where appid='#{appid}' and date_add(created_at, interval 8 hour) like '#{seven_day_date}%' ").count.to_i

  record.consume_count = partner_consume["#{appid}"].to_f
  record.add_count = User.find_by_sql("select * from users where appid='#{appid}' and date_add(created_at, interval 8 hour) like '#{date}%' ").count.to_i
  record.login_count = User.find_by_sql("select * from users where appid='#{appid}' and date_add(updated_at, interval 8 hour) like '#{date}%'").count.to_i
  
  partner_login_count = link.query("select count(distinct(user_id)) as sum from #{table} where appid = '#{appid}' and date_add(created_at, interval 8 hour) like '#{date}%'")
  record.login_count = partner_login_count.first["sum"]


  record.total_users_count = User.where(:appid =>appid).count.to_i
  record.one_day_left_user =  User.find_by_sql("select * from users where appid='#{appid}' and date_add(updated_at, interval 8 hour) like '#{date}%' and date_add(created_at, interval 8 hour) like '#{one_day_date}%'").count.to_i
  record.three_day_left_user =  User.find_by_sql("select * from users where appid='#{appid}' and date_add(updated_at, interval 8 hour) like '#{date}%' and date_add(created_at, interval 8 hour) like '#{three_day_date}%'").count.to_i
  record.seven_day_left_user =  User.find_by_sql("select * from users where appid='#{appid}' and date_add(updated_at, interval 8 hour) like '#{date}%' and date_add(created_at, interval 8 hour) like '#{seven_day_date}%'").count.to_i
  record.one_day_left_user_rate = (record.one_day_left_user*100/one_ago_add_count).round(0) if one_ago_add_count > 0
  record.three_day_left_user_rate = (record.three_day_left_user*100/three_ago_add_count).round(0) if three_ago_add_count > 0
  record.seven_day_left_user_rate = (record.seven_day_left_user*100/seven_ago_add_count).round(0) if seven_ago_add_count > 0
  record.email = email
  record.save
end
