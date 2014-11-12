#encoding:utf-8
#require "rubygems"
#require "mysql2"
#require 'yaml'
#require "json"
#require "net/http"
#require "time"
#require "active_record"
#require "active_support"
#require "mysql2"
#require "redis/connection/synchrony"
#require "redis"
#require "redis/connection/ruby"

#require 'active_support'
#require 'active_model'
#require 'active_support/concern'
#require 'active_model/dirty'
#require "../../model_module/models/user"
#dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
#ActiveRecord::Base.establish_connection(dataConfig["development"])

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

require "../../config/doudizhu/config/redis"
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
require "../../model_module/models/user"
require "../../model_module/models/game_product"
require "../../model_module/config/preinitializer"


Redis.current = Redis.new(DDZRedis.syn_option)
p Redis.current


dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

@hall_server_url=""
@game_server_url=""

data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))

localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
@link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")

def get_servers_url
	sql = "select setting_value from system_settings where setting_name='ddz_hall_url'"
	rows = @link.query(sql, :as=> :hash)
	rows.each do |row|
		@hall_server_url = "http://#{row["setting_value"]}/hall/expired_notify"
		p @hall_server_url
	end

	sql = "select setting_value from system_settings where setting_name='ddz_game_server_url'"
	rows = @link.query(sql, :as=> :hash)
	rows.each do |row|
		@game_server_url = "http://#{row["setting_value"]}/game/expired_notify"
		p @game_server_url
	end
end

def monitor_using_props
	rows = @link.query("select a.user_id, a.game_product_item_id, a.use_time, b.item_feature from user_used_props a, game_product_items b 
		where b.id = a.game_product_item_id and a.state = 1", :as=> :hash)
	p rows.count
	rows.each do |row|
    p row["user_id"]
    user_id = User.find(row["user_id"]).user_id
    game_item_id = row["game_product_item_id"]
    result = @link.query("select item_feature,request_seq from user_product_items where user_id='#{user_id}' and state=0 and game_item_id = '#{game_item_id}' order by created_at asc")
  	
    record = result.first unless result.nil? or result.count == 0
    unless row["item_feature"].nil? or record.nil?
			json_feature = JSON.parse(row["item_feature"])
      valid_period = json_feature["valid_period"].to_i
      request_seq = record["request_seq"]
      request_record = @link.query("select game_product_id from purchase_request_records where request_seq='#{request_seq}'") unless request_seq.nil?
      unless request_record.nil?
        prop_id = request_record.first["game_product_id"]
        prop = GameProduct.find(prop_id)
        if prop.product_name !="首充大礼包"
          valid_period = JSON.parse(record["item_feature"])["valid_period"].to_i
        else
          valid_period = JSON.parse(record["item_feature"])["shouchong_valid_period"].to_i
        end
      end

      #PurchaseRequestRecord



			begin_time = row["use_time"] + 8*60*60
			time_span = Time.now - begin_time
			p time_span
			if time_span > valid_period*60*60
			#if time_span > 2
				p 'modify db'
				modify_prop_record(row["user_id"], row["game_product_item_id"],request_seq)
			    request_server_notify(@hall_server_url, row["user_id"], row["game_product_item_id"])
			    request_server_notify(@game_server_url, row["user_id"], row["game_product_item_id"])
			end
		end
		
		
	end
end

def modify_prop_record(user_id, prop_id,request_seq=nil)
	sql = "update user_used_props set state=2 where user_id=#{user_id} and game_product_item_id=#{prop_id} and state=1"
	@link.query(sql)

	sql = "update user_product_item_counts set item_count = item_count - 1 where user_id=#{user_id} and game_product_item_id=#{prop_id}"
	@link.query(sql)

  unless request_seq.nil?
    sql = "update user_product_items set state =  1 where request_seq = '#{request_seq}'"
    @link.query(sql)
  end
end


def request_server_notify(server_url, user_id, prop_id)
	puts "[request_server_notify] server_url=>#{server_url}"
	begin
		url = URI.parse(server_url)
	    http_req = Net::HTTP::Get.new("#{url.path}?userid=#{user_id}&propid=#{prop_id}")
	    res = Net::HTTP.start(url.host, url.port) {|http|
	      http.request(http_req)
	    }
    rescue Exception=>e
    	puts "[request_server_notify] e=>#{e}, msg=>#{e.message}"
  	end
end
get_servers_url
monitor_using_props

