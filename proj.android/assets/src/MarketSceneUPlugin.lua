require "MarketItem"
require "YesNoDialog3"
require "BackMessageBoxLayer"
require 'src.PurchasePlugin'
require 'src.LabelButtonTab'
local json = require "cjson"

MarketSceneUPlugin = {}

function MarketSceneUPlugin.bind(theClass)
	LabelButtonTab.bind(theClass)
	function theClass:create_product_list(product_list)
		if product_list == nil then
			return
		end

		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(800,130)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					a3 = createMarketItem()
					print("[MarketSceneUPlugin.create_product_list] a1 =>"..a1)
					a3:init_item(product_list[a1+1], __bind(self.show_buy_notify, self))
					a2:addChild(a3, 0, 1)
				else
					local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
					a3:init_item(product_list[a1 + 1],  __bind(self.show_buy_notify, self))
				end
				r = a2
			elseif fn == "numberOfCells" then
				r = #product_list
			elseif fn == "cellTouched" then
			end
			return r
		end)
		local t = LuaTableView:createWithHandler(h, CCSizeMake(800,370))
		t:setPosition(CCPointMake(0,10))
		
		for index=#(product_list), 1, -1 do
			t:updateCellAtIndex(index-1)
		end
		
		return t
	end
	
	function theClass:show_buy_notify(product)
		PurchasePlugin.show_buy_notify(product)
	end
	
	function theClass:do_on_trigger_success(data)
		print("[MarketSceneUPlugin:do_on_trigger_success]")
		self:hide_progress_message_box()
		print("[MarketSceneUPlugin:do_on_trigger_success] after_trigger_success=> "..type(self.after_trigger_success))
		if "function" == type(self.after_trigger_success) then
			local fn = self.after_trigger_success
			self.after_trigger_success = nil
			fn(data)
		end
	end
	
	function theClass:do_on_trigger_failure(data)
		print("[MarketSceneUPlugin:do_on_trigger_failure]")
		self:hide_progress_message_box()
		if not is_blank(data.result_message) then
			self.failure_msg = data.result_message
		end 
		self:show_message_box(self.failure_msg)
		if "function" == type(self.after_trigger_failure) then
			local fn = self.after_trigger_failure
			self.after_trigger_failure = nil
			fn(data)
		end
	end
	
	function theClass:on_close_click()
		print("[FullMubanStyleLayer] call inactive_market_scene_fn")
		self.inactive_market_scene_fn()
		CCDirector:sharedDirector():popScene()
	end
	
	function theClass:get_prop_list(type)
		self:show_progress_message_box(strings.msp_get_props_w)
		self:shop_prop_list(type)
		self.after_trigger_success = __bind(self.on_get_tab, self)
	end

	function theClass:init_tabs()
		local tabs = {}
		tabs["1"] = {name="1"}
		tabs["2"] = {name="2"}
		tabs["3"] = {name="3"}
		local order = {"1","2","3"}
		local tab_content = self.content_layer
		local hanzi_names = {}
		for index = 1,3 do
			hanzi_names[tostring(index)] = self.tabnames_hanzi[index]
		end
		dump(hanzi_names, 'hanzi_names')
		self:setTabHanziNames(hanzi_names)
		self:init_mtabs(tabs, tab_content, order)
	end

	function theClass:getTabView(name, call_back)
		self:show_progress_message_box(strings.msp_get_props_w)
		self:shop_prop_list(name)
		
		self.after_trigger_success = function(data)
			local tab_view = self:create_product_list(data.commodity)
			call_back(tab_view)
		end
	end
	
	function theClass:on_get_tab(data)
		cclog("on get tab data")
		dump(data, "data=>")
		self:set_tab_view(name, self:create_product_list(data.commodity))
		self:set_tab(data.type)
	end
end