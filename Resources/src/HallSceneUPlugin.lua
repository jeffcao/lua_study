local json = require "cjson"
require "UserCenterScene"
require "YesNoDialog2"
require "YesNoDialog"
require "MarketScene"
require "MenuDialog"
require "GamingScene"

HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		print("hall scene on key pad")
		if key == "menuClicked" then
			if self.pop_menu and self.pop_menu:isAlive() then
				self.pop_menu:show()
			else
				 --self.pop_menu = createMenu(self.rootNode)
				 self.pop_menu = createMenuDialog()
				 self.pop_menu:show()
			end
		elseif key == "backClicked" then
			if self.pop_menu and self.pop_menu:isShowing() then
				self.pop_menu:dismiss()
			else
				self:doShowExitDialog()
			end
		end
	end
	
	function theClass:doShowExitDialog()
		if self.exit_dialog and self.exit_dialog:isAlive() then
			if self.exit_dialog:isShowing() then
				self.exit_dialog:dismiss()
			else
				self.exit_dialog:show()
			end
		else
		--	self.exit_dialog = createYesNoDialog(self.rootNode)
			self.exit_dialog = createYesNoDialog2()
			self.exit_dialog:setTitle("退出")
			self.exit_dialog:setMessage("您是否退出游戏?")
			self.exit_dialog:setYesButton(function()
				CCDirector:sharedDirector():endToLua()
			end)
			self.exit_dialog:show()
		end
	end
	
	function theClass:onMenuClick(tag, sender)
		self:onKeypad("menuClicked")
	end
	
	function theClass:onInfoClick(tag, sender)
		self.doToInfo()
	end
	
	function theClass:onAvatarClick(tag, sender)
		self.doToInfo()
	end
	
	function theClass:onMarketClick(tag, sender)
		self.doToMarket()
	end
	
	function theClass:doToMarket()
		--local scene = createMarketScene()
		local scene = createGamingScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:doToInfo()
		local scene = createUserCenterScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:do_on_enter()
		print("[HallSceneUPlugin:do_on_enter]")
		self:show_progress_message_box("连接大厅服务器...")
		self:connect_to_hall_server()
	end
	
	function theClass:ui_get_all_rooms(data)
		print("[HallSceneUPlugin:ui_get_all_rooms]")
		self:get_all_rooms()
		self.after_trigger_success = __bind(self.init_room_tabview, self)
	end
	
	function theClass:init_room_tabview(data)
		print("[HallSceneUPlugin:init_room_tabview]")
		dump(data.room, "[HallSceneUPlugin:init_room_tabview] data rooms: ")
		local room_index = 1
		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(260,260)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					a3 = createRoomItem()
					print("[HallSceneUPlugin:init_room_tabview] a1: "..a1)
					a3:init_room_info(data.room[a1], a1)
					print("[HallSceneUPlugin:init_room_tabview] room_index: "..room_index)
					room_index = room_index + 1
					a2:addChild(a3, 0, 1)
				end
				r = a2
			elseif fn == "numberOfCells" then
				r = #(data.room)
			elseif fn == "cellTouched" then
			end
			return r
		end)
		
		local t = LuaTableView:createWithHandler(h, CCSizeMake(800,260))
		t:setDirection(kCCScrollViewDirectionHorizontal)
		t:reloadData()
	--	t:setAnchorPoint(ccp(0.5, 0.5))
		t:setPosition(CCPointMake(0,0))
		self.middle_layer:addChild(t)
		
	end
	
	function theClass:do_on_websocket_ready()
		print("[HallSceneUPlugin:do_on_websocket_ready]")
		self:check_connection()
		self.after_trigger_success = __bind(self.ui_get_all_rooms, self)
	end
	
	
	function theClass:do_on_trigger_success(data)
		print("[HallSceneUPlugin:do_on_trigger_success]")
		self:hide_progress_message_box()
		
		if "function" == type(self.after_trigger_success) then
			self.after_trigger_success(data)
		end
		
	end
	
	function theClass:do_on_trigger_failure()
		print("[HallSceneUPlugin:do_on_trigger_failure]")
		self:hide_progress_message_box()
		self:show_message_box(self.failure_msg)
		if "function" == type(self.after_trigger_failure) then
			self.after_trigger_failure(data)
		end
	end
end