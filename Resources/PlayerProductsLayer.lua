require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.PlayerProductsUIPlugin"
require "PlayerProductItem"
local json = require "cjson"

PlayerProductsLayer = class("PlayerProductsLayer", function()
	print("new InfoLayer")
	return display.newLayer("PlayerProductsLayer")
end
)

function createPlayerProductsLayer(msg_box_container)
	print("create PlayerProductsLayer")
	return PlayerProductsLayer.new(msg_box_container)
end

function PlayerProductsLayer:ctor(msg_box_container)
	self.rootNode = self
	self:init_product_list()
end

function PlayerProductsLayer:setContent(layer)
	self.rootNode:addChild(layer)
end

function PlayerProductsLayer:create_product_list()
	print("[PlayerProductsLayer:create_product_list]")
	if self.product_list == nil or self.product_list == json.null then
		self:show_prop_is_empty()
		return
	end
	
	-- local h = LuaEventHandler:create(function(fn, table, a1, a2)
	-- 	local r
	-- 	if fn == "cellSize" then
	-- 		r = CCSizeMake(512,140)
	-- 	elseif fn == "cellAtIndex" then
	-- 		if not a2 then
	-- 			a2 = CCTableViewCell:create()
	-- 			a3 = createPlayerProductItem()
	-- 			print("[PlayerProductsLayer.create_product_list] a1 =>"..a1)
	-- 			a3:init_item(self.product_list[a1+1], __bind(self.show_use_notify, self), true)
	-- 			a2:addChild(a3, 0, 1)
	-- 		else
	-- 			local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
	-- 			if a3 then
	-- 				a3:init_item(self.product_list[a1 + 1],  __bind(self.show_use_notify, self), true)
	-- 			end
				
	-- 		end
	-- 		r = a2
	-- 	elseif fn == "numberOfCells" then
	-- 		r = #self.product_list
	-- 	elseif fn == "cellTouched" then
	-- 	end
	-- 	return r
	-- end)
	-- local t = LuaTableView:createWithHandler(h, CCSizeMake(700,380))
	-- t:setAnchorPoint(ccp(0.5,0.5))
	-- t:setPosition(CCPointMake(3,45))
	
	-- for index=#(self.product_list), 1, -1 do
	-- 	t:updateCellAtIndex(index-1)
	-- end
	
	-- return t

	local function cellSizeForTable(table,idx)
  	return 140, 100
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
			print("[PlayerProductsLayer.create_product_list] a1 =>"..idx)
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

  local tableView = CCTableView:create(CCSizeMake(700,260))
	tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPosition(CCPointMake(3,60))
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



PlayerProductsUIPlugin.bind(PlayerProductsLayer)
UIControllerPlugin.bind(PlayerProductsLayer)
HallServerConnectionPlugin.bind(PlayerProductsLayer)

