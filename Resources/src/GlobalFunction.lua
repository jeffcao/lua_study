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

function is_blank(str)
	return str == nil or string.len(string.trim(str)) == 0
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