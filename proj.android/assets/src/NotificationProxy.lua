NotificationProxy = {}

function NotificationProxy.registerScriptObserver(fn, event)
	if not NotificationProxy[event] then NotificationProxy[event] = {} end
	local event_table = NotificationProxy[event]
	for _, fuc in pairs(event_table) do
		if fuc == fn then
			cclog("function had been registed before, return")
			return
		end
	end
	table.insert(event_table, fn)
end
function NotificationProxy.removeAllObserver(event)
	NotificationProxy[event] = nil
end
function NotificationProxy.unregisterScriptObserver(fn, event)
	if not NotificationProxy[event] then 
 		cclog("event %s table is not exist, return", event)
 	end
	local event_table = NotificationProxy[event]
	local pos = -1
	for index, fuc in pairs(event_table) do
		if fuc == fn then
			cclog("function found")
			pos = index
			break
		end
	end
	if pos ~= -1 then
		table.remove(event_table, pos)
	end
end

function NotificationProxy.on_event(event)
	cclog("NotificationProxy on_event=> %s", event)
	local event_table = NotificationProxy[event]
	if not event_table then 
		cclog("no observer on event %s", event)
		return
	end
	for _, fn in pairs(event_table) do
		fn()
	end
end