#encoding: utf-8
require "rubygems"
require "mysql2"
require 'yaml'
require "json"
require "net/http"

#每晚12点执行新的活动通知在线用户

new_activity_url = ""

sql = "select setting_value from system_settings where setting_name='ddz_hall_url'"
rows = @link.query(sql, :as=> :hash)
rows.each do |row|
  new_activity_url = "http://#{row["setting_value"]}/hall/new_activity"
end

begin
  url = URI.parse(new_activity_url)
  http_req = Net::HTTP::Get.new("#{url.path}")
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(http_req)
  }
rescue Exception=>e
  puts "[request_server_notify] e=>#{e}, msg=>#{e.message}"
end


