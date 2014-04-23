DataProxy = class('DataProxy')

DataProxy.instances = {}
DataProxy.get_exist_instance = function(name)
	if name == nil then return nil end
	return DataProxy.instances[name]
end

function DataProxy:ctor(name, key, source_table)
	self.source_table = source_table or {}
	self.key = key or (name .. '_key')
	self.listeners = {}
end

function DataProxy:get_data()
	return self.source_table[self.key]
end

-- name: the name of data, must not be nil and must be unique
-- source_table: the table save this data, if nil will use a new empty table to save this table
-- key: the key to insert this value into table, if nil will use name .. '_key' to insert
function createDataProxy(name, key, source_table)
	local proxy = DataProxy.new(name, key, source_table)
	DataProxy.instances[name] = proxy
	return proxy
end

function DataProxy:set_data(data)
	self.source_table[self.key] = data
	for _,v in pairs(self.listeners) do
		v('set')
	end
end

function DataProxy:update_data(data)
	local function tableCopy(table1, table2)
		if table1 == nil or table2 == nil then return end
		for k,v in pairs(table2) do
			table1[k] = v
		end
	end
	tableCopy(self.source_table[self.key], data)
	for _,v in pairs(self.listeners) do
		v('update')
	end
end

function DataProxy:register(name, func)
	if name == nil or func == nil then return false end
	self.listeners[name] = func
	return true
end

function DataProxy:unregister(name)
	if name == nil or self.listeners[name] == nil then return false end
	self.listeners[name] = nil
	return true
end