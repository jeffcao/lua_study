
function scaleNode(node, scaleFactor)
	local node = tolua.cast(node, "CCNode")
	if node:getTag() >= 1000 then
		node:setScale(scaleFactor)
	end
	
	if node:getChildrenCount() > 0 then
		local children = node:getChildren()
		for index = 0, children:count()-1 do
			local child = children:objectAtIndex(index)
			scaleNode(child, scaleFactor)
		end
	end
	
end

function endtolua_guifan()
	local scene = createGuifanEndScene()
	CCDirector:sharedDirector():pushScene(scene)
end

function endtolua()
	--local jni_helper = DDZJniHelper:create()
	--jni_helper:messageJava("RecoveryMusicVolume")
	CCDirector:sharedDirector():endToLua()
end

function table.filter(src, fn)
	local result = {}
	for _,v in pairs(src) do
		if fn(v) then
			table.insert(result, v)
		end
	end
	return result
end

function table.combine(dest, src)
	for _, value in pairs(src) do
		table.insert(dest, value)
	end
end

function clone_table(array)
	local result = {}
	table.merge(result, array)
	return result
end

function table.join(table, s)
	s = tostring(s)
	local str = ""
	for _, _v in pairs(table) do
		if str == "" then 
			str = str .. tostring(_v)
		else 
			str = str .. s .. tostring(_v)
		end
	end
	return str
end

function table.toString(table)
	local str = "[ "
	for _, _v in pairs(table) do
		str = str .. tostring(_v) .. ",  "
	end
	str = str .. "]"
	return str
end

function table.reverse(array)
	local result = {}
	for index = -#array, -1 do
		table.insert(result, array[-index])
	end
	return result
end

function table.some(array, func)
	local result = false
	for _, obj in pairs(array) do
		if func(obj) then
			result = true
			break
		end
	end
	return result
end

function table.unique(array, getObjectValueFuc)
	local newArray = {}
	for elementIndex,_ in pairs(array) do
		local elementValue = getObjectValueFuc(array[elementIndex])
		local search = function(obj) return (getObjectValueFuc(obj) == elementValue) end
		local exist = table.some(newArray, search)
		if not exist then
			table.insert(newArray, array[elementIndex])
		end
	end
	return newArray
end

function is_blank(str)
	return str == nil or string.len(string.trim(str)) == 0
end

function trim_blank(s)
 	local from = s:match"^%s*()"
 	return from > #s and "" or s:match(".*%S", from)
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   
   return t
end

function trim(str, char)
	local return_value = str
	local char_index = string.find(str, char)
	if char_index == 1 then
		return_value = str:sub(2)	
	end
	
	char_index = string.find(return_value, char, -1)
	if char_index == #return_value then
		return_value = return_value:sub(1, #return_value-1)	
	end
	return return_value
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function isnan(x) 
    if (x ~= x) then
        --print(string.format("NaN: %s ~= %s", x, x));
        return true; --only NaNs will have the property of not being equal to themselves
    end;

    --but not all NaN's will have the property of not being equal to themselves

    --only a number can not be a number
    if type(x) ~= "number" then
       return false; 
    end;

    --fails in cultures other than en-US, and sometimes fails in enUS depending on the compiler
--  if tostring(x) == "-1.#IND" then

    --Slower, but works around the three above bugs in LUA
    if tostring(x) == tostring((-1)^0.5) then
        --print("NaN: x = sqrt(-1)");
        return true; 
    end;

    --i really can't help you anymore. 
    --You're just going to have to live with the exception

    return false;
end

function device_info()
	local userDefault = CCUserDefault:sharedUserDefault()
	local device_info = {
		imei = userDefault:getStringForKey("hw_imei"),
		mac = userDefault:getStringForKey("hw_mac"),
		imsi = userDefault:getStringForKey("hw_imsi"),
		brand = userDefault:getStringForKey("hw_brand"),
		model = userDefault:getStringForKey("hw_model"),
		version = userDefault:getStringForKey("hw_version"),
		manufacture = userDefault:getStringForKey("hw_manufacture"),
		cpu_abi = userDefault:getStringForKey("hw_cpu_abi"),
		board = userDefault:getStringForKey("hw_board"),
		device = userDefault:getStringForKey("hw_device"),
		product = userDefault:getStringForKey("hw_product"),
		display = userDefault:getStringForKey("hw_display"),
		id = userDefault:getStringForKey("hw_id"),
		fingerprint = userDefault:getStringForKey("hw_fingerprint")
	}
	return device_info
end