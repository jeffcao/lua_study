
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

function table.copy_kv(dest, src)
	for k,v in pairs(src) do
		dest[k] = v
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