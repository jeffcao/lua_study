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
require "../../model_module/models/user"

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

class Job
  def self.mobile_charge_list
    i = 1
    UserMobileList.delete_all
    records = UserProfile.order("total_balance desc,created_at asc")

    records.each do |p|
      user = User.find(p.user_id)
      if user.robot.to_i ==0
        p user.user_id
        list = UserMobileList.new
        list.user_id = p.user_id
        list.nick_name = p.nick_name
        list.balance = p.total_balance
        list.position = i
        p i
        i =i+1
        list.save
      end
    end


  end

end

Job.mobile_charge_list