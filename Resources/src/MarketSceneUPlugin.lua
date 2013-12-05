require "MarketItem"
require "YesNoDialog3"
require "BackMessageBoxLayer"

local json = require "cjson"

MarketSceneUPlugin = {}

function MarketSceneUPlugin.bind(theClass)

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
	
	function theClass:is_cm_sim_card()
		print("[MarketSceneUPlugin:is_cm_sim_card]")
		local imsi = CCUserDefault:sharedUserDefault():getStringForKey("hw_imsi")
		print("[MarketSceneUPlugin:show_buy_notify] imsi=> "..imsi)
		local is_cm_sim_card = false
		if not is_blank(GlobalSetting.cm_sim_card_prefix) and not is_blank(imsi) then
			print("[MarketSceneUPlugin:is_cm_sim_card] GlobalSetting.cm_sim_card_prefix=> "..GlobalSetting.cm_sim_card_prefix)
			local cm_sim_card_flags = split(GlobalSetting.cm_sim_card_prefix, ",")
			for k, v in pairs(cm_sim_card_flags) do
				local f_index = string.find(imsi, v)
				if f_index ~= nil and f_index == 1 then
					is_cm_sim_card = true
					break
				end
			end	
		end
		return is_cm_sim_card
	end
	
	function theClass:show_buy_notify(product)
		print("[MarketSceneUPlugin:show_buy_notify]")
		
		if is_blank(product.consume_code) then
			self:show_back_message_box(strings.msp_purchase_no_code_w)
			do return end
		end
		
		is_cm_sim_card = self:is_cm_sim_card()
		print("[MarketSceneUPlugin:show_buy_notify] is_cm_sim_card=> "..tostring(is_cm_sim_card))
		if not is_cm_sim_card and GlobalSetting.run_env ~= "test" then
			self:show_back_message_box(strings.msp_purchase_not_cmcc_w)
			do return end
		end

		self.cur_product = product
		self.yes_no_dialog = createYesNoDialog3(self)
		--content = "尊敬的客户，您即将购买的是\n游戏名：我爱斗地主\n道具名："
	 	--content = content..self.cur_product.name.."\n道具数量：1\n服务提供商：深圳市新中南实业有限公司\n资费说明：\n" 	
	 	--content = content..self.cur_product.price.." 点（即消费"..self.cur_product.rmb.."元人民币）\n点击确认按钮确认购买，中国移动\n客服电话400-6788456"
	 	content = string.gsub(strings.msp_purchase_notify, "name", self.cur_product.name)
	 	content = string.gsub(content, "price", self.cur_product.price)
	 	content = string.gsub(content, "rmb", self.cur_product.rmb)
		print("[MarketSceneUPlugin:show_buy_notify] notify content=> "..content)
		self.yes_no_dialog:setMessage(content)
		self.yes_no_dialog:setMessageSize(19)
		self.yes_no_dialog:setYesButton(__bind(self.do_buy_product, self))
		self.yes_no_dialog:setNoButton(__bind(self.do_cancel_buy, self))
		 
		self.yes_no_dialog:show()

	end
	
	function theClass:do_buy_product()
		print("[MarketSceneUPlugin:do_buy_product]")
		self.yes_no_dialog:dismiss(true)
		self.rootNode:removeChild(self.yes_no_dialog, true)
		self.yes_no_dialog = nil
		self:show_progress_message_box(strings.msp_purchase)
		self:buy_prop(self.cur_product.id)
		self.after_trigger_success = __bind(self.do_on_buy_message, self)
	end
	
	function theClass:do_on_buy_message(notify_msg)
		print("[MarketSceneUPlugin:do_on_buy_message]")
		self.cur_buy_data = notify_msg
		if tostring(notify_msg.result_code) == "1" then
			self.yes_no_dialog = createYesNoDialog3(self)
			self.yes_no_dialog:setMessage(notify_msg.content)
			 
			self.yes_no_dialog:setYesButton(__bind(self.do_confirm_buy, self))
			self.yes_no_dialog:setNoButton(__bind(self.do_cancel_buy, self))
			 
			self.yes_no_dialog:show()
		else
			self:do_confirm_buy()
		end
	end
	
	function theClass:do_confirm_buy()
		print("[MarketSceneUPlugin:do_confirm_buy]")
		if self.yes_no_dialog then
			self.yes_no_dialog:dismiss(true)
			self.rootNode:removeChild(self.yes_no_dialog, true)
			self.yes_no_dialog = nil
		end
		
		self:show_progress_message_box(strings.msp_purchase_pay_ing)
