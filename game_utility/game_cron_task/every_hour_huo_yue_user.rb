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

require "../../game_push_message/lib/game_config"
require "../../game_push_message/lib/game_text"

require "../../model_module/models/base_model_helper"
require "../../model_module/models/redis_model_aware"
require "../../model_module/models/base_model"

require "../../model_module/models/match_arrangement"
require "../../model_module/models/special_match_arrangement"
require "../../model_module/models/game_match"
require "../../model_module/models/game_room"
require "../../model_module/models/game_room_info"

require "../../model_module/models/game_room_utility"
require "../../model_module/models/match_counter"

require "../../model_module/config/preinitializer"
require "../../model_module/models/huo_yue_user"
data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))

#p DDZRedis.syn_option
#@@redis = Redis.new(DDZRedis.syn_option.merge(:driver => :ruby))
#p @@redis

Redis.current = Redis.new(DDZRedis.syn_option)
p Redis.current

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]

link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")
date = Time.now.strftime("%Y-%m-%d")
if date != 1.hour.ago(Time.now).strftime("%Y-%m-%d")
  date = 1.hour.ago(Time.now).strftime("%Y-%m-%d")
end
hour = 1.hour.ago(Time.now).strftime("%H")
date_1 = 1.hour.ago(Time.now).strftime("%Y-%m-%d %H:00:00")
date_2 = 15.minutes.since(date_1.to_time).to_s[0,19]
date_3 = 30.minutes.since(date_1.to_time).to_s[0,19]
date_4 = 45.minutes.since(date_1.to_time).to_s[0,19]
date_5 = 60.minutes.since(date_1.to_time).to_s[0,19]

p "date_1 =>#{date_1}"
p "date_2 =>#{date_2}"

p "date_3 =>#{date_3}"

p "date_4 =>#{date_4}"
p "date_5 =>#{date_5}"



table = "login_logs_#{date[0..7].gsub("-","")}"
p "table=>#{table}"

sql = "select count(distinct(user_id)) as sum from #{table} where date_add(created_at, interval 8 hour) between '#{date_1}' and '#{date_2}' "
result = link.query(sql)
p "sql=>#{sql}"
count_1 = result.first["sum"].to_i


sql = "select count(distinct(user_id)) as sum from #{table} where date_add(created_at, interval 8 hour) between '#{date_2}' and '#{date_3}' "
result = link.query(sql)
p "sql=>#{sql}"

count_2 = result.first["sum"].to_i


sql = "select count(distinct(user_id)) as sum from #{table} where date_add(created_at, interval 8 hour) between '#{date_3}' and '#{date_4}' "
result = link.query(sql)
p "sql=>#{sql}"

count_3 = result.first["sum"].to_i


sql = "select count(distinct(user_id)) as sum from #{table} where date_add(created_at, interval 8 hour) between '#{date_4}' and '#{date_5}' "
result = link.query(sql)
p "sql=>#{sql}"

count_4 = result.first["sum"].to_i

p "count_1=>#{count_1}  count_2=>#{count_2} count_3=>#{count_3} count_4=>#{count_4}"


sql = "select count(distinct(user_id)) as sum from #{table} where date_add(created_at, interval 8 hour) between '#{date_1}' and '#{date_5}' "
result = link.query(sql)
p "sql=>#{sql}"

count_5 = result.first["sum"].to_i

record = HuoYueUser.find_by_date_and_hour(date,hour)
record = HuoYueUser.new if record.nil?
record.date =date
record.hour = hour
record.count_1 = count_1.to_i
record.count_2 = count_2.to_i
record.count_3 = count_3.to_i
record.count_4 = count_4.to_i
record.hour_total = count_5.to_i
record.save




