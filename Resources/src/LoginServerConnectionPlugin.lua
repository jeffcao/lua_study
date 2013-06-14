LoginServerConnectionPlugin = {}


function LoginServerConnectionPlugin.bind(theClass)
	function theClass:sign_success(data)
--		print(data, "data", true)
		print("[LoginServerConnectionPlugin.sign_success] updating local user info in login scene.")
		dump(data.user_profile, "user_profile")

		GlobalSetting.current_user:load_from_json(data.user_profile)
		local cur_user = GlobalSetting.current_user
		--cur_user.user_id = data.user_id
		cur_user.login_token = data.token
		cur_user:save(CCUserDefault:sharedUserDefault())
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
		GlobalSetting.login_server:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:sign_in_by_password(username, password)
	local event_data = {retry="0", login_type="103", user_id = user_id, password = password, version="1.0"}
		GlobalSetting.login_server:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:signup()
		GlobalSetting.login_server:trigger("login.sign_up", 
			{retry="0", sign_type="100"} , 
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:fast_sign_up(nick_name, password, gender)
		GlobalSetting.login_server:trigger("login.sign_up", 
			{retry="0", sign_type="101", nick_name=nick_name, password=password, gender=gender} , 
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:on_websocket_ready()
		print("[LoginServerConnectionPlugin:on_websocket_ready()]")
		
		if "function" == type(self.do_on_websocket_ready) then
			self:do_on_websocket_ready()
		end
	end
	
	function theClass:connect_to_login_server(config)
		print("[LoginServerConnectionPlugin:connect_to_login_server()]")
		if GlobalSetting.login_server == nil then
			print("[LoginServerConnectionPlugin:connect_to_login_server()] login_server is nil, init it.")
			GlobalSetting.login_server = WebSocketRails:new(config.login_urls[1], true)
			GlobalSetting.login_server.on_open = __bind(self.on_websocket_ready, self)
		end
		
	end
	
	function theClass:close_login_websocket()
		print("[LoginServerConnectionPlugin:close_login_websocket()]")
		if self.login_websocket then
			self.login_websocket:close()
			self.login_websocket = nil
		end
	end
	
	--print("theClass.registerCleanup ==> ", theClass.registerCleanup)
	if theClass.registerCleanup then
		--print("register cleanup for LoginPlugin")
		theClass:registerCleanup("LoginServerConnectionPlugin.close_login_websocket", theClass.close_login_websocket)
	end
end