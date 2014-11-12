require "rubygems"
require 'mongoid'
require 'yaml'
require "json"
require "time"
require "active_support"

require "../../model_module/models/device_notify_queue"
require "../../model_module/models/public_msg_queue"
require "../../model_module/models/message_counter"
require "../../model_module/models/game_push_message"
require "../../game_push_message/lib/logic/message_utility"


Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

class Job
	include MessageUtility
	
	def self.update_device_message
	 	device_messages = GamePushMessage.where(:position => "1", :p_time.lt => 1.hour.since.to_s[0,19], :type => 3)
	 	return if device_messages.nil?
	 	device_messages.each do |msg|

	 		p msg.content
 			msg_seq = new_device_msg_seq
 			p "create device notify, msg_seq=>#{msg_seq}"
 			DeviceNotifyQueue.create(:msg_seq => msg_seq, :time_stampe=>msg.p_time, :sys_msg_id=>msg._id, 
 				:msg_content=>msg.content, :priority=>msg.level.to_i, :state=>0, :user_id=>0)

	 		msg.update_attributes(:type=>4)
	 	end
	end

	def self.update_game_message
	 	game_messages = GamePushMessage.where(:position => "2", :type => 3)
	 	return if game_messages.nil?
	 	game_messages.each do |msg|

	 		p msg.content
			msg_seq = new_public_msg_seq
			p "create public mesage, msg_seq=>#{msg_seq}"
 			PublicMsgQueue.create(:msg_seq => msg_seq, :time_stampe=>msg.p_time, :sys_msg_id=>msg._id, 
 				:msg_content=>msg.content, :priority=>msg.level.to_i, :state=>0, :msg_type=>1, :user_id=>0)
 			
	 		msg.update_attributes(:type=>4)
	 	end
	end
end

Job.update_device_message
Job.update_game_message


