#encoding: utf-8
require "yaml"
require "mysql"
require "mysql2"
require 'eventmachine'
require 'time'
require 'net/http'

server_url = ""

data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))

localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
game_online_time =Time.parse("2013-09-07")
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")
p "begin time => #{Time.now}"

sql = "select setting_value from system_settings where setting_name='ddz_game_server_url'"
rows = link.query(sql, :as=> :hash)
rows.each do |row|
  server_url = "http://#{row["setting_value"]}/game/user_enter_score_list"
end

#EM.run {
#  EM.add_periodic_timer(180) {
#    max_beans = link.query("select max(score) as max from game_score_infos")
    max_beans = link.query("select users.id,max(score) as max from users join game_score_infos on users.id=game_score_infos.user_id where robot=0")
    max_beans = max_beans.first["max"]
    p "begin time => #{Time.now}"
    link.query("delete from user_score_lists")
    time_now = Time.now.strftime("%Y-%m-%d")
    time = (Time.parse(time_now)-game_online_time)/(24*60*60).to_i
    p "robot_one"

    robot_ones = link.query("select id from users where robot=1 and robot_type=1")
    robot_ones.each do |robot_one|
      id = robot_one["id"]
      beans = time.to_i * 10000 * rand(0.1..0.3).to_s[0,4].to_f
      beans = beans.to_i
      p "update game_score_infos set score=#{beans} where user_id=#{id}"
      link.query("update game_score_infos set score=#{beans} where user_id=#{id}")
    end

    p "robot_second"

    robot_seconds = link.query("select id from users where robot=1 and robot_type=2")
    robot_seconds.each do |robot_second|
      id = robot_second["id"]
      beans = max_beans * rand(0.9..1.1).to_s[0,4].to_f
      beans=beans.to_i
      p "update game_score_infos set score=#{beans} where user_id=#{id}"
      link.query("update game_score_infos set score=#{beans} where user_id=#{id}")
    end

    p "robot_third"


    robot_thirds= link.query("select id from users where robot=1 and robot_type=3")
    robot_thirds.each do |robot_third|
      id = robot_third["id"]
      beans = max_beans * rand(0.75..0.95).to_s[0,4].to_f
      beans = beans.to_i
      p "update game_score_infos set score=#{beans} where user_id=#{id}"
      link.query("update game_score_infos set score=#{beans} where user_id=#{id}")
    end

    p "robot_fourth"

    robot_fourths = link.query("select id from users where robot=1 and robot_type=4")
    robot_fourths.each do |robot_fourth|
      id = robot_fourth["id"]
      beans = time.to_i * 100000 * rand(0.1..0.3).to_s[0,4].to_f
      beans = beans.to_i
      p "update game_score_infos set score=#{beans} where user_id=#{id}"
      link.query("update game_score_infos set score=#{beans} where user_id=#{id}")
    end




    #result = GameScoreInfo.limit(50).offset(0).order("score desc").order("created_at asc")
    result = link.query("SELECT  users.user_id,users.nick_name,score FROM users join game_score_infos on users.id = game_score_infos.user_id  ORDER BY game_score_infos.score desc, game_score_infos.created_at asc")
    result.each do |item|
      user_id = item["user_id"]
      nick_name = item["nick_name"]
      score = item["score"]
      p "insert into user_score_lists (user_id,nick_name,score,created_at) values('#{user_id}','#{nick_name}','#{score}','#{Time.now}')" 
      nick_name = Mysql.escape_string(nick_name)     
 link.query("insert into user_score_lists (user_id,nick_name,score,created_at) values('#{user_id}','#{nick_name}','#{score}','#{Time.now}')" )
      p "sccusses"
    end
    p "end time => #{Time.now}"

    # 上面统计用户排行50名

    #下面开始对进入50名的用户发送广播消息
    result = link.query("select user_id from user_score_lists limit 0,50")
    user_id = nil
    result.each do |item|
      if user_id.nil?
        user_id = item["user_id"].to_s
      else
        user_id = user_id + "," + item["user_id"].to_s
      end
    end
    url = URI.parse(server_url)
    response = Net::HTTP.post_form(server_url,{'user_id'=>user_id})


#  }
#}


