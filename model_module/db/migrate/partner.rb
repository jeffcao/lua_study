#encoding: utf-8
require "json"
require "open-uri"
require "yaml"
require "mysql2"
#:wq
# data = YAML.load(File.open("database.yml"))
data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))

localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
#localhost = "localhost"
#username = "root"
#database = "locate_dev"
#password = "mingliang"
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")
date = Time.now.strftime("%Y-%m-%d").to_s
sql = "select appid,count(price) as sum from purchase_request_records where request_time like '#{date}%' group by appid "
p sql
result = link.query(sql)
