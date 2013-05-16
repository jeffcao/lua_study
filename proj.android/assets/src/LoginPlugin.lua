LoginPlugin = {}

function LoginPlugin.bind(theClass)
	--theClass.login_websocket = nil
	
	function theClass:sign_success(data)
		--print(data, "data", true)
		print("[LoginWebsocketPlugin.sign_success] updating local user info.")
		local userDefault = CCUserDefault:sharedUserDefault()
		GlobalSetting.current_user.load_from_json(data.user_profile)
		local cur_user = GlobalSetting.current_user
		--cur_user.user_id = data.user_id
		cur_user.login_token = data.token
		cur_user.save(userDefault)
		dump(cur_user, "current_user")
	end
	
	function theClass:sign_failure(data)
	end
	
	function theClass:sign_in_by_token(user_id, token)
		local event_data = {retry="0", login_type="102", user_id = user_id, token = user_token, version="1.0"}
		self.login_websocket:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:sign_in_by_password(username, password)
	end
	
	function theClass:signup()
		self.login_websocket:trigger("login.sign_up", 
			{retry="0", sign_type="100"} , 
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:on_websocket_ready()
		local cur_user = GlobalSetting.current_user
		if is_blank(cur_user.user_id) and is_blank(cur_user.login_token) then
			self:sign_in_by_token(cur_user.user_id, cur_user.login_token)
		else
			self:signup()	
		end
	end
	
	function theClass:connect_to_login_server(config)
		self.login_websocket = WebSocketRails:new(config.login_urls[1], true)
		self.login_websocket.on_open = __bind(self.on_websocket_ready, self)
	end
	
end