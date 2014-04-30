local json = require "cjson"

HallServerConnectionPlugin = {}


function HallServerConnectionPlugin.bind(theClass)

	function theClass:on_trigger_success(data)
		print("[HallServerConnectionPlugin.on_trigger_success].")
		dump(data, "on_trigger_success data")

		print("[HallServerConnectionPlugin.on_trigger_success] do_on_trigger_success=> "..type(self.do_on_trigger_success))
		if "function" == type(self.do_on_trigger_success) then
			self:do_on_trigger_success(data)
		end
	end

	function theClass:on_trigger_failure(data)
		print("[HallServerConnectionPlugin.on_trigger_failure].")
		dump(data, "on_trigger_failure data")
--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
		if "function" == type(self.do_on_trigger_failure) then
			self:do_on_trigger_failure(data)
		end
	end
		
	
	function theClass:check_connection()
		self.failure_msg = strings.hscp_check_connection_w
		local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token, run_env = GlobalSetting.run_env, app_id = GlobalSetting.app_id}
		CheckSignLua:fix_sign_param(event_data)
		
		GlobalSetting.hall_server_websocket:trigger("ui.check_connection", 
			event_data,
			__bind(self.on_trigger_success, self),
			function(data) 
				CheckSignLua:check_stoken(data) 
				if self.on_trigger_failure then
					self:on_trigger_failure(data)
				end
			end
		)
	end
	
	function theClass:get_all_rooms()
		self.failure_msg = strings.hscp_get_rooms_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id}
		self:call_server_method("get_room", event_data)

	end
	
	function theClass:get_charge_matches(room_id, suc_func)
		self.failure_msg = strings.hscp_get_charge_matches_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, room_id=room_id}
		
		GlobalSetting.hall_server_websocket:trigger("ui.get_room_match_list", 
			event_data,
			suc_func,
			__bind(self.on_trigger_failure, self))
	end
	
	function theClass:get_today_activity()
		self.failure_msg = strings.hscp_get_today_activity_w
		local event_data = {retry="0"}
		self:call_server_method("get_activity", event_data)
	end
	
	--启动获取常规活动的任务
	function theClass:start_online_time_get_beans()
		if GlobalSetting.online_time_get_beans_handle then
			cclog('cancel previous online_time_get_beans handler when start a new')
			Timer.cancel_timer(GlobalSetting.online_time_get_beans_handle)
			GlobalSetting.online_time_get_beans_handle = nil
		end
		local suc = function(data) 
			dump(data, 'start_online_time_get_beans=>')
			local scene = CCDirector:sharedDirector():getRunningScene()
				dump(scene, 'running scene')
			if scene.rootNode and scene.show_server_notify and data.user_id then
				cclog('the running scene has root node')
				local msg = string.gsub(strings.hscp_zaixianyouli, "minutes", tostring(data.online_time))
				msg = string.gsub(msg, "beans", tostring(data.beans))
				--local msg = "在线有礼：您已在线满"..tostring(data.online_time).."分钟，获得了"..tostring(data.beans).."个豆子"
				scene:show_server_notify(msg)
				GlobalSetting.current_user.score = data.score
				GlobalSetting.current_user.game_level = data.game_level
				if scene.online_time_beans_update then
					scene:online_time_beans_update()
				end
			end
		end
		local fn = function()
			local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id}
			GlobalSetting.hall_server_websocket:trigger("ui.online_time_get_beans", 
			event_data, suc,
			function() cclog('ui.online_time_get_beans ui.online_time_get_beans') end)
			return true
		end
		local period = 60
		local timer_name = 'start_online_time_get_beans'
		GlobalSetting.online_time_get_beans_handle = Timer.add_repeat_timer(period, fn, timer_name)
		Timer.add_timer(0,fn,"start_online_time_get_beans_nr")
	end
	
	function theClass:get_user_profile()
		self.failure_msg = strings.hscp_get_player_info_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id}
		self:call_server_method("get_user_profile", event_data)

	end
	
	function theClass:complete_user_info(changed_info)
		self.failure_msg = strings.hscp_get_player_info_w
		self:call_server_method("complete_user_info", changed_info)

	end

	function theClass:reset_password(old_pwd, new_pwd)
		self.failure_msg = strings.hscp_update_pswd_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, oldpassword=old_pwd, newpassword=new_pwd}
		self:call_server_method("reset_password", event_data)
	
	end
		
	function theClass:request_enter_room(enter_info)
		self.failure_msg = strings.hscp_request_room_w
		self:call_server_method("request_enter_room", enter_info)
	end
	
	function theClass:fast_begin_game()
		self.failure_msg = strings.hscp_request_room_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id}
		self:call_server_method("fast_begin_game", event_data)
	end
	
	function theClass:get_vip_salary()
		self.failure_msg = strings.hscp_get_vip_salary_w
		local event_data = {user_id =  GlobalSetting.current_user.user_id}
		self:call_server_method("get_salary", event_data)
	end
	
	function theClass:feedback(content)
		self.failure_msg = strings.hscp_feedback_w
		local event_data = {user_id =  GlobalSetting.current_user.user_id, content = content}
		self:call_server_method("feedback", event_data)
	end
	
	function theClass:shop_prop_list(prop_type)
		self.failure_msg = strings.hscp_get_props_list_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, prop_type=prop_type}
		self:call_server_method("shop_prop_list", event_data)
	
	end
	
	function theClass:buy_prop(product_id)
		self.failure_msg = strings.hscp_purchase_prop_w
		local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, payment=getPayType()}
		self:call_server_method("buy_prop", event_data)
	
	end
	
	function theClass:timing_buy_prop(trad_seq, product_id)
		self.failure_msg = strings.hscp_purchase_prop_w
		local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, trade_id = trad_seq}
		self:call_server_method("timing_buy_prop", event_data)
		
	end
	
	function theClass:cate_list()
		self.failure_msg = strings.hscp_get_my_props_list_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id}
		self:call_server_method("cate_list", event_data)
		
	end
	
	function theClass:use_cate(product_id)
		self.failure_msg = strings.hscp_use_prop_w
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, prop_id = product_id}
		self:call_server_method("use_cate", event_data)
		
	end

	function theClass:call_server_method(method_name, pass_data)

		GlobalSetting.hall_server_websocket:trigger("ui."..method_name, 
			pass_data,
			__bind(self.on_trigger_success, self),
			__bind(self.on_trigger_failure, self))
	end
	
	function theClass:on_buy_product_message(data)
		print("[HallServerConnectionPlugin:on_buy_product_message()]")
		dump(data, "on_buy_product_message, data=>")
		if "function" == type(self.do_on_buy_produce_message) then
			print("HallServerConnectionPlugin, class name=> "..self.__cname)
			self:do_on_buy_produce_message(data)
		end
	end
	
	function theClass:on_websocket_ready()
		print("[HallServerConnectionPlugin:on_websocket_ready()]")
