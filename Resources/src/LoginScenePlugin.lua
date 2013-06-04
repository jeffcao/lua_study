LoginScenePlugin = {}

function LoginScenePlugin.bind(theClass)
	--theClass.login_websocket = nil
	
	function theClass:sign_success(data)
--		print(data, "data", true)
		print("[LoginWebsocketPlugin.sign_success] updating local user info in login scene.")
		dump(data.user_profile, "user_profile")
		local userDefault = CCUserDefault:sharedUserDefault()
		dump(userDefault, "userDefault")
		dump(GlobalSetting, "GlobalSetting")
		GlobalSetting.current_user:load_from_json(data.user_profile)
		local cur_user = GlobalSetting.current_user
		--cur_user.user_id = data.user_id
		cur_user.login_token = data.token
		cur_user:save(userDefault)
		dump(cur_user, "current_user")
		--when sign succuss, go to hall scene
		print("go to hall in login plugin")
		local hall = createHallScene()
		CCDirector:sharedDirector():replaceScene(hall)
	end
	
	
	
	function theClass:sign_failure(data)
		print("[LoginScene.sign_failure].")
		dump(data, "fign_failure data")
		print("[LoginScene.sign_failure] result code: "..data.result_code)
		
	end
	
	function theClass:sign_in_by_token(user_id, user_token)
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
		print("[LoginScene:on_websocket_ready()]")
--		local cur_user = GlobalSetting.current_user
--		if is_blank(cur_user.user_id) and is_blank(cur_user.login_token) then
--			self:sign_in_by_token(cur_user.user_id, cur_user.login_token)
--		else
--			self:signup()
--		end
	end
	
	function theClass:connect_to_login_server(config)
		print("[theClass:connect_to_login_server()]")
		self.login_websocket = WebSocketRails:new(config.login_urls[1], true)
		self.login_websocket.on_open = __bind(self.on_websocket_ready, self)
	end
	
	function theClass:close_login_websocket()
		print("[theClass:close_login_websocket()]")
		if self.login_websocket then
			self.login_websocket:close()
			self.login_websocket = nil
		end
	end
	
	--print("theClass.registerCleanup ==> ", theClass.registerCleanup)
	if theClass.registerCleanup then
		--print("register cleanup for LoginPlugin")
		theClass:registerCleanup("LoginPlugin.close_login_websocket", theClass.close_login_websocket)
	end
	
	--print( dump(theClass, "theClass", true) )
	
	
end