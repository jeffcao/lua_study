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
	
	function theClass:on_websocket_ready()
		print("[HallServerConnectionPlugin:on_websocket_ready()]")
		self:init_channel()
		if "function" == type(self.do_on_websocket_ready) then
			self:do_on_websocket_ready()
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

	function theClass:reset_password(old_pwd, new_pwd)
		self.failure_msg = "更改密码失败"
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, oldpassword=old_pwd, newpassword=new_pwd, version="1.0"}
		self:call_server_method("reset_password", event_data)
	
	end
		
	function theClass:request_enter_room(enter_info)
		self.failure_msg = "请求房间失败"
		self:call_server_method("request_enter_room", enter_info)
	end
	
	function theClass:fast_begin_game()
		self.failure_msg = "请求房间失败"
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, version="1.0"}
		self:call_server_method("fast_begin_game", event_data)
	end
	
	function theClass:feedback(content)
		self.failure_msg = "保存反馈信息失败"
		local event_data = {user_id =  GlobalSetting.current_user.user_id, content = content}
		self:call_server_method("feedback", event_data)
	end
	
	function theClass:shop_prop_list()
		self.failure_msg = "获取商品列表失败"
		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, version="1.0"}
		self:call_server_method("shop_prop_list", event_data)
	
	end
	
	function theClass:buy_prop(product_id)
		self.failure_msg = "购买道具失败"
		local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, version="1.0"}
		self:call_server_method("buy_prop", event_data)
	
	end
	
	function theClass:timing_buy_prop(trad_seq, product_id)
		self.failure_msg = "购买道具失败"
		local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, trade_id = trad_seq, version="1.0"}
		self:call_server_method("timing_buy_prop", event_data)
		
	end
	
	
	function theClass:call_server_method(method_name, pass_data)
--		local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id, version="1.0"}
		GlobalSetting.hall_server_websocket:trigger("ui."..method_name, 
			pass_data,
			__bind(self.on_trigger_success, self),
			__bind(self.on_trigger_failure, self))
	end
	
	function theClass:on_buy_product_message(data)
		print("[HallServerConnectionPlugin:on_buy_product_message()]")
		dump(data, "on_buy_product_message, data=>")
		if "function" == type(self.do_on_buy_produce_message) then
			print("HallServerConnectionPlugin, class name=> "..self.cls.__cname)
			self:do_on_buy_produce_message(data)
		end
	end
	
	function theClass:init_channel() 
		print("[HallServerConnectionPlugin:init_channel()]")
		local user_channel_name = GlobalSetting.current_user.user_id.."_hall_channel"
		print("[HallServerConnectionPlugin:init_channel()] channel_name=> "..user_channel_name)
		GlobalSetting.hall_server_websocket.channels[user_channel_name] = nil
		self.hall_channel = GlobalSetting.hall_server_websocket:subscribe(user_channel_name)
		
		self.hall_channel:bind("ui.buy_prop", function(data) 
			print("ui.buy_prop  aaaa")
			self:on_buy_product_message(data)
		end)
		
--		self:initSocket()
	end
	
	function theClass:close_hall_websocket()
		print("[HallServerConnectionPlugin:close_hall_websocket()]")
		if GlobalSetting.hall_server_websocket then
			GlobalSetting.hall_server_websocket:close()
			GlobalSetting.hall_server_websocket = nil
		end
	end

	
end