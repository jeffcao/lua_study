#encoding: utf-8
require "yaml"
require "mysql2"
require 'eventmachine'
require 'time'

data = YAML.load(File.open("database.yml"))
localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
game_online_time =Time.parse("2013-09-07")
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")
p "begin time => #{Time.now}"
EM.run {
  EM.add_periodic_timer(100) {
    max_beans = link.query("select max(score) as max from game_score_infos")
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
    result = link.query("SELECT  users.user_id,users.nick_name,score FROM users join game_score_infos on users.id = game_score_infos.user_id  ORDER BY game_score_infos.score desc, game_score_infos.created_at asc LIMIT 50 OFFSET 0")
    result.each do |item|
      user_id = item["user_id"]
      nick_name = item["nick_name"]
      score = item["score"]
      p "insert into user_score_lists (user_id,nick_name,score) values('#{user_id}','#{nick_name}','#{score}')"
      link.query("insert into user_score_lists (user_id,nick_name,score) values('#{user_id}','#{nick_name}','#{score}')" )
      p "sccusses"
    end
    p "end time => #{Time.now}"

  }
}


