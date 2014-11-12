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


require "../../model_module/config/preinitializer"

p DDZRedis.syn_option
@@redis = Redis.new(DDZRedis.syn_option.merge(:driver => :ruby))
p @@redis


class Job
	def self.trrigger_clear
	 tmp_instances = `ps aux |grep thin |grep ddz_game_server | awk '{print $2}'`
     tmp_instances = tmp_instances.split("\n")
     puts tmp_instances
     if tmp_instances.nil? or tmp_instances.length == 0
     	return
     end
     r_p_id = tmp_instances.first
     tmp_instances.each do |p_id|
     	tmp_r_pids = `ps aux |grep thin |grep ddz_game_server |grep #{p_id} | awk '{print $2}'`
     	tmp_r_pids = tmp_r_pids.split("\n")
     	if tmp_r_pids.length > 1
     		r_p_id = p_id
     		break
     	end
     end
     puts r_p_id
     @@redis.publish("game.clear_user", {:p_id=>r_p_id}.to_json)
   	end

end

Job.trrigger_clear
