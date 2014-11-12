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
require "../../model_module/models/user"

require "../../model_module/models/match_arrangement"
require "../../model_module/models/special_match_arrangement"
require "../../model_module/models/game_match"
require "../../model_module/models/game_room"
require "../../model_module/models/game_room_info"
require "../../model_module/models/game_score_info"

require "../../model_module/models/game_room_utility"
require "../../model_module/models/match_counter"

require "../../model_module/config/preinitializer"

p DDZRedis.syn_option
@@redis = Redis.new(DDZRedis.syn_option.merge(:driver => :ruby))
p @@redis

Redis.current = Redis.new(DDZRedis.syn_option)
p Redis.current

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

users = User.where(:robot=>1)
users.each do |user|
   if user.game_score_info.score > 10000000
     beans = (user.game_score_info.score/1000).to_i
     beans = beans.to_s.insert(beans.to_s.size,"0").to_i
     user.game_score_info.score = beans
     user.game_score_info.save
   end
end