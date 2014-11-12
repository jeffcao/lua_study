require "redis"
require "json"
require "mongo"

Redis.current.del("test_key")

start_time = Time.now

test_counts = 10000

test_counts.times do |i|
  #Redis.current.set("key_#{i}", i)
  Redis.current.lpush("test_key", ({:key => i}.to_json) )
end

end_time = Time.now

puts "[redis] create #{test_counts} simple key-value eliminates #{end_time - start_time}"

start_time = Time.now

#100000.times do |i|
#  Redis.current.get("key_#{i}")
#end
Redis.current.lrange("test_key", 0, -1).each {|o| JSON.parse(o)}

end_time = Time.now

puts "[redis] get #{test_counts} simple key-value eliminates #{end_time - start_time}"

client = Mongo::MongoClient.new
db = client.db("test")

db.drop_collection("test")
coll = db.collection("test")

coll.ensure_index(:key => Mongo::ASCENDING)

data = {:key => 1}
20.times do |i|
  data["#value_#{i}"] = i
end

start_time = Time.now

test_counts.times do |i|
  data.delete(:_id)
  data[:key] = i
  #p data
  coll.insert(data)
  #coll.update({:key => i}, {:key => i,  :value => "valuex_#{i}"})
end

end_time = Time.now

puts "[mongo] create #{test_counts} simple key-value eliminates #{end_time - start_time}"


start_time = Time.now

test_counts.times do |i|
  #coll.insert({:key => i,  :value => "value_#{i}" })
  coll.update({:key => i}, {:key => i,  :value => "valuex_#{i}"})
end

end_time = Time.now

puts "[mongo] update #{test_counts} simple key-value eliminates #{end_time - start_time}"

start_time = Time.now
aa = []
coll.find().each do |o|
  aa << o
end

end_time = Time.now

puts "[mongo] get #{test_counts} simple key-value eliminates #{end_time - start_time}"

start_time = Time.now

aa.each do |obj|
  #coll.insert({:key => i,  :value => "value_#{i}" })
  obj["value"] = obj["value"] + "_a"
  coll.save(obj)
  #coll.update({:key => i}, {:key => i,  :value => "valuex_#{i}"})
end

end_time = Time.now

puts "[mongo] update #{test_counts} by obj_id eliminates #{end_time - start_time}"


start_time = Time.now
aa = []
coll.find().each do |o|
  aa << o
end

end_time = Time.now

puts "[mongo] get #{test_counts} simple key-value eliminates #{end_time - start_time}"


#client.close

#sleep(5)

#puts aa
