Stats = {}
local user_default = CCUserDefault:sharedUserDefault()
local cjson = require "cjson"
local jni = DDZJniHelper:create()

local function check_lasat_app_total()
	local last = user_default:getStringForKey("last_app_duration")
	if is_blank(last) then 
		print('last app_total info is empty')
		return 
	end
	user_default:setStringForKey("last_app_duration","")
	
	local stats = user_default:getStringForKey("stats")
	local name = 'app_total'
	if is_blank(stats) then stats = "{}" end
	stats = cjson.decode(stats)
	stats[name] = stats[name] or ""
	stats[name] = stats[name] .. "-"..tostring(last)
	dump(stats, 'stats after add last app total')
	local str = cjson.encode(stats)
	user_default:setStringForKey("stats", str)
	user_default:flush()
end
check_lasat_app_total()

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
	print("socket is ", socket)
	print("is socket nil? ", (not socket))
	local stats = user_default:getStringForKey("stats")
	if is_blank(stats) or stats == "-" then return end
	stats = cjson.decode(stats)
	local event_data = stats--{user_id = GlobalSetting.current_user.user_id, data = stats}
	socket:trigger("ui.ui_visit_count", event_data, function(data) 
		print("========ui.ui_visit_count return success: " , data)
		--self:onServerRank(data)
	end, function(data) 
		print("----------------ui.ui_visit_count return failure: " , data)
	end)
	user_default:setStringForKey("stats", nil)
end