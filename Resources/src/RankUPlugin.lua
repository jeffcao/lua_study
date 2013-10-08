require "RankItem"

RankUPlugin = {}

function RankUPlugin.bind(theClass)

	function theClass:create_rank_list(rank_list)
		if not rank_list then return end

		local init_a3 = function(rank_item)
			
		end
		
		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(400,30)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
				end
				a2:removeAllChildrenWithCleanup(true)
				local a3 = createRankItem()
				print("[MarketSceneUPlugin.create_rank_list] a1 =>"..a1)
				a3:init(rank_list[a1+1])
				a2:addChild(a3)
				r = a2
			elseif fn == "numberOfCells" then
				r = #rank_list
			elseif fn == "cellTouched" then
			end
			return r
		end)
		local t = LuaTableView:createWithHandler(h, CCSizeMake(400,200))
		for index=#(rank_list), 1, -1 do
			t:updateCellAtIndex(index-1)
		end
		
		return t
	end
	
	function theClass:rank(rank_list)
		table.sort(rank_list, function(a, b) return tonumber(a.rank) > tonumber(b.rank) end)
		local rank = self:create_rank_list(rank_list)
		local menus = CCArray:create()
	--	menus:addObject(self.rootNode)
	--	menus:addObject(self.rank_content)
		menus:addObject(rank)
		self:swallowOnTouch(menus)
		self.rank_content:addChild(rank)
	end

end