Stats = {}
local user_default = CCUserDefault:sharedUserDefault()
local cjson = require "cjson"
local jni = DDZJniHelper:create()

function Stats:on_start(name)
	local c_time = tonumber(jni:get("CurrentTime"))
	if c_time < 1000000000000 then
		c_time = c_time * 10
	end
	Stats[name.."_s"] = c_time
end

function Stats:on_end(name)
	dump(Stats, "Stats=>")
	local start = Stats[name.."_s"]
	if not start then
		cclog("there is no on_start when on_end")
		return
	end
	local stats = user_default:getStringForKey("stats")
	print("stats is ", stats)
	print("stats is blank?", (is_blank(stats)))
	if is_blank(stats) then stats = "{}" end
	--stats = stats or "{}"
	stats = cjson.decode(stats)
	local c_time = tonumber(jni:get("CurrentTime"))
	if c_time < 1000000000000 then
		c_time = c_time * 10
	end
	local s_time = tonumber(start)
	stats[name] = stats[name] or ""
	stats[name] = stats[name] .. "-"..tostring(c_time-s_time)
	local str = cjson.encode(stats)
	user_default:setStringForKey("stats", str)
	user_default:flush()
	print("new stats is " .. str)
	Stats[name.."_s"] = nil
end

function Stats:flush(socket)
	local stats = user_default:getStringForKey("stats")
	local event_data = {user_id = GlobalSetting.current_user.user_id, data = stats}
	socket:trigger("g.user_score_list", event_data, function(data) 
		print("========g.user_score_list return succss: " , data)
		--self:onServerRank(data)
		user_default:setStringForKey("stats", nil)
	end, function(data) 
		print("----------------g.user_score_list return failure: " , data)
	end)
end