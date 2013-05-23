require "MarketItem"
MarketSceneUPlugin = {}

function MarketSceneUPlugin.bind(theClass)

	function theClass:createListView()
		local data = {}
		for i = 1, 10 do
		table.insert(data, "Data 3"..i) end
	
		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(800,73)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					a3 = createMarketItem()
					a2:addChild(a3, 0, 1)
				end
				r = a2
			elseif fn == "numberOfCells" then
				r = #data
			elseif fn == "cellTouched" then
			end
			return r
		end)
		local t = LuaTableView:createWithHandler(h, CCSizeMake(800,300))
		t:setPosition(CCPointMake(0,70))
		return t
	end
end