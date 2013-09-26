require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.PlayerProductsUIPlugin"
require "PlayerProductItem"
local json = require "cjson"

PlayerProductsScene = class("PlayerProductsScene", function()
	print("new Player Products Scene")
	return display.newScene("PlayerProductsScene")	
end
)

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

	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		print("[MarketSceneUPlugin.create_product_list] fn =>"..fn)
		if fn == "cellSize" then
			r = CCSizeMake(800,80)
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createPlayerProductItem()
				print("[MarketSceneUPlugin.create_product_list] a1 =>"..a1)
				a3:init_item(self.product_list[a1+1], __bind(self.show_use_notify, self))
				a2:addChild(a3, 0, 1)
			else
				local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
				if a3 then
					a3:init_item(self.product_list[a1 + 1],  __bind(self.show_use_notify, self))
				end
				
			end
			r = a2
		elseif fn == "numberOfCells" then
			r = #self.product_list
		end
		return r
	end)
	
	local t = LuaTableView:createWithHandler(h, CCSizeMake(800,300))
	t:setPosition(CCPointMake(0,70))
	
	for index=#(self.product_list), 1, -1 do
		t:updateCellAtIndex(index-1)
	end
	
	return t
end

PlayerProductsUIPlugin.bind(PlayerProductsScene)
UIControllerPlugin.bind(PlayerProductsScene)
HallServerConnectionPlugin.bind(PlayerProductsScene)