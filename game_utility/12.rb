#encoding: utf-8
require "rubygems"
require "mysql2"
require 'yaml'
require "json"
require "net/http"

#每晚12点执行新的活动通知在线用户

new_activity_url = "http://ddz.jc.170022.cn/hall/new_activity"
new_activity_url = "http://ddz.test.170022.cn:8081/hall/new_activity"

begin
  url = URI.parse(new_activity_url)
  http_req = Net::HTTP::Get.new("#{url.path}")
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(http_req)
  }
rescue Exception=>e
  puts "[request_server_notify] e=>#{e}, msg=>#{e.message}"
end


