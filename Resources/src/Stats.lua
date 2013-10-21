Stats = {}
local user_default = CCUserDefault:sharedUserDefault()
local cjson = require "cjson"
local jni = DDZJniHelper:create()

function Stats:on_start(name)
	local current = user_default:getStringForKey("stats")
	print("current is ", current)
	print("current is blank?", (is_blank(current)))
	--[[
	local c_time = jni:get("CurrentTime")
	current = current or "[]"
	local c_j = cjson.decode(current)
	local c_j_n = c_j[name]
	c_j_n = c_j_n or cjson.decode("[]")
	]]
end

function Stats:on_end(name)
end

function Stats:flush(socket)
end