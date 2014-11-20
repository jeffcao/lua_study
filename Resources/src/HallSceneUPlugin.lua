local cjson = require "cjson"
require "UserCenterScene"
require "YesNoDialog"
require "MarketScene"
require "MenuDialog"
require "GamingScene"
require "InitPlayerInfoLayer"
require "FeedbackScene"
require "PlayerProductsScene"
require 'telephone-charge.TelephoneChargeUtil'
require 'src.AppStats'

HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:getRank()
		AppStats.event(UM_RANK_SHOW,runningscene().name)
		if not self.rank_dialog then
			self.rank_dialog = createRank(GlobalSetting.hall_server_websocket,'ui.')
			self.rootNode:addChild(self.rank_dialog)
		else
			self.rank_dialog:show()
		end
	end

	function theClass:onKeypad(event)
		local key = event.key
		print("hall scene on key pad", key)
		if hasDialogFloating(self) then print("hall scene there is dialog floating") return end
		if key == "back" then
			local scene = createLoginScene()
			CCDirector:sharedDirector():replaceScene(scene)
			self:close_hall_websocket()
			if GlobalSetting.online_time_get_beans_handle then
				cclog('cancel previous online_time_get_beans while switch')
				Timer.cancel_timer(GlobalSetting.online_time_get_beans_handle)
				GlobalSetting.online_time_get_beans_handle = nil
			end
		end
	end
	
	function theClass:on_kill_this_scene()
		self:close_hall_websocket()
		if GlobalSetting.online_time_get_beans_handle then
			cclog('cancel previous online_time_get_beans while switch')
			Timer.cancel_timer(GlobalSetting.online_time_get_beans_handle)
			GlobalSetting.online_time_get_beans_handle = nil
		end
	end
	
	function theClass:doShowExitDialog()
		endtolua_guifan()
	end
	
	function theClass:online_time_beans_update()
		self:update_player_beans_with_gl()
	end
	
	--通过global setting存储的user来更新
	function theClass:update_player_beans_with_gl()
		cclog("update_player_beans_with_gl()")
		local user = GlobalSetting.current_user
		if user and user.score then
			local player_beans_lb = tolua.cast(self.player_beans_lb, "CCLabelTTF")
			player_beans_lb:setString(user.score)
		end
	end
	
	function theClass:updateTimeTask()
		local task = GlobalSetting.time_task
		if not task then return end
		dump(task, 'time task is ')
		-- self.task_lbl:setString(task.name)
