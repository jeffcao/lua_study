local json = require "cjson"

HallServerConnectionPlugin = {}


function HallServerConnectionPlugin.bind(theClass)

	function theClass:on_trigger_success(data)
		print("[HallServerConnectionPlugin.on_trigger_success].")
		dump(data, "on_trigger_success data")

		print("[HallServerConnectionPlugin.on_trigger_success] on_login_success.")
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
	
	function theClass:on_websocket_ready()
		print("[HallServerConnectionPlugin:on_websocket_ready()]")
		
		if "function" == type(self.do_on_websocket_ready) then
			self:do_on_websocket_ready()
		end
	end
	
	function theClass:on_game_server_websocket_ready()
		print("[HallServerConnectionPlugin:on_game_server_websocket_ready()]")
		
		if "function" == type(self.do_on_game_server_websocket_ready) then
			self:do_on_game_server_websocket_ready()
		end
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
	
	function theClass:check_connection()
		self.failure_msg = "与服务器连接认证失败"
		local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token, version="1.0"}
		self:call_server_method("check_connection", event_data)

	end
	
	function theClass:get_all_rooms()
		self.failure_msg = "获取房间列表失败"
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, version="1.0"}
		self:call_server_method("get_room", event_data)

	end
	
	function theClass:get_user_profile()
		self.failure_msg = "获取玩家信息失败"
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, version="1.0"}
		self:call_server_method("get_user_profile", event_data)

	end
	
	function theClass:complete_user_info(changed_info)
		self.failure_msg = "更新玩家信息失败"
		self:call_server_method("complete_user_info", changed_info)

	end
	
	function theClass:request_enter_room(enter_info)
		self.failure_msg = "请求房间失败"
		self:call_server_method("request_enter_room", enter_info)
	end
	
	function theClass:call_server_method(method_name, pass_data)
--		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, version="1.0"}
		GlobalSetting.hall_server_websocket:trigger("ui."..method_name, 
			pass_data,
			__bind(self.on_trigger_success, self),
			__bind(self.on_trigger_failure, self))
	end

	function theClass:close_hall_websocket()
		print("[HallServerConnectionPlugin:close_hall_websocket()]")
		if GlobalSetting.hall_server_websocket then
			GlobalSetting.hall_server_websocket:close()
			GlobalSetting.hall_server_websocket = nil
		end
	end
	
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
	
	--print("theClass.registerCleanup ==> ", theClass.registerCleanup)
	if theClass.registerCleanup then
		print("HallServerConnectionPlugin register cleanup")
		theClass:registerCleanup("HallServerConnectionPlugin.close_hall_websocket", theClass.close_hall_websocket)
	end
	
	
end