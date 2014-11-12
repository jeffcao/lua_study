#encoding: utf-8
require "json"
require "open-uri"
require "yaml"
require "mysql2"
data = YAML.load(File.open("database.yml"))
localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
localhost = "localhost"
username = "root"
database = "locate_dev"
password = "mingliang"
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")

date = Time.now.strftime("%Y-%m-%d").to_s
table = "login_logs_#{date[0..7].gsub("-","")}"


sql = "create table if not exists login_logs_201307 like login_logs"
link.query(sql)
p " 检查表格存在否=>#{sql}"

sql = "select * from ddz_sheets where date='#{date}'"
result = link.query(sql)
p "检测记录 => #{sql}"
p "#{result.first}"
if result.first.nil?
  sql = "insert into ddz_sheets(date) values ('#{date}')"
  link.query(sql)
end







sql = "select count(distinct(user_id)) as sum from #{table} where created_at like '%#{date}%'"
day_login_user = link.query(sql)
day_login_user = day_login_user.first["sum"]
p "活跃用户 => #{sql} value =>#{day_login_user}"


sql = "select count(*) as sum from user_profiles"
total_user = link.query(sql)
total_user = total_user.first["sum"]
p "用户总量=>#{sql} value=>#{total_user}"



sql = "select count(*) as sum from user_profiles where created_at like '%#{date}%'"
add_day_user = link.query(sql)
add_day_user = add_day_user.first["sum"]
p "日新增用户=>#{sql} value=>#{add_day_user}"


sql = "select count(distinct(user_id)) as sum from purchase_request_records where state=0 "
total_exp_user = link.query(sql)
total_exp_user = total_exp_user.first["sum"]
p "总付费用户=>#{sql}  value=>#{total_exp_user}"


sql = "select count(distinct(user_id)) as sum from purchase_request_records where state=0 and created_at like '%#{date}%'"
day_exp_user = link.query(sql)
day_exp_user = day_exp_user.first["sum"]
p "日付费用户=>#{sql} value=>#{day_exp_user}"


sql = " select count(distinct(user_id)) as sum from purchase_request_records where  not exists (select distinct(user_id ) from purchase_request_records where created_at not like '%#{date}%')"
add_exp_user = link.query(sql)
add_exp_user = add_exp_user.first["sum"]
p "新增充值用户=>#{sql} value=>#{add_exp_user}"


sql = "select sum(game_products.price/100*purchase_request_records.product_count) as sum from purchase_request_records join game_products on purchase_request_records.game_product_id = game_products.id where purchase_request_records.created_at like '#{date}' and purchase_request_records.state=1"
total_day_money = link.query(sql)
total_day_money = total_day_money.first["sum"]
total_day_money = total_day_money.to_i if total_day_money.nil?
p "当日充值统计=>#{sql} value=>#{total_day_money}"

erpu = add_exp_user==0 ? 0:total_day_money.to_f/add_exp_user
p "ERPU => #{erpu}"


sql = "update ddz_sheets set avg_hour_online = day_max_online/24,day_login_user=#{day_login_user},total_user=#{total_user}, add_day_user=#{add_day_user},total_exp_user=#{total_exp_user},day_exp_user=#{day_exp_user},add_exp_user=#{add_exp_user},total_day_money=#{total_day_money},erpu=#{erpu} where date='#{date}'"

p "更新sql => #{sql}"
link.query(sql)














