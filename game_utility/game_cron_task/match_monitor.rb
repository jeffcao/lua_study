require "rubygems"
gem 'activerecord', '3.2.12'
require 'mongoid'
require 'yaml'
require "json"
require "time"
require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"

require "../../model_module/models/game_match"
require "../../model_module/models/game_table"
require "../../model_module/config/preinitializer"

p DDZRedis.syn_option
@@redis = Redis.new(DDZRedis.syn_option.merge(:driver => :ruby))
p @@redis

Redis.current = Redis.new(DDZRedis.syn_option)
p Redis.current

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)


class Job

	include GameTimingNotifyType

	def self.monitor_match
	 	matchs = GameMatch.where(:status.ne => "3")
	 	return if matchs.nil?
	 	matchs.each do |match|
	 		if match.status == 0
	 			handle_ready_match(match)
	 		elsif match.status == 1
	 			handle_in_joinable_match(match)
	 		else
	 			handle_in_un_joinable_match(match)
	 		end
	 		
	 	end
	end

	def self.handle_ready_match(match)
	 	return if match.begin_time > Time.now 
	 	notify_data = { notify_type: 1, room_id: match.room_id, match_seq: match.match_seq }
	 	@@redis.publish("game.match_msg_notify", notify_data.to_json)
	 	match.status = 1
	 	match.save
	end

	def self.handle_in_joinable_match(match)
		return if match.begin_time > 5.minute.ago
		notify_data = {notify_type: 2, room_id: match.room_id, match_seq: match.match_seq}
		@@redis.publish("game.match_msg_notify", notify_data.to_json)
	 	match.status = 2
	 	match.save
	end

	def self.handle_in_un_joinable_match(match)
		return if match.end_time > Time.now
		notify_data = {notify_type: 3, room_id: match.room_id, match_seq: match.match_seq}
		@@redis.publish("game.match_msg_notify", notify_data.to_json)

		notify_data = {:notify_type=>GameTimingNotifyType::END_MATCH, :room_id=>match.room_id, :match_seq=>match.match_seq}
		@@redis.publish("game.match_notify", notify_data.to_json)

	 	match.status = 3
	 	match.save
	end


end
# Job.get_servers_url
# p @server_url
Job.monitor_match



