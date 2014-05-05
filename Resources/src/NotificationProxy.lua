NotificationProxy = {}
--must notice:
--commonly registerScriptObserver with category of scene.scene_name
--and in scene's onCleanup call NotificationProxy.removeObservers(self.scene_name)

--must remove every observer relative to scene when exit a scene!!!!!
--if forget remove observer when exit scene, it will lead network restore fail and lead to
--error that can not be found easily!!!
function NotificationProxy.registerScriptObserver(fn, event, category)
	if not NotificationProxy[event] then NotificationProxy[event] = {} end
	local event_table = NotificationProxy[event]
	for _, func_d in pairs(event_table) do
		if func_d.fuc == fn then
			cclog("function had been registed before, return")
			return
		end
	end
	local func_data = {}
	func_data._category = category
	func_data.func = fn
	table.insert(event_table, func_data)
end
function NotificationProxy.removeObservers(category)
	for _, value in pairs(NotificationProxy) do
		if type(value) == 'table' then
			for key, func_data in pairs(value) do
				if func_data._category == category then
					value[key] = nil
					dump(func_data, 'NotificationProxy.remove')
				end
			end
		end
	end
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
	for index, fuc_data in pairs(event_table) do
		if fuc_data.func == fn then
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
	local has_observer = false
	for _, func_data in pairs(event_table) do
		dump(func_data, 'NotificationProxy.on_event:'..event)
		func_data.func()
		has_observer = true
	end
	if not has_observer then
		cclog("no observer on event %s", event)
	end
end