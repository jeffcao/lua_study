ListViewPlugin = {}

--this function will add table list_cache to the scene
--must set list_cache = nil in scene onExit
function ListViewPlugin.create_list_view(list_data, cell_func_create, cell_func_init, cell_size, view_size, cell_touch_func)
	runningscene().list_cache = runningscene().list_cache or {}
	if not list_data or #list_data == 0 then return end
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = cell_size
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = cell_func_create()
				print("[create_list_view] a1 =>"..a1)
				a3[cell_func_init](a3,list_data[a1+1])
				a3:setTag(a1+1)
				a2:addChild(a3, 0, 1)
				_G.table.insert(runningscene().list_cache, a3)--keep this variable or it will be clean up
			else
				local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
				a3[cell_func_init](a3, list_data[a1 + 1])
				a3:setTag(a1+1)
			end
			r = a2
		elseif fn == "numberOfCells" then
			r = #list_data
		elseif fn == "cellTouched" then
			if cell_touch_func then
				local cell = list_data[a1:getChildren():objectAtIndex(0):getTag()]
				cell_touch_func(cell)
			end
		end
		return r
	end)
	local t = LuaTableView:createWithHandler(h, view_size)

	for index=#(list_data), 1, -1 do
		t:updateCellAtIndex(index-1)
	end

	return t
end