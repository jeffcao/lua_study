#encoding: utf-8
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

#require "../../config/doudizhu/config/redis"
require "../../game_push_message/lib/game_config"
require "../../game_push_message/lib/game_text"

require "../../model_module/models/user_profile"
#require "../../model_module/models/redis_model_aware"
#require "../../model_module/models/base_model"

#require "../../model_module/models/match_arrangement"
#require "../../model_module/models/special_match_arrangement"
#require "../../model_module/models/game_match"
#require "../../model_module/models/game_room"
#require "../../model_module/models/game_room_info"
#
#require "../../model_module/models/game_room_utility"
#require "../../model_module/models/match_counter"
require "../../model_module/models/user_mobile_list"
require "../../model_module/models/user_total_consume_list"
require "../../model_module/models/user"

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

class Job
  def self.user_consume_list
    i = 1
    UserTotalConsumeList.delete_all
    records = User.where("user_id > 40000 ").order("total_consume desc,created_at asc")
    p records.count()
    records.each do |p|
      if p.user_profile.nil? 
        next
      end
      list = UserTotalConsumeList.new
      list.user_id = p.user_id
      list.nick_name = p.user_profile.nick_name
      list.rank = i
      list.total_consume = p.total_consume
      list.total_balance = p.user_profile.total_balance.to_i
      list.get_balance = p.user_profile.total_balance.to_i - p.user_profile.balance.to_i
      list.mobile = p.user_profile.msisdn
      i = i + 1
      list.save
    end
  end

end

Job.user_consume_list