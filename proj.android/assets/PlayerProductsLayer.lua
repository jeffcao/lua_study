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

function createPlayerProductsLayer()
	print("create PlayerProductsLayer")
	return PlayerProductsLayer.new()
end

function PlayerProductsLayer:ctor()
	self.rootNode = self
	self:init_product_list()
end

function PlayerProductsLayer:setContent(layer)
	self.rootNode:addChild(layer)
end

function PlayerProductsLayer:create_product_list(product_list)
	print("[PlayerProductsLayer:create_product_list]")
	if product_list == nil or product_list == json.null then
		return
	end
	
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = CCSizeMake(450,80)
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createPlayerProductItem()
				print("[PlayerProductsLayer.create_product_list] a1 =>"..a1)
				a3:init_item(product_list[a1+1], __bind(self.show_use_notify, self), true)
				a2:addChild(a3, 0, 1)
			else
				local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
				if a3 then
					a3:init_item(product_list[a1 + 1],  __bind(self.show_use_notify, self), true)
				end
				
			end
			r = a2
		elseif fn == "numberOfCells" then
			r = #product_list
		elseif fn == "cellTouched" then
		end
		return r
	end)
	local t = LuaTableView:createWithHandler(h, CCSizeMake(550,340))
	t:setPosition(CCPointMake(95,70))
	
	for index=#(product_list), 1, -1 do
		t:updateCellAtIndex(index-1)
	end
	
	return t
end



PlayerProductsUIPlugin.bind(PlayerProductsLayer)
UIControllerPlugin.bind(PlayerProductsLayer)
HallServerConnectionPlugin.bind(PlayerProductsLayer)