--		self.connection_state = 1
		print("[HallServerConnectionPlugin:on_websocket_ready()]")
		GlobalSetting.hall_server_websocket:bind("ui.hand_shake", function(data) 
			dump(data, "ui.hand_shake") 
			GlobalSetting.hall_server_websocket:unbind_clear("ui.hand_shake")
			CheckSignLua:generate_stoken(data)
			self:init_channel()
			if "function" == type(self.do_on_websocket_ready) then
				self:do_on_websocket_ready()
			end
		end)
	end
	
	function theClass:connect_to_hall_server()
		print("[HallServerConnectionPlugin:connect_to_hall_server()]")
		local function connection_failure(data)
			print("[HallServerConnectionPlugin.connection_failure].")
			dump(data, "connection_failure data")
	--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
			if "function" == type(self.do_on_connection_failure) then
				self:do_on_connection_failure()
			end
		end
		if GlobalSetting.hall_server_websocket == nil then
			print("[HallServerConnectionPlugin:connect_to_hall_server()] hall_server_websocket is nil, init it.")
			GlobalSetting.hall_server_websocket = WebSocketRails:new("ws://"..GlobalSetting.hall_server_url.."/websocket", true)
			GlobalSetting.hall_server_websocket.on_open = __bind(self.on_websocket_ready, self)
			GlobalSetting.hall_server_websocket:bind("connection_error", connection_failure)
		end
		
	end
	
	function theClass:init_channel() 
		print("[HallServerConnectionPlugin:init_channel()]")
		local user_channel_name = GlobalSetting.current_user.user_id.."_hall_channel"
		print("[HallServerConnectionPlugin:init_channel()] channel_name=> "..user_channel_name)
		GlobalSetting.hall_server_websocket.channels[user_channel_name] = nil
		self.hall_channel = GlobalSetting.hall_server_websocket:subscribe(user_channel_name)
		
		--[[
		self.hall_channel:bind("ui.buy_prop", function(data) 
			print("ui.buy_prop  aaaa")
			self:on_buy_product_message(data)
		end)
		]]
		PurchasePlugin.bind_ui_buy_prop_event(self.hall_channel)
		
		self.hall_channel:bind("ui.routine_notify", function(data)
			self:onServerNotify(data)
		end)
		
		self:initSocket(GlobalSetting.hall_server_websocket, "ui.restore_connection")
	end
	
	--正在重连网络
	function theClass:onSocketReopening()
		local jni_helper = DDZJniHelper:create()
		local network_state = jni_helper:get("IsNetworkConnected")
		print("network_state=> ", network_state, string.len(network_state))
		network_state = string.sub(network_state, 1, 1)
		if network_state == "t" then 
			self:show_progress_message_box(strings.hscp_restore_connection_ing,400)
		end