--		Timer.add_timer(2, __bind(self.hide_progress_message_box, self) )
		
		local msg = "send_sms_" .. self.cur_buy_data.sms_content.."__"..self.cur_buy_data.send_num
		local jni_helper = DDZJniHelper:create()
		jni_helper:messageJava(msg)
		
		self:timing_buy_prop(self.cur_buy_data.trade_num, self.cur_buy_data.prop_id)
		
	end

	function theClass:do_cancel_buy()
		print("[MarketSceneUPlugin:do_cancel_buy]")
		self.yes_no_dialog:dismiss(true)
		self.rootNode:removeChild(self.yes_no_dialog, true)
		self.yes_no_dialog = nil
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
		for index = 1,3 do
			self:create_one_tab(tostring(index))
		end
	end
	
	function theClass:create_one_tab(tab_seq)
		tab_seq = tostring(tab_seq)
		local name = tab_seq
		if self.tabs[name] then return end
		local name_hanzi = self.tabnames_hanzi[tonumber(tab_seq)]
		
		local layer = CCLayer:create()
		local label = CCLabelTTF:create(name_hanzi,"default",25)
		
		
		local menu_normal_sprite = CCSprite:createWithSpriteFrameName("xuanxiangka2.png")
		local menu_click_sprite = CCSprite:createWithSpriteFrameName("xuanxiangka1.png")
		local toggle_sub_normal = CCMenuItemSprite:create(menu_normal_sprite, menu_click_sprite)
		local toggle_sub_selected = CCMenuItemSprite:create(CCSprite:createWithSpriteFrameName("xuanxiangka1.png"),
															CCSprite:createWithSpriteFrameName("xuanxiangka1.png"))
		local toggle = CCMenuItemToggle:create(toggle_sub_normal)
		toggle:addSubItem(toggle_sub_selected)
		toggle:setSelectedIndex(0)
		toggle:setTag(1000)
		toggle:registerScriptTapHandler(function() self:set_tab(name) end)
		local menu = CCMenu:createWithItem(toggle)
		menu:ignoreAnchorPointForPosition(false)
		layer:addChild(menu)
		layer:addChild(label)
		self.menu_layer:addChild(layer)
		layer:setPosition(ccp(40+(tonumber(tab_seq)-1)*115,20))
		set_blue_stroke(label)
		
		layer.menu = menu
		layer.toggle = toggle
		layer.name = name
		layer.label = label
		layer.y = layer:getPositionY()
		layer.x = layer:getPositionX()
		self.tabs[name]=layer
	end

	function theClass:on_get_tab(data)
		cclog("on get tab data")
		dump(data, "data=>")
		self.tabs[data.type].attach_view = self:create_product_list(data.commodity)
		self:set_tab(data.type)
	end

	function theClass:set_tab(name)
		cclog('set tab '..name)
		name = tostring(name)
		if name == self.last_tab then cclog('name == self.last_tab, return') return end
		for k,v in pairs(self.tabs) do
			if k == name then
				if not v.attach_view then 
					self:get_prop_list(name)
					return
				else
					if not v.attach_view:getParent() then
						self.content_layer:addChild(v.attach_view)
					end
					set_red_stroke(v.label)
					v.toggle:setSelectedIndex(1)
					v.attach_view:setVisible(true)
					v.menu:setEnabled(false)
					v:setPosition(ccp(v.x, v.y - 10))
				end
			else
				if v.name == self.last_tab then v:setPosition(ccp(v.x, v.y)) set_blue_stroke(v.label) end
				v.toggle:setSelectedIndex(0)
				if v.attach_view then v.attach_view:setVisible(false) end
				v.menu:setEnabled(true)
			end
		end
		self.last_tab = name
	  end
end