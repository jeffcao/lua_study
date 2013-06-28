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
	layer:setTitle("biaoti03.png")
	
	self:init_product_list()
	
end

function PlayerProductsScene:create_product_list(product_list)
	print("[PlayerProductsScene:create_product_list]")
	if product_list == nil or product_list == json.null then
		return
	end
	
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = CCSizeMake(800,80)
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createPlayerProductItem()
				print("[MarketSceneUPlugin.create_product_list] a1 =>"..a1)
				a3:init_item(product_list[a1+1], __bind(self.show_use_notify, self))
				a2:addChild(a3, 0, 1)
			else
				local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
				if a3 then
					a3:init_item(product_list[a1 + 1],  __bind(self.show_use_notify, self))
				end
				
			end
			r = a2
		elseif fn == "numberOfCells" then
			r = #product_list
		elseif fn == "cellTouched" then
		end
		return r
	end)
	local t = LuaTableView:createWithHandler(h, CCSizeMake(800,300))
	t:setPosition(CCPointMake(0,70))
	
	for index=#(product_list), 1, -1 do
		t:updateCellAtIndex(index-1)
	end
	
	return t
end

--function PlayerProductsScene:show_product_list(data)
--	print("[PlayerProductsScene:show_product_list]")
--	if self.product_view then
--		self.rootNode:removeChild(self.product_view, true)
--	end
--	self.product_view = self:create_product_list(data.cats)
--	if self.product_view then
--		self.rootNode:setContent(self.product_view)
--	end
--end
--
--
--function PlayerProductsScene:init_product_list()
--	print("[PlayerProductsScene:init_product_list]")
--	
--	self:show_progress_message_box("获取道具列表...")
--	self.after_trigger_success = __bind(self.show_product_list, self)
--	self:cate_list()
--	
--	
--end
--
--function PlayerProductsScene:after_use_product(data)
--	print("[PlayerProductsScene:after_use_product]")
--	if tostring(data.prop.prop_count) ~= "0" then
--		self.use_prop_callback(data.prop.prop_count)
--	else
--		self:init_product_list()
--	end
--	
--end
--
--function PlayerProductsScene:show_use_notify(product, use_prop_callback)
--	print("[PlayerProductsScene:do_on_trigger_success]")
--	self.use_prop_callback = use_prop_callback
--	self:show_progress_message_box("发送道具使用请求...")
--	self:use_cate(product.prop_id)
--	self.after_trigger_success = __bind(self.after_use_product, self)
--end
--
--
--function PlayerProductsScene:do_on_trigger_success(data)
--	print("[PlayerProductsScene:do_on_trigger_success]")
--	self:hide_progress_message_box()
--	print("[PlayerProductsScene:do_on_trigger_success] after_trigger_success=> "..type(self.after_trigger_success))
--	if "function" == type(self.after_trigger_success) then
--		local fn = self.after_trigger_success
--		self.after_trigger_success = nil
--		fn(data)
--		
--	end
--	
--end
--
--function PlayerProductsScene:do_on_trigger_failure(data)
--	print("[MarketSceneUPlugin:do_on_trigger_failure]")
--	self:hide_progress_message_box()
--	self:show_message_box(self.failure_msg)
--	if "function" == type(self.after_trigger_failure) then
--		self.after_trigger_failure(data)
--		self.after_trigger_failure = nil
--	end
--end
PlayerProductsUIPlugin.bind(PlayerProductsScene)
UIControllerPlugin.bind(PlayerProductsScene)
HallServerConnectionPlugin.bind(PlayerProductsScene)