local json = require "cjson"
require "UserCenterScene"
require "YesNoDialog2"
require "YesNoDialog"
require "MarketScene"
require "MenuDialog"
require "GamingScene"
require "InitPlayerInfoLayer"

HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		print("hall scene on key pad")
		if key == "menuClicked" then
--			if self.pop_menu and self.pop_menu:isAlive() then
--				self.pop_menu:show()
--			else
--				 --self.pop_menu = createMenu(self.rootNode)
--				 self.pop_menu = createMenuDialog()
--				 self.pop_menu:show()
--			end
			self.menu_layer = createMenu(__bind(self.menu_dismiss_callback, self), __bind(self.show_set_dialog, self))
			self.rootNode:addChild(self.menu_layer, 1001, 908)
			print("[HallSceneUPlugin:display_player_info] menu_layer:show")
			self.menu_layer:show()

		elseif key == "backClicked" then
			if self.menu_layer and self.menu_layer:isShowing() then
				self.menu_layer:dismiss()
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
	
	function theClass:menu_dismiss_callback()
		self.rootNode:removeChild(self.menu_layer, true)
		self.menu_layer = nil
	end
	
	function theClass:set_dialog_dismiss_callback()
		self.rootNode:removeChild(self.set_dialog_layer, true)
		self.set_dialog_layer = nil
	end
	
	function theClass:show_set_dialog()
		self.set_dialog_layer = createSetDialog(__bind(self.set_dialog_dismiss_callback, self))
		self.rootNode:addChild(self.set_dialog_layer, 1001, 907)
		print("[HallSceneUPlugin:show_set_dialog] set_dialog_layer:show")
		self.set_dialog_layer:show()
	end
	
	function theClass:onMenuClick(tag, sender)
		self:onKeypad("menuClicked")
	end
	
	function theClass:onInfoClick(tag, sender)
		self:doToInfo()
	end
	
	function theClass:onAvatarClick(tag, sender)
		self:doToInfo()
	end
	
	function theClass:onMarketClick(tag, sender)
		self:doToMarket()
	end
	
	function theClass:doToMarket()
		--local scene = createMarketScene()
