ListViewPlugin = {}

--this function will add table list_cache to the scene
--must set list_cache = nil in scene onExit
function ListViewPlugin.create_list_view(list_data, cell_func_create, cell_func_init, cell_size, view_size, cell_touch_func)
	runningscene().list_cache = runningscene().list_cache or {}
	if not list_data or #list_data == 0 then return end
	-- local h = LuaEventHandler:create(function(fn, table, a1, a2)
	-- 	local r
	-- 	if fn == "cellSize" then
	-- 		r = cell_size
	-- 	elseif fn == "cellAtIndex" then
	-- 		if not a2 then
	-- 			a2 = CCTableViewCell:create()
	-- 			a3 = cell_func_create()
	-- 			print("[create_list_view] a1 =>"..a1)
	-- 			a3[cell_func_init](a3,list_data[a1+1])
	-- 			a3:setTag(a1+1)
	-- 			a2:addChild(a3, 0, 1)
	-- 			_G.table.insert(runningscene().list_cache, a3)--keep this variable or it will be clean up
	-- 		else
	-- 			--local a3 = tolua.cast(a2:getChildByTag(a1+1), "CCLayer")
	-- 			local a3 = a2:getChildren():objectAtIndex(0)
	-- 			a3[cell_func_init](a3, list_data[a1 + 1])
	-- 			a3:setTag(a1+1)
	-- 		end
	-- 		r = a2
	-- 	elseif fn == "numberOfCells" then
	-- 		r = #list_data
	-- 	elseif fn == "cellTouched" then
	-- 		if cell_touch_func then
	-- 			local cell = list_data[a1:getChildren():objectAtIndex(0):getTag()]
	-- 			cell_touch_func(cell)
	-- 		end
	-- 	end
	-- 	return r
	-- end)
	-- local t = LuaTableView:createWithHandler(h, view_size)

	-- for index=#(list_data), 1, -1 do
	-- 	t:updateCellAtIndex(index-1)
	-- end

	-- return t

		local function cellSizeForTable(table,idx)
    	return math.min(cell_size.width, cell_size.height), math.min(cell_size.width, cell_size.height)
		end

		local function numberOfCellsInTableView(table)
			return #list_data
		end
		
		local function tableCellTouched(table,cell)
			if cell_touch_func then
				local cell_data = list_data[cell:getChildren():objectAtIndex(0):getTag()]
				cell_touch_func(cell_data)
			end
		end

		local function tableCellAtIndex(table, idx)
	    local strValue = string.format("%d",idx)
	    local cell = table:dequeueCell()
	    local label = nil
	    if nil == cell then
        cell = CCTableViewCell:new()
				local a3 = cell_func_create()
				print("[create_list_view] a1 =>" .. idx)
				a3[cell_func_init](a3,list_data[idx+1])
				a3:setTag(idx+1)
				--a2:addChild(a3, 0, 1)
				_G.table.insert(runningscene().list_cache, a3)--keep this variable or it will be clean up
				-- local a3 = createRoomItem()
				-- print("[HallSceneUPlugin:refresh_room_tabview] idx: " .. idx, a3)
				-- a3:init_room_info(data.room[idx + 1], idx + 1)
				cell:addChild(a3, 0, 1)
	    else
				local a3 = cell:getChildren():objectAtIndex(0)
				a3[cell_func_init](a3, list_data[idx + 1])
				a3:setTag(idx+1)
			end

	    return cell
		end

    local tableView = CCTableView:create(view_size)
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setPosition(CCPointMake(0,0))
    tableView:setVerticalFillOrder(kCCTableViewFillBottomUp)
    tableView:registerScriptHandler(tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData()

    return tableView
end