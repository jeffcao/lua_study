require 'src.GlobalFunction'
require 'src.UmengConstants'
AppStats = {}

function AppStats.sceneName(name)
	return name or runningscene().name
end

function AppStats.table2dic(tbl)
	local dic = CCDictionary:create()
	for k,v in pairs(tbl) do
		dic:setObject(CCString:create(v), k)
	end
	return dic
end

function AppStats.endToLua()
	MobClickCpp:endToLua()
end

function AppStats.beginScene(name)
	name = AppStats.sceneName(name)
	print('AppStats: beginScene ' .. name)
	MobClickCpp:beginScene(name)
	--MobClickCpp:beginScene(AppStats.sceneName(name))
end

function AppStats.endScene(name)
	name = AppStats.sceneName(name)
	print('AppStats: endScene ' .. name)
	MobClickCpp:endScene(name)
	--MobClickCpp:endScene(AppStats.sceneName(name))
end

function AppStats.payCoin(cash, source, coin)
	MobClickCpp:pay(cash, source, coin)
end

function AppStats.payItem(cash, source, item, amount, price)
	MobClickCpp:pay(cash, source, item, amount, price)
end

function AppStats.buyOne(item, price)
	AppStats.buy(item, 1, price)
end

function AppStats.buy(item, amount, price)
	MobClickCpp:buy(item, amount, price)
end

function AppStats.useOne(item, price)
	AppStats.use(item, 1, price)
end

function AppStats.use(item, amount, price)
	MobClickCpp:use(item, amount, price)
end

function AppStats.beginEventWithLabel(eventId, label)
	MobClickCpp:beginEventWithLabel(eventId, label)
end

function AppStats.endEventWithLabel(eventId, label)
	MobClickCpp:endEventWithLabel(eventId, label)
end

function AppStats.beginEventWithAttributes(eventId, primaryKey, attributes)
	local dic = AppStats.table2dic(attributes)
	MobClickCpp:beginEventWithAttributes(eventId, primaryKey, dic)
end

function AppStats.endEventWithAttributes(eventId, primaryKey)
	MobClickCpp:endEventWithAttributes(eventId, primaryKey)
end

function AppStats.beginEvent(eventId)
	MobClickCpp:beginEvent(eventId)
end

function AppStats.endEvent(eventId)
	MobClickCpp:endEvent(eventId)
end

function AppStats.event(eventId, labelOrAttributes, counter)
	if labelOrAttributes == nil then
		MobClickCpp:event(eventId)
		return
	end
	if type(labelOrAttributes) == 'string' then
		MobClickCpp:event(eventId, labelOrAttributes)
		return
	end
	if type(labelOrAttributes) == 'table' then
		local dic = AppStats.table2dic(labelOrAttributes)
		MobClickCpp:event(eventId, dic, counter or 0)
		return
	end
end