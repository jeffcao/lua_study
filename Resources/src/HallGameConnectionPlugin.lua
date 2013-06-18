HallGameConnectionPlugin = {}


function HallGameConnectionPlugin.bind(theClass)

	function theClass:connect_to_game_server()
		print("[HallServerConnectionPlugin:connect_to_game_server()]")
		local function connection_failure(data)
			print("[HallServerConnectionPlugin.connection_failure].")
			dump(data, "connection_failure data")
	--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
			if "function" == type(self.do_on_connection_game_server_failure) then
				self:do_on_connection_game_server_failure()
			end
		end
		if GlobalSetting.g_WebSocket == nil then
			print("[HallServerConnectionPlugin:connect_to_game_server()] game_server_websocket is nil, init it.")
			GlobalSetting.g_WebSocket = WebSocketRails:new(GlobalSetting.game_server_url, true)
			GlobalSetting.g_WebSocket.on_open = __bind(self.on_game_server_websocket_ready, self)
			GlobalSetting.g_WebSocket:bind("connection_error", connection_failure)
		end
		
	end
	
	function theClass:check_connection_game_server()
		self.failure_msg = "与游戏服务器连接认证失败"
		local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token, version="1.0"}
		GlobalSetting.g_WebSocket:trigger("g.check_connection", 
			event_data,
			__bind(self.on_trigger_success, self),
			__bind(self.on_trigger_failure, self))

	end
	
	function theClass:on_game_server_websocket_ready()
		print("[HallServerConnectionPlugin:on_game_server_websocket_ready()]")
		
		if "function" == type(self.do_on_game_server_websocket_ready) then
			self:do_on_game_server_websocket_ready()
		end
	end
	
	function theClass:do_on_game_server_websocket_ready()
		print("[HallSceneUPlugin:do_on_websocket_ready]")
		self:check_connection_game_server()
		self.after_trigger_success = __bind(self.enter_game_room, self)
	end
	
	function theClass:do_connect_game_server(room_info)
		print("[HallSceneUPlugin:enter_game_room]")
		dump(room_info, "[HallSceneUPlugin:enter_game_room] room_info: ")
		GlobalSetting.game_server_url = room_info.urls[1]
		GlobalSetting.game_info = room_info
		self:show_progress_message_box("进入房间...")
		if GlobalSetting.g_WebSocket == nil then
			self:connect_to_game_server()
		else
			self:do_on_websocket_ready()
		end
		
	end
	
	
end