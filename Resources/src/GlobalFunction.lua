
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
   return table.reverse(t)
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