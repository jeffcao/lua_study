LoginServerConnectionPlugin = {}


function LoginServerConnectionPlugin.bind(theClass)
	function theClass:sign_success(data)
--		print(data, "data", true)
		print("[LoginServerConnectionPlugin.sign_success] updating local user info in login scene.")
		dump(data, "LoginServerConnectionPlugin.sign_success data")
		
		GlobalSetting.current_user:load_from_json(data.user_profile)
		local cur_user = GlobalSetting.current_user
		--cur_user.user_id = data.user_id
		cur_user.login_token = data.token
		print("LoginServerConnectionPlugin.sign_success, login_token=> "..cur_user.login_token)
		cur_user:save(CCUserDefault:sharedUserDefault())
		
		GlobalSetting.cm_sim_card_prefix = data.system_settings.cm_sim_card_prefix
		GlobalSetting.hall_server_url = data.system_settings.ddz_hall_url
		print("LoginServerConnectionPlugin.sign_success, hall_server_url=> "..GlobalSetting.hall_server_url)
--		GlobalSetting.hall_server_token = data.token
		GlobalSetting.show_init_player_info_box = 1
		GlobalSetting.need_init_hall_rooms = 1
		
		if data.weibo then
			if data.weibo.sina_weibo then print('get sina share url') GlobalSetting.sina_share_url = data.weibo.sina_weibo end
			if data.weibo.tencent_weibo then print('get tencent share url') GlobalSetting.tencent_share_url = data.weibo.tencent_weibo end
		end
		if data.teach_msg then
			GlobalSetting.teach_msg = data.teach_msg
		end
		if data.vip then
			GlobalSetting.vip = data.vip
		end
		print("[LoginServerConnectionPlugin.sign_success] on_login_success.")
		if "function" == type(self.do_on_login_success) then
			self:do_on_login_success()
		end
	end
	
	
	
	function theClass:sign_failure(data)
		print("[LoginServerConnectionPlugin.sign_failure].")
		dump(data, "fign_failure data")
--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
		if "function" == type(self.do_on_login_failure) then
			self:do_on_login_failure()
		end
	end
	
	function theClass:sign_in_by_token(user_id, user_token)
		local event_data = {retry="0", login_type="102", user_id = user_id, token = user_token, version="1.0"}
		GlobalSetting.login_server_websocket:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:sign_in_by_password(username, password)
		local event_data = {retry="0", login_type="103", user_id = username, password = password, version="1.0"}
		GlobalSetting.login_server_websocket:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:signup()
		local event_data = {retry="0", sign_type="100"}
		local device_info = device_info()
		table.combine(event_data, device_info)
		dump(event_data, "[LoginServerConnectionPlugin.signup] event_data=>")
		GlobalSetting.login_server_websocket:trigger("login.sign_up", 
			event_data , 
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:fast_sign_up(nick_name, password, gender)
		local event_data = {retry="0", sign_type="101", nick_name=nick_name, password=password, gender=gender} 
		local device_info = device_info()
		table.combine(event_data, device_info)
		dump(event_data, "[LoginServerConnectionPlugin.fast_sign_up] event_data=>")
		GlobalSetting.login_server_websocket:trigger("login.sign_up", 
			event_data ,
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:forget_password(user_id, mail_address)
		local event_data = {retry="0", user_id=user_id, email=mail_address} 
		local device_info = device_info()
		table.combine(event_data, device_info)
		dump(event_data, "[LoginServerConnectionPlugin.forget_password] event_data=>")
		GlobalSetting.login_server_websocket:trigger("login.forget_password", 
			event_data ,
			__bind(self.do_on_trigger_success, self), 
			__bind(self.do_on_trigger_failure, self) )
	end
	
	function theClass:on_websocket_ready()
		print("[LoginServerConnectionPlugin:on_websocket_ready()]")
		
		if "function" == type(self.do_on_websocket_ready) then
			self:do_on_websocket_ready()
		end
	end
	
	function theClass:connect_to_login_server(config)
		print("[LoginServerConnectionPlugin:connect_to_login_server()]")
		local function sign_failure(data)
			print("[LoginServerConnectionPlugin.connect_to_login_server].")
			dump(data, "fign_failure data")
	--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
			if "function" == type(self.do_on_connection_failure) then
				self:do_on_connection_failure()
			end
		end
		if GlobalSetting.login_server_websocket == nil then
			print("[LoginServerConnectionPlugin:connect_to_login_server()] login_server is nil, init it.")
			GlobalSetting.login_server_websocket = WebSocketRails:new(config.login_urls[3], true)
			GlobalSetting.login_server_websocket.on_open = __bind(self.on_websocket_ready, self)
			GlobalSetting.login_server_websocket:bind("connection_error", sign_failure)
		end
		
	end
	
	function theClass:close_login_websocket()
		print("[LoginServerConnectionPlugin:close_login_websocket()]")
		if GlobalSetting.login_server_websocket then
			GlobalSetting.login_server_websocket:close()
			GlobalSetting.login_server_websocket = nil
		end
	end
	
	--print("theClass.registerCleanup ==> ", theClass.registerCleanup)
	if theClass.registerCleanup then
		print("LoginServerConnectionPlugin register cleanup")
		theClass:registerCleanup("LoginServerConnectionPlugin.close_login_websocket", theClass.close_login_websocket)
	end
end