--		self.connection_state = 0
		print("HallServerConnectionPlugin onSocketReopening")
		self:updateSocket("socket: reopening")
	end
	
	--网络已重新连接上
	function theClass:onSocketReopened()
--		self.connection_state = 1

		GlobalSetting.hall_server_websocket:bind("ui.hand_shake", function(data) 
			dump(data, "ui.hand_shake of reopened socket") 
			GlobalSetting.hall_server_websocket:unbind_clear("ui.hand_shake")
			CheckSignLua:generate_stoken(data)
			print("HallServerConnectionPlugin onSocketReopened")
			self:restoreConnection()
			self:updateSocket("socket: reopened, restoring")
		end)
	end
	
	--网络重连失败
	function theClass:onSocketReopenFail()
		self:hide_progress_message_box()
		self:show_message_box(strings.hscp_restore_connection_w)
		print("HallServerConnectionPlugin onSocketReopenFail")
		self:exit()
	end
	
	--restore connection失败，退出游戏
	function theClass:onSocketRestoreFail()
		self:hide_progress_message_box()
		self:show_message_box(strings.hscp_restore_connection_w)
		print("HallServerConnectionPlugin onSocketRestoreFail")
		self:exit()
	end
	
	--restore connection成功
	function theClass:onSocketRestored(data)
		self:hide_progress_message_box()
		print("HallServerConnectionPlugin onSocketRestored")
		self:updateSocket("socket: restored")
		self:init_channel()
		if GlobalSetting.hall_scene then
			print('refresh hall room data after socket restored')
			GlobalSetting.hall_scene:refresh_room_data()
		end
	end

	-- activity onPause
	function theClass:on_pause()
		print("HallServerConnectionPlugin:on_pause")
		self:op_websocket(true)
	end
	
	-- activity onResume
	function theClass:on_resume()
		print("HallServerConnectionPlugin:on_resume")
		Timer.add_timer(2.5, function() self:op_websocket(false) end)
	end
	
	function theClass:op_websocket(pause)
		print("HallServerConnectionPlugin:op_websocket")
		GlobalSetting.hall_server_websocket:pause_event(pause)
	end
	
	function theClass:close_hall_websocket()
		print("[HallServerConnectionPlugin:close_hall_websocket()]")
		if GlobalSetting.hall_server_websocket then
			GlobalSetting.hall_server_websocket:close()
			GlobalSetting.hall_server_websocket = nil
			--通知socket已关闭
			if GlobalSetting.hall_closed_lsnrs then
				for _,v in pairs(GlobalSetting.hall_closed_lsnrs) do
					v()
				end
			end
		end
	end

	
end

