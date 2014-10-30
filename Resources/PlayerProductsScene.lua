require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.PlayerProductsUIPlugin"
require "PlayerProductItem"
require "src.Stats"
local json = require "cjson"

PlayerProductsScene = class("PlayerProductsScene", function()
	print("new Player Products Scene")
	return display.newScene("PlayerProductsScene")	
end
)

function PlayerProductsScene:onEnter()
	Stats:on_start("player_product")
end

function PlayerProductsScene:onExit()
	Stats:on_end("player_product")
end

function createPlayerProductsScene()
	print("create PlayerProductsScene")
	return PlayerProductsScene.new()
end

function PlayerProductsScene:ctor()
	
	local ccbproxy = CCBProxy:create()
	
	
	local layer = createFullMubanStyleLayer()
	self.rootNode = layer
	self:addChild(layer)
	layer:setTitle("biaoti06.png")
	
	self:init_product_list()
	
end

function PlayerProductsScene:create_product_list()
	print("[PlayerProductsScene:create_product_list]")
	if self.product_list == nil or self.product_list == json.null then
		return
	end

	-- local h = LuaEventHandler:create(function(fn, table, a1, a2)
	-- 	local r
	-- 	print("[MarketSceneUPlugin.create_product_list] fn =>"..fn)
	-- 	if fn == "cellSize" then
	-- 		r = CCSizeMake(800,80)
	-- 	elseif fn == "cellAtIndex" then
	-- 		if not a2 then
	-- 			a2 = CCTableViewCell:create()
	-- 			a3 = createPlayerProductItem()
	-- 			print("[MarketSceneUPlugin.create_product_list] a1 =>"..a1)
	-- 			a3:init_item(self.product_list[a1+1], __bind(self.show_use_notify, self))
	-- 			a2:addChild(a3, 0, 1)
	-- 		else
	-- 			local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
	-- 			if a3 then
	-- 				a3:init_item(self.product_list[a1 + 1],  __bind(self.show_use_notify, self))
	-- 			end
				
	-- 		end
	-- 		r = a2
	-- 	elseif fn == "numberOfCells" then
	-- 		r = #self.product_list
	-- 	end
	-- 	return r
	-- end)
	
	-- local t = LuaTableView:createWithHandler(h, CCSizeMake(800,300))
	-- t:setPosition(CCPointMake(0,70))
	
	-- for index=#(self.product_list), 1, -1 do
	-- 	t:updateCellAtIndex(index-1)
	-- end
	
	-- return t


	local function cellSizeForTable(table,idx)
  	return 80,80
	end

	local function numberOfCellsInTableView(table)
		return #self.product_list
	end
	
	local function tableCellTouched(table,cell)
	end

	local function tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then
      cell = CCTableViewCell:new()
			local a3 = createPlayerProductItem()
			print("[MarketSceneUPlugin.create_product_list] a1 =>"..idx)
			a3:init_item(self.product_list[idx+1], __bind(self.show_use_notify, self), true)
			cell:addChild(a3, 0, 1)
    else
			local a3 = tolua.cast(cell:getChildByTag(1), "CCLayer")
			if a3 then
				a3:init_item(self.product_list[idx + 1],  __bind(self.show_use_notify, self), true)
			end
		end

    return cell
	end

  local tableView = CCTableView:create(CCSizeMake(700,280))
	--tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPosition(CCPointMake(0,70))
  -- tableView:setDirection(kCCScrollViewDirectionHorizontal)
  -- tableView:setPosition(CCPointMake(20, winSize.height / 2 - 150))
  --registerScriptHandler functions must be before the reloadData function
  tableView:registerScriptHandler(tableCellTouched,CCTableView.kTableCellTouched)
  tableView:registerScriptHandler(cellSizeForTable,CCTableView.kTableCellSizeForIndex)
  tableView:registerScriptHandler(tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
  tableView:registerScriptHandler(numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
  tableView:reloadData()

  return tableView

end

PlayerProductsUIPlugin.bind(PlayerProductsScene)
UIControllerPlugin.bind(PlayerProductsScene)
HallServerConnectionPlugin.bind(PlayerProductsScene)
SceneEventPlugin.bind(PlayerProductsScene)