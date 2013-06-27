require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

PlayerProductsLayer = class("PlayerProductsLayer", function()
	print("new InfoLayer")
	return display.newLayer("PlayerProductsLayer")
end
)

function PlayerProductsLayer()
	print("create PlayerProductsLayer")
	return PlayerProductsLayer.new()
end

function PlayerProductsLayer:ctor()

	self:init_product_list()
end

function PlayerProductsLayer:create_product_list(product_list)
	print("[PlayerProductsScene:create_product_list]")
	if product_list == nil then
		return
	end

	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = CCSizeMake(800,73)
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createPlayerProductItem()
				print("[MarketSceneUPlugin.create_product_list] a1 =>"..a1)
				a3:init_item(product_list[a1+1], __bind(self.show_use_notify, self))
				a2:addChild(a3, 0, 1)
			else
				local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
				a3:init_item(product_list[a1 + 1],  __bind(self.show_use_notify, self))
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

function PlayerProductsLayer:show_product_list(data)
	print("[PlayerProductsLayer:show_product_list]")
	local product_view = self:create_product_list(data)
	self.rootNode:setContent(product_view)
end


function PlayerProductsLayer:init_product_list()
	print("[PlayerProductsLayer:do_on_trigger_success]")
	
	self:show_progress_message_box("获取道具列表")
	self:cate_list()
	self.after_trigger_success = __bind(self.show_product_list, self)
	
end

function PlayerProductsLayer:show_use_notify()
	print("[PlayerProductsLayer:do_on_trigger_success]")
end


function PlayerProductsLayer:do_on_trigger_success(data)
	print("[PlayerProductsLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	print("[PlayerProductsLayer:do_on_trigger_success] after_trigger_success=> "..type(self.after_trigger_success))
	if "function" == type(self.after_trigger_success) then
		self.after_trigger_success(data)
		self.after_trigger_success = nil
	end
	
end

function PlayerProductsLayer:do_on_trigger_failure(data)
	print("[PlayerProductsLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)
	if "function" == type(self.after_trigger_failure) then
		self.after_trigger_failure(data)
		self.after_trigger_failure = nil
	end
end

UIControllerPlugin.bind(PlayerProductsLayer)
HallServerConnectionPlugin.bind(PlayerProductsLayer)

