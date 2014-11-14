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

		
		local function cellSizeForTable(table,idx)
    	return 80, 80
		end

		local function numberOfCellsInTableView(table)
			return #product_list
		end
		
		local function tableCellTouched(table,cell)
		end

		local function tableCellAtIndex(table, idx)
	    local strValue = string.format("%d",idx)
	    local cell = table:dequeueCell()
	    local label = nil
	    if nil == cell then
        cell = CCTableViewCell:new()
				local a3 = createMarketItem()
				--a3:setContentSize(CCSizeMake(800,130))
				print("[MarketSceneUPlugin.create_product_list] idx: " .. idx, a3)
				a3:init_item(product_list[idx+1], __bind(self.show_buy_notify, self))
				--local layer = CCLayerColor:create(ccc4(255, 255 * (idx % 2), 0, 255), 800, 130)
				cell:addChild(a3, 0, 1)
	    else
				local a3 = tolua.cast(cell:getChildByTag(1), "CCLayer")
				a3:init_item(product_list[idx + 1],  __bind(self.show_buy_notify, self))
			end

	    return cell
		end

    local tableView = CCTableView:create(CCSizeMake(800,260))
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setPosition(CCPointMake(0,0))
    tableView:setVerticalFillOrder(kCCTableViewFillBottomUp)

    tableView:registerScriptHandler(tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData()
		-- for index=#(product_list), 1, -1 do
		-- 	t:updateCellAtIndex(index-1)
		-- end

		return tableView
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
	
	--[[
	function theClass:get_prop_list(type)
		self:show_progress_message_box(strings.msp_get_props_w)
		self:shop_prop_list(type)
		self.after_trigger_success = __bind(self.on_get_tab, self)
	end
	]]
	function theClass:init_tabs()
		local tabs = {}
		tabs["1"] = {name="1"}
		tabs["2"] = {name="2"}
		tabs["3"] = {name="3"}

		local tabs_frams = {}
		tabs_frams["1"] = {"shangchen-1/sc-xiaotu/sc-douzi.png", "shangchen-1/sc-xiaotu/sc-douzi.png"} 
		tabs_frams["2"] = {"shangchen-1/sc-xiaotu/sc-libao.png", "shangchen-1/sc-xiaotu/sc-libao.png"} 
		tabs_frams["3"] = {"shangchen-1/sc-xiaotu/sc-fuwu.png", "shangchen-1/sc-xiaotu/sc-fuwu.png"} 
		local order = {"1","2","3"}
		local tab_content = self.content_layer
		local hanzi_names = {}
		for index = 1,3 do
			hanzi_names[tostring(index)] = self.tabnames_hanzi[index]
		end
		dump(hanzi_names, 'hanzi_names')
		self:setTabHanziNames(hanzi_names)
		self:init_mtabs(tabs, tab_content, order, tabs_frams)
	end
	
	function theClass:tabplugin_on_set_tab(name)
		local name_hanzi = self.tabnames_hanzi[tonumber(name)]
		local event_name = UM_SHOP_BEANS
		if name_hanzi == "礼  包" then
			event_name = UM_SHOP_GIFTS
		elseif name_hanzi == "服  务" then
			event_name = UM_SHOP_SERVICES
		end
		AppStats.event(event_name)
	end

	function theClass:getTabView(name, call_back)
--		dump(GlobalSetting.shop_prop_data, 'MatketScene.getTabView, GlobalSetting.shop_prop_data=>')
		if not GlobalSetting.shop_prop_data[name] then
			self:show_progress_message_box(strings.msp_get_props_w)
			self:shop_prop_list(name)
			self.after_trigger_success = function(data)
				local tab_view = self:create_product_list(data.commodity)
				GlobalSetting.shop_prop_data[name] = data.commodity
				call_back(tab_view)
			end
		else
			local tab_view = self:create_product_list(GlobalSetting.shop_prop_data[name])
			call_back(tab_view)
		end
	end
	--[[
	function theClass:on_get_tab(data)
		cclog("on get tab data")
		dump(data, "data=>")
		self:set_tab_view(name, self:create_product_list(data.commodity))
		self:set_tab(data.type)
	end
	]]
end