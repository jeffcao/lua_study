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
#require "mongoid"

require 'active_support'
require 'active_model'
require 'active_support/concern'
require 'active_model/dirty'

require "../../game_push_message/lib/game_config"
require "../../game_push_message/lib/game_text"

require "../../model_module/models/base_model_helper"
require "../../model_module/models/redis_model_aware"
require "../../model_module/models/base_model"
require "../../model_module/models/user"
require "../../model_module/models/every_hour_online_user"
#EveryHourOnlineUser

require "../../model_module/models/match_arrangement"
require "../../model_module/models/special_match_arrangement"
require "../../model_module/models/game_match"
require "../../model_module/models/game_room"
require "../../model_module/models/game_room_info"
require "../../model_module/models/game_score_info"

require "../../model_module/models/game_room_utility"
require "../../model_module/models/match_counter"

require "../../model_module/config/preinitializer"
#require "../../model_module/config/preinitializer"


p DDZRedis.syn_option
@@redis = Redis.new(DDZRedis.syn_option.merge(:driver => :ruby))
p @@redis


Redis.current = Redis.new(DDZRedis.syn_option)
p Redis.current

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

msg_users = Redis.current.get("message_server_connections_key")
p "msg_users =>#{msg_users.to_i}"



login_users = Redis.current.get("login_connections_count_key")
p "login_users =>#{login_users}"




online_user_count = msg_users.to_i

p "online_user_count => #{online_user_count}"

date = Time.now.strftime("%Y-%m-%d")
hour = Time.now.strftime("%H")
p "hour=>#{hour}"

key = ["zero","one","two","three","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth","thirteenth","fourteenth","fifteenth","sixteenth","seventeenth","eighteenth","nineteenth","twentieth","twenty_first","twenty_second","twenty_third"]

record = EveryHourOnlineUser.where("date"=>"#{date}").first
 if record.nil?
   record = EveryHourOnlineUser.new
   record.update_attributes("date"=>date)
 end




column = key[hour.to_i]
p "column=>#{column}"
tmp_record = record.as_json
p "tmp_record=>#{tmp_record["#{column}"]}"
p "online_user_count=>#{online_user_count}"
record.update_attributes("#{column}"=>online_user_count) if tmp_record["#{column}"].to_i < online_user_count.to_i
record.save
