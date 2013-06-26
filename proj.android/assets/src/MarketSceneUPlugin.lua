require "MarketItem"
require "YesNoDialog3"
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
				r = CCSizeMake(800,73)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					a3 = createMarketItem()
					print("[MarketSceneUPlugin.create_product_list] a1 =>"..a1)
					a3:init_item(product_list[a1+1], __bind(self.do_buy_product, self))
					a2:addChild(a3, 0, 1)
				else
					local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
					a3:init_item(product_list[a1 + 1],  __bind(self.do_buy_product, self))
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
	
	function theClass:show_product_list(data)
		local product_view = self:create_product_list(data.commodity)
		self.rootNode:setContent(product_view)
	end
	
	
	function theClass:init_product_list()
		print("[MarketSceneUPlugin:do_on_trigger_success]")
		
		self:show_progress_message_box("获取商品列表")
		self:shop_prop_list()
		self.after_trigger_success = __bind(self.show_product_list, self)
		
	end
	
	function theClass:do_buy_product(product)
		self.cur_product = product
		self:show_progress_message_box("购买道具")
		self:buy_prop(product.id)
		self.after_trigger_success = __bind(self.show_buy_notify, self)
	end
	
	function theClass:show_buy_notify(notify_msg)
		 self.yes_no_dialog = createYesNoDialog3()
--		 self.yes_no_dialog:setTitle("购买提示")
		 local content = notify_msg.content
		 if content == json.null or is_blank(content) then
		 	content = "尊敬的客户，您即将购买的是\n游戏名：我爱斗地主\n道具名："
		 	content = content..self.cur_product.name.."\n道具数量：1\n服务提供商：新中南\n资费说明：\n" 	
		 	content = content..self.cur_product.price.." 点（即消费"..self.cur_product.rmb.."元人民币）\n点击确认按钮确认购买，中国移动"
			print("[MarketSceneUPlugin:show_buy_notify] notify content=> "..content)
		 end
		 self.yes_no_dialog:setMessage(content)
		 
		 self.yes_no_dialog:setYesButton(__bind(self.do_confirm_buy, self))
		 self.yes_no_dialog:setNoButton(__bind(self.do_cancel_buy, self))
		 
		 self.rootNode:addChild(self.yes_no_dialog)
		 self.yes_no_dialog:show()
	end
	
	function theClass:do_confirm_buy()
		print("[MarketSceneUPlugin:do_confirm_buy]")
		self.yes_no_dialog:dismiss()
		self.rootNode:removeChild(self.yes_no_dialog, true)
		self.yes_no_dialog = nil
	end
	
	function theClass:do_cancel_buy()
		print("[MarketSceneUPlugin:do_cancel_buy]")
		self.yes_no_dialog:dismiss()
		self.rootNode:removeChild(self.yes_no_dialog, true)
		self.yes_no_dialog = nil
	end
	
	function theClass:do_on_trigger_success(data)
		print("[MarketSceneUPlugin:do_on_trigger_success]")
		self:hide_progress_message_box()
		
		if "function" == type(self.after_trigger_success) then
			self.after_trigger_success(data)
		end
		
	end
	
	function theClass:do_on_trigger_failure(data)
		print("[MarketSceneUPlugin:do_on_trigger_failure]")
		self:hide_progress_message_box()
		self:show_message_box(self.failure_msg)
		if "function" == type(self.after_trigger_failure) then
			self.after_trigger_failure(data)
		end
	end
end