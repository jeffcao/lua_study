LoginHallConnectionPlugin = {}


function LoginHallConnectionPlugin.bind(theClass)

	function theClass:connect_to_hall_server()
		print("[LoginHallConnectionPlugin:connect_to_hall_server()]")
		local function connection_failure(data)
			print("[LoginHallConnectionPlugin.connection_failure].")
			dump(data, "connection_failure data")
			GlobalSetting.hall_server_websocket = nil
	--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
			if "function" == type(self.do_on_connection_hall_server_failure) then
				self:do_on_connection_hall_server_failure(data)
			end
		end
		if GlobalSetting.hall_server_websocket == nil then
			print("[LoginHallConnectionPlugin:connect_to_hall_server()] hall_server_websocket is nil, init it.")
			GlobalSetting.hall_server_websocket = WebSocketRails:new("ws://"..GlobalSetting.hall_server_url.."/websocket", true)
			GlobalSetting.hall_server_websocket.on_open = __bind(self.on_hall_server_websocket_ready, self)
			GlobalSetting.hall_server_websocket:bind("connection_closed", connection_failure)
		end
		
	end
	
	function theClass:check_connection_hall_server()
		
		local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token, run_env = GlobalSetting.run_env, app_id = GlobalSetting.app_id}
		CheckSignLua:fix_sign_param(event_data)
		
		GlobalSetting.hall_server_websocket:trigger("ui.check_connection", 
			event_data,
			__bind(self.enter_hall, self),
			function(data) 
				CheckSignLua:check_stoken(data) 
				if self.on_trigger_failure then
					self:on_trigger_failure(data)
				end
			end
		)
	end
	
	function theClass:on_check_hall_connection_failure()
		self:hide_progress_message_box()
		self:show_message_box(strings.lhcp_check_hall_connection_w)
		
	end
	
	function theClass:on_hall_server_websocket_ready()
		print("[LoginHallConnectionPlugin:on_hall_server_websocket_ready()]")
	
		GlobalSetting.hall_server_websocket:bind("ui.hand_shake", function(data) 
			dump(data, "ui.hand_shake") 
			GlobalSetting.hall_server_websocket:unbind_clear("ui.hand_shake")
			CheckSignLua:generate_stoken(data)
			if "function" == type(self.do_on_hall_server_websocket_ready) then
				self:do_on_hall_server_websocket_ready()
			end
		end)
	end
	
	function theClass:do_on_hall_server_websocket_ready()
		print("[LoginHallConnectionPlugin:do_on_hall_server_websocket_ready]")
		self:check_connection_hall_server()
		self.after_trigger_success = __bind(self.enter_hall, self)
	end
	
	function theClass:do_connect_hall_server(room_info)
		print("[LoginHallConnectionPlugin:enter_hall]")
		dump(room_info, "[LoginHallConnectionPlugin:enter_game_room] room_info: ")

		self:show_progress_message_box(strings.lhcp_enter_hall_ing)
		if GlobalSetting.hall_server_websocket == nil then
			self:connect_to_hall_server()
		else
			self:do_on_websocket_ready()
		end
		
	end
	
	
end