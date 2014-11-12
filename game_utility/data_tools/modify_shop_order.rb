#encoding: utf-8

require "rubygems"
require "roo"
require "mysql2"
require 'yaml'
data = YAML.load(File.open("../../config/doudizhu/config/database.yml"))
localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")

sql = "select id, price from game_products where product_type=1 order by price+0 asc"

props = link.query(sql)
order = 1
props.each do |prop|
  id = prop["id"]
  price = prop["price"]
  p "id: #{id}, price: #{price}, order: #{order}"
  sql = "update game_products set product_sort=#{order} where id=#{id}"
  link.query(sql)
  order = order + 1
end

sql = "select id, price from game_products where product_type=2 order by price+0 desc"

props = link.query(sql)
order = 1
props.each do |prop|
  id = prop["id"]
  price = prop["price"]
  p "id: #{id}, price: #{price}, order: #{order}"
  sql = "update game_products set product_sort=#{order} where id=#{id}"
  link.query(sql)
  order = order + 1
end