--		local scene = createGamingScene()
--		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:doToInfo()
		local scene = createUserCenterScene(__bind(self.init_current_player_info, self))
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:do_on_enter()
		print("[HallSceneUPlugin:do_on_enter]")
		if GlobalSetting.hall_server_websocket == nil then
			self:show_progress_message_box("连接大厅服务器...")
			self:connect_to_hall_server()
		end
		
	end
	
	function theClass:init_hall_info(data)
		print("[HallSceneUPlugin:init_hall_info]")
		
		self:get_all_rooms()
		self.after_trigger_success = __bind(self.init_room_tabview, self)
		
	end
	
	function theClass:init_player_info_callback(need_refresh_player_info)
		local layer = self.rootNode:getChildByTag(909)
		self.rootNode:removeChild(layer, true)
		layer = nil
		if need_refresh_player_info then
			self:init_current_player_info()
		end
	end
	
	function theClass:display_player_avatar()
		local avatar_btn = tolua.cast(self.avatar_btn, "CCMenuItemImage")
		local avatar_png = self:get_player_avatar_png_name()

		print("[HallSceneUPlugin:display_player_avatar] avatar_png: "..avatar_png)
		avatar_btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
		avatar_btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
	end
	
	function theClass:display_player_info(data)
		self:init_current_player_info()
		self:update_global_player_score_ifno(data)
		if tonumber(GlobalSetting.current_user.flag) == 0 and GlobalSetting.show_init_player_info_box == 1 then
			local init_player_info_layer = createInitPlayerInfoLayer(__bind(self.init_player_info_callback, self))
			self.rootNode:addChild(init_player_info_layer, 1001, 909)
			print("[HallSceneUPlugin:display_player_info] init_player_info_layer:show")
			init_player_info_layer:show()
			GlobalSetting.show_init_player_info_box = 0
		end
	end
	
	function theClass:init_current_player_info()
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.info_plist)
		
		print("[HallSceneUPlugin:init_current_player_info]")
		
		local cur_user = GlobalSetting.current_user
		dump(cur_user, "[HallSceneUPlugin:init_current_player_info] cur_user: ")
		local nick_name_lb = tolua.cast(self.nick_name_lb, "CCLabelTTF")
		nick_name_lb:setString(cur_user.nick_name)

		self:display_player_avatar()
		
	end
	
	function theClass:update_global_player_score_ifno(score_info)
	
		local player_beans_lb = tolua.cast(self.player_beans_lb, "CCLabelTTF")
		player_beans_lb:setString(score_info.score)
		
		GlobalSetting.current_user.socre = score_info.score
		GlobalSetting.current_user.win_count = score_info.win_count
		GlobalSetting.current_user.lost_count = score_info.lost_count	
	end
	
	function theClass:init_room_tabview(data)
		print("[HallSceneUPlugin:init_room_tabview]")
		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(260,260)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					local a3 = createRoomItem()
					print("[HallSceneUPlugin:init_room_tabview] a1: "..a1)
					a3:init_room_info(data.room[a1], a1)
					a2:addChild(a3, 0, 1)
				else
					local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
					local room_index = a1 + 1
					a3:init_room_info(data.room[room_index], room_index)
				end
				r = a2
			elseif fn == "numberOfCells" then
				r = #(data.room)
			elseif fn == "cellTouched" then
				print("[HallSceneUPlugin:init_room_tabview] room_cell_couched")
				local a3 = tolua.cast(a1:getChildByTag(1), "CCLayer")
				dump(a3.room_info, "[HallSceneUPlugin:init_room_tabview] room_cell_couched, room_info: ")
				self:do_on_room_touched(a3.room_info)
			end
			return r
		end)
		
		local t = LuaTableView:createWithHandler(h, CCSizeMake(800,260))
		t:setDirection(kCCScrollViewDirectionHorizontal)
		t:reloadData()
	--	t:setAnchorPoint(ccp(0.5, 0.5))
		t:setPosition(CCPointMake(0,0))
		self.middle_layer:addChild(t)
		
		for index=#(data.room), 1, -1 do
			t:updateCellAtIndex(index-1)
		end

		self:get_user_profile()
		self.after_trigger_success = __bind(self.display_player_info, self)
		
	end
	
	function theClass:do_quick_game_btn_clicked(tag, sender)
		print("[HallSceneUPlugin:do_quick_game_btn_clicked]")
		self:show_progress_message_box("请求房间信息...")
		self:fast_begin_game()
		self.after_trigger_success = __bind(self.do_connect_game_server, self)
	end
	
	function theClass:do_on_room_touched(room_info)
		print("[HallSceneUPlugin:do_on_room_touched]")
		local enter_info = {user_id=GlobalSetting.current_user.user_id, room_id=room_info.room_id}
		self:show_progress_message_box("请求房间信息...")
		self:request_enter_room(enter_info)
		self.after_trigger_success = __bind(self.do_connect_game_server, self)
	end
	
	function theClass:do_on_websocket_ready()
		print("[HallSceneUPlugin:do_on_websocket_ready]")
		self:check_connection()
		self.after_trigger_success = __bind(self.init_hall_info, self)
	end
	
	
	function theClass:do_on_trigger_success(data)
		print("[HallSceneUPlugin:do_on_trigger_success]")
		self:hide_progress_message_box()
		
		if "function" == type(self.after_trigger_success) then
			self.after_trigger_success(data)
		end
		
	end
	
	function theClass:do_on_trigger_failure(data)
		print("[HallSceneUPlugin:do_on_trigger_failure]")
		self:hide_progress_message_box()
		self:show_message_box(self.failure_msg)
		if "function" == type(self.after_trigger_failure) then
			self.after_trigger_failure(data)
		end
	end
	
	
	function theClass:enter_game_room()
		local game = createGamingScene()
		CCDirector:sharedDirector():replaceScene(game)
	end
end