#encoding: utf-8
require "rubygems"
require "mysql2"
require 'yaml'
require "json"
require "net/http"
require "redis"

data = YAML.load(File.open("../config/doudizhu/config/database.yml"))
#localhost = data["development"]["host"]
#username = data["development"]["username"]
#database = data["development"]["database"]
#password = data["development"]["password"]

redis_key = "join_day_activity_1010"

localhost = "localhost"
username = "root"
database = "locate_dev"
password = "mingliang"
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")

redis = Redis.new(:host => 'localhost', :port => 6379, :driver => :ruby)

user_ids = link.query("select users.id,users.user_id,score from users join game_score_infos on users.id=game_score_infos.user_id")
user_ids.each do |user_id|
  key ="#{redis_key}_#{user_id["user_id"]}"
  id = user_id["id"]
  p id
  if redis.exists(key)
    if user_id["score"] > 10000
      score = user_id["score"]-10000
    else
      score = 0
    end

    link.query("update game_score_infos set score=#{score} where id = #{id}")

    if score <= 0
      level = "短工"
    elsif score > 1216700000
      level = "仁主"
    else
      #level_result = Level.where(["min_score<=? and max_score>=?",score,score]).first
      level_result = link.query("select name from levels where min_score<=#{score} and max_score>=#{score}")
      level = level_result.first["name"]
    end
    p "update users set game_level = '#{level}' where id = #{id}"
    link.query("update users set game_level = '#{level}' where id = #{id}")
    redis.del(key)
  else
    next
  end

end



