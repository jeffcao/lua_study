require "MarketItem"
MarketSceneUPlugin = {}

function MarketSceneUPlugin.bind(theClass)

	function theClass:createListView()
		local data = {}
		for i = 1, 10 do
		table.insert(data, "Data 3"..i) end
	--
		
	-- @param fn string Callback type
	-- @param table LuaTableView
	-- @param a1 & a2 mixed Difference means for every "fn"
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
			print("lua event handler")
		local r
		print("lua event handler1")
		if fn == "cellSize" then
			-- Return cell size
			r = CCSizeMake(800,73)
			print("lua event handler2")
		elseif fn == "cellAtIndex" then
			-- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
			-- Do something to create cell and change the content
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createMarketItem()
				a2:addChild(a3, 0, 1)
				print("lua event handler3")
			end
			-- Change content
			--tolua.cast(a2:getChildByTag(1), "CCLabelTTF"):setString(data[a1 + 1])
			r = a2
			print("lua event handler4")
		elseif fn == "numberOfCells" then
			-- Return number of cells
			r = #data
			print("lua event handler5")
		elseif fn == "cellTouched" then
			-- A cell was touched, a1 is cell that be touched. This is not necessary.
			print("lua event handler6")
		end
		print("lua event handler7")
		return r
	end)
	local t = LuaTableView:createWithHandler(h, CCSizeMake(800,300))
	--t:setDirection(kCCScrollViewDirectionVertical)
	--t:reloadData()
	t:setPosition(CCPointMake(0,70))
	
	return t
	end
end