--		self:set_btn_stroke(self.task_lbl)
		self.task_layer:setVisible(true)
	end
	
	function theClass:do_on_task_btn_clicked()
		AppStats.event(UM_DAY_ACTIVITY_SHOW)
		local tm = createTimeTask() self.rootNode:addChild(tm) tm:show()
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
	
	function theClass:do_ui_prop_btn_clicked(tag, sender)
		print("[HallSceneUPlugin:do_ui_prop_btn_clicked]")
		--local scene = createPlayerProductsScene()
		local scene = createUserCenterScene(__bind(self.init_current_player_info, self),"player_cats")
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:do_ui_promotion_btn_clicked(tag, sender)
		print("[HallSceneUPlugin:do_ui_promotion_btn_clicked]")
		local scene = createPromotionScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:doToMarket()
		local scene = createMarketScene(__bind(self.inactive_market_scene, self))
		self.matket_scene = scene
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:inactive_market_scene()
		print("[HallSceneUPlugin:inactive_market_scene]")
		self.matket_scene = nil
	end
	
	function theClass:doToInfo()
		local scene = createUserCenterScene(__bind(self.init_current_player_info, self))
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:do_on_enter()
		print("[HallSceneUPlugin:do_on_enter]")
		if GlobalSetting.hall_server_websocket == nil then
			self:show_progress_message_box(strings.hsp_connect_hall_ing)
			self:connect_to_hall_server()
		else
			if GlobalSetting.need_init_hall_rooms == 1 then
				self:init_channel()
				self:init_hall_info()
			end
		end
	end
	
	function theClass:do_ui_feedback_btn_clicked()
		local scene = createFeedbackScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:init_hall_info(data)
		print("[HallSceneUPlugin:init_hall_info]")
		self:start_push()
		GlobalSetting.need_init_hall_rooms = 0
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
--		dump(data, "HallSceneUPLug:display_player_info, data=> ")
		self:init_current_player_info()
		self:update_global_player_score_ifno(data)
		if tonumber(GlobalSetting.current_user.flag) == 0 and GlobalSetting.show_init_player_info_box == 1 then
			--do not show init player info toast
			--TODO should notify server do not pass key flag of user
			--[[
			local init_player_info_layer = createInitPlayerInfoLayer(__bind(self.init_player_info_callback, self))
			self.rootNode:addChild(init_player_info_layer, 100, 909)
			print("[HallSceneUPlugin:display_player_info] init_player_info_layer:show")
			init_player_info_layer:show()
			GlobalSetting.show_init_player_info_box = 0
			]]
		end
		 
		self:get_today_activity()
		self.after_trigger_success = __bind(self.init_today_activity, self)
	end
	
	function theClass:on_activity_update(data)
		self:updateTimeTask()
	end
	
	function theClass:init_today_activity(data)
		dump(data, 'init_today_activity')
		if tonumber(data.result_code) == 0 then
			cclog('init_today_activity result code is 0')
			GlobalSetting.time_task = data
			GlobalSetting.time_task.weekday = get_weekday(data.week)
			dump(GlobalSetting.time_task, 'GlobalSetting.time_task')
			self:updateTimeTask()
		end
		Stats:flush(GlobalSetting.hall_server_websocket)
		
		self:check_tech_msg("sign")
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
		print("[HallSceneUPlugin:update_global_player_score_ifno]")

		local player_beans_lb = tolua.cast(self.player_beans_lb, "CCLabelTTF")
		player_beans_lb:setString(score_info.score)
		dump(score_info, "[HallSceneUPlugin:update_global_player_score_ifno] score_info: ")
		GlobalSetting.current_user.score = score_info.score
		GlobalSetting.current_user.win_count = score_info.win_count
		GlobalSetting.current_user.lost_count = score_info.lost_count	
	end
	
	function theClass:refresh_room_data()
		self:get_all_rooms()
		self.after_trigger_success = __bind(self.refresh_room_scrollview, self)
	end


	function theClass:refresh_room_scrollview(data)
		print("[HallSceneUPlugin:refresh_room_scrollview]")
		if not self.room_layer_scrollview then
			self.scrollTop = 240
			self.scrollHeight = 240
			self.scrollWidth = 700
			self.cellHeight = 240
			self.cellWidth = 240
			self.cellNums = #(data.room)/2 + #(data.room)%2

			self.ScrollContainer = display.newLayer()
			self.ScrollContainer:setContentSize(CCSizeMake(self.cellWidth*self.cellNums, self.cellHeight))
		    self.ScrollContainer:setTouchEnabled(true)
		    self.ScrollContainer:setPosition(ccp(5, -5))
		    self.ScrollContainer:setTouchSwallowEnabled(false)
		    self.ScrollContainer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		    	print("HallSceneUPlugin:refresh_room_scrollview, ScrollContainer.ontouched")
		        return self:onScrollCellCallback(event.name, event.x, event.y)
		    end)
			
	
			self.room_layer_scrollview = CCScrollView:create()
			self.room_layer_scrollview:setContentSize(CCSizeMake(0, 0))
			self.room_layer_scrollview:setViewSize(CCSizeMake(self.scrollWidth, self.scrollHeight))
			self.room_layer_scrollview:setContainer(self.ScrollContainer)
			self.room_layer_scrollview:setDirection(kCCScrollViewDirectionHorizontal)
			self.room_layer_scrollview:setClippingToBounds(true)
			self.room_layer_scrollview:setBounceable(true)
			self.room_layer_scrollview:setDelegate(this)


			local function scrollView2DidScroll()
				print("HallSceneUPlugin:refresh_room_scrollview, scrollView2DidScroll")
			    
			end
			self.room_layer_scrollview:registerScriptHandler(scrollView2DidScroll, CCScrollView.kScrollViewScroll)

			-- self.room_layer_scrollview:onScroll(handler(self, self.scrollListener))
			self.room_layer_scrollview:setPosition(CCPointMake(0,-5))
			self.middle_layer:addChild(self.room_layer_scrollview)
			self.room_datas = data
			local k=0
			for i=1, #(data.room) do
				local i_room = createRoomItem()
				print("[HallSceneUPlugin:refresh_room_scrollview] idx: " .. i, i_room)
				i_room:init_room_info(data.room[i], i)
				i_room.on_touch_callback = __bind(self.do_on_room_touched, self)
				i_room:setPosition(ccp(k*self.cellWidth, (i%2)*120))
				self.ScrollContainer:addChild(i_room, 0, data.room[i].room_id)
				if (i%2) == 0 then k=k+1 end

			end
		else
			for i=1, #(data.room) do
				local i_room_info = data.room[i]
				local i_room = self.ScrollContainer:getChildByTag(i_room_info.room_id)
	
				i_room:init_room_info(i_room_info, i)

			end

		end
		
	end
	function theClass:onScrollCellCallback(event, x, y)
	    if event == "began" then
	    	self.scroll_view_moved_x_s = x
	    	GlobalSetting.hall_scroll_view_moving = false
	    	print("HallSceneUPlugin:refresh_room_scrollview, onScrollCellCallback, began")
	    elseif event == "moved" then
	    	local x_distance = math.abs(x - self.scroll_view_moved_x_s)
	    	print("HallSceneUPlugin:refresh_room_scrollview, onScrollCellCallback, moved, x_distance=", x_distance)
	    	if x_distance > 10 then
	    		GlobalSetting.hall_scroll_view_moving = true
	    	end
	    elseif event == "ended" then
	    	self.bolTouchEnd = true
	    	print("HallSceneUPlugin:refresh_room_scrollview, onScrollCellCallback, ended")
	    end
	    return true
	end

	function theClass:scrollListener(event)
		-- print("theClass - scrollListener:" .. event.name)
	end
	

	-- function theClass:refresh_room_tabview(data)
	-- 	dump(data,"[HallSceneUPlugin:refresh_room_tabview]")
	-- 	if not self.room_layer_t then

	-- 		local function cellSizeForTable(table,idx)
	-- 			return 260,260
	-- 		end

	-- 		local function numberOfCellsInTableView(table)
	-- 			if data and data.room then
	-- 				return #(data.room)
	-- 			end

	-- 			return 0
	-- 		end
			
	-- 		local function tableCellTouched(table,cell)
	-- 		    --print("cell touched at index: " .. cell:getIdx())
	-- 				print("[HallSceneUPlugin:refresh_room_tabview] room_cell_couched")
	-- 				local a3 = tolua.cast(cell:getChildByTag(1), "CCLayer")
	-- 				dump(a3.room_info, "[HallSceneUPlugin:init_room_tabview] room_cell_couched, room_info: ")
	-- 				self:do_on_room_touched(a3.room_info)
	-- 		end

	-- 		local function tableCellAtIndex(table, idx)
	-- 		    local strValue = string.format("%d",idx)
	-- 		    local cell = table:dequeueCell()
	-- 		    local label = nil
	-- 		    if nil == cell then
	-- 	        		cell = CCTableViewCell:new()
	-- 					local a3 = createRoomItem()
	-- 					print("[HallSceneUPlugin:refresh_room_tabview] idx: " .. idx, a3)
	-- 					a3:init_room_info(data.room[idx + 1], idx + 1)
	-- 					cell:addChild(a3, 0, 1)
	-- 		    else
	-- 					local a3 = tolua.cast(cell:getChildByTag(1), "CCLayer")
	-- 					local room_index = idx + 1
	-- 					a3:init_room_info(data.room[room_index], room_index)
	-- 			end

	-- 		    return cell
	-- 		end

	-- 	    local tableView = CCTableView:create(CCSizeMake(800,260))
	-- 	    local t = tableView
	-- 	    tableView:setDirection(kCCScrollViewDirectionHorizontal)

	-- 	    tableView:registerScriptHandler(tableCellTouched,CCTableView.kTableCellTouched)
	-- 	    tableView:registerScriptHandler(cellSizeForTable,CCTableView.kTableCellSizeForIndex)
	-- 	    tableView:registerScriptHandler(tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
	-- 	    tableView:registerScriptHandler(numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
	-- 	    tableView:reloadData()


	-- 		t:setPosition(CCPointMake(0,0))
	-- 		self.middle_layer:addChild(t)
	-- 		self.room_layer_t = t
	-- 		self.room_datas = data
	-- 	else
	-- 		for k,v in pairs(data) do
	-- 			self.room_datas[k] = data[k]
	-- 		end
	-- 		self.room_layer_t:reloadData()
	-- 	end
		
	-- 	for index=#(data.room), 1, -1 do
	-- 		self.room_layer_t:updateCellAtIndex(index-1)
	-- 	end
	-- end
	
	function theClass:init_room_tabview(data)
		print("[HallSceneUPlugin:init_room_tabview]")
		-- self:refresh_room_tabview(data)
		self:refresh_room_scrollview(data)
		self:listen_match_event()
		self:check_kick_out()
		self:get_user_profile()
		self.after_trigger_success = __bind(self.display_player_info, self)
		
	end

	function theClass:do_quick_game_btn_clicked(tag, sender)
		print("[HallSceneUPlugin:do_quick_game_btn_clicked]")
		AppStats.event(UM_FAST_REQUEST_ROOM)
		self:show_progress_message_box(strings.hsp_get_room_info_ing)
		self:fast_begin_game()
		self.after_trigger_success = __bind(self.do_connect_game_server, self)
	end
	
	function theClass:do_on_room_touched(room_info)
		if TelephoneChargeUtil.is_telephone_charge_room(room_info) then
			TelephoneChargeUtil.on_telehone_charge_room_clicked(room_info)
			return
		end
		
		local enter_func = function()
			print("[HallSceneUPlugin:do_on_room_touched]")
			if tonumber(GlobalSetting.current_user.score) < tonumber(room_info.min_qualification) then
				PurchasePlugin.suggest_buy('douzi')
				return
			end
			local enter_info = {user_id=GlobalSetting.current_user.user_id, room_id=room_info.room_id}
			self:show_progress_message_box(strings.hsp_get_room_info_ing)
			self:request_enter_room(enter_info)
			self.after_trigger_success = __bind(self.do_connect_game_server, self)
		end
		MatchLogic.on_match_room_click(room_info, enter_func)
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
		if not is_blank(data.result_message) then
			self.failure_msg = data.result_message
		end 
		self:show_back_message_box(self.failure_msg)
		if "function" == type(self.after_trigger_failure) then
			self.after_trigger_failure(data)
		end
	end
	
	function theClass:do_on_connection_game_server_failure()
		print("[HallSceneUPlugin:do_on_connection_game_server_failure]")
		self:hide_progress_message_box()
		self:show_message_box(strings.hsp_connect_game_server_w)
	end
	
	function theClass:enter_game_room()
		local game = createGamingScene()
--		CCDirector:sharedDirector():replaceScene(game)
		CCDirector:sharedDirector():pushScene(game)
		GlobalSetting.player_game_position = 3
--		self:close_hall_websocket()
--		if GlobalSetting.online_time_get_beans_handle then
--			cclog('cancel previous online_time_get_beans handler while enter game')
--			Timer.cancel_timer(GlobalSetting.online_time_get_beans_handle)
--			GlobalSetting.online_time_get_beans_handle = nil
--		end
	end
	
	function theClass:updateSocket(status)
		print("update socket status to " .. status)
	end
	
	function theClass:exit()
		local exit_hall_scene = function()
			CCDirector:sharedDirector():endToLua()
		end
		Timer.add_timer(1, exit_hall_scene)
	end
	
	if theClass.registerCleanup then
		print("HallServerConnectionPlugin register cleanup")
		theClass:registerCleanup("HallServerConnectionPlugin.close_hall_websocket", theClass.close_hall_websocket)
	end
end