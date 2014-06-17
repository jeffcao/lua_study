LoginServerConnectionPlugin = {}
require "src.CheckSignLua"
require 'src.MatchLogic'
require 'src.ShouchonglibaoDonghua'
require 'src.AppStats'

function LoginServerConnectionPlugin.bind(theClass)
	function theClass:sign_success(data)
--		print(data, "data", true)
		print("[LoginServerConnectionPlugin.sign_success] updating local user info in login scene.")
		dump(data, "LoginServerConnectionPlugin.sign_success data")
		
		local is_locked = self:check_locked(data)
		if is_locked then return end
		
		GlobalSetting.current_user:load_from_json(data.user_profile)
		local cur_user = GlobalSetting.current_user
		--cur_user.user_id = data.user_id
		cur_user.login_token = data.token
		print("LoginServerConnectionPlugin.sign_success, login_token=> "..cur_user.login_token)
		cur_user:save(CCUserDefault:sharedUserDefault())
		
		GlobalSetting.cm_sim_card_prefix = data.system_settings.cm_sim_card_prefix
		GlobalSetting.hall_server_url = data.url[1]
		GlobalSetting.game_push_url = data.msg_server_url
		
		--save in shared preference
		local user_default = CCUserDefault:sharedUserDefault()
		user_default:setStringForKey("notification_url",GlobalSetting.game_push_url)
		
		dump(data.system_settings, 'system_settings')
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
		
		if data.message_time then
			GlobalSetting.message_time = data.message_time
			GlobalSetting.push_handler = nil
		end
		
		if data.l_cpparam and data.me_phone_num and getPayType() == 'cmcc' then
			local jni = DDZJniHelper:create()
			jni:messageJava("do_cmcc_login_"..data.l_cpparam..'_'..data.me_phone_num)
		end
		
		if data.system_settings and data.system_settings.unsupport_uiimage_device then
			user_default:setStringForKey("unsupport_uiimage_device", data.system_settings.unsupport_uiimage_device)
		end
		
		
		if data.prop_list then
			GlobalSetting.cache_prop = data.prop_list
		end
		
		if data.min_charge_get_limit then
			GlobalSetting.min_charge_get_limit = tonumber(data.min_charge_get_limit)
		end
		
		if data.play_card_wait_time then
			GlobalSetting.play_card_wait_time = tonumber(data.play_card_wait_time)
		end
		
		if data.shouchong_finished then
			GlobalSetting.shouchong_finished = data.shouchong_finished
		end
		if data.shouchong_finished ~= 1 then
			ShouchonglibaoDonghua.sharedAnimation()
		end
		if data.shouchong_ordered ~= nil then
			GlobalSetting.shouchong_ordered = data.shouchong_ordered
			print("LoginServerConnectionPlugin.sign_success, GlobalSetting.shouchong_ordered=> ", GlobalSetting.shouchong_ordered)
		end
		
		if data.shouchong_prop_id then
			GlobalSetting.shouchong_prop_id = data.shouchong_prop_id
		end
		
		MatchLogic.parse_match_joined_when_login(data)
		print("[LoginServerConnectionPlugin.sign_success] on_login_success.")
		if "function" == type(self.do_on_login_success) then
			self:do_on_login_success()
		end
	end
	
	function theClass:sign_failure(data)
		print("[LoginServerConnectionPlugin.sign_failure].")
		dump(data, "fign_failure data")
		
		CheckSignLua:check_stoken(data)
		
--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
		if "function" == type(self.do_on_login_failure) then
			self:do_on_login_failure(data)
		end
	end
	
	function theClass:sign_in_by_token(user_id, user_token)
		local event_data = {retry="0", login_type="102", user_id = user_id, payment=getPayType(), token = user_token, app_id = GlobalSetting.app_id, version=resource_version}
		CheckSignLua:fix_sign_param(event_data)
		GlobalSetting.login_server_websocket:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:sign_in_by_password(username, password)
		local event_data = {retry="0", login_type="103", user_id = username, payment=getPayType(), password = password, app_id = GlobalSetting.app_id, version=resource_version}
		CheckSignLua:fix_sign_param(event_data)
		GlobalSetting.login_server_websocket:trigger("login.sign_in", 
			event_data,
			__bind(self.sign_success, self),
			__bind(self.sign_failure, self))
	end
	
	function theClass:signup()
		local event_data = {retry="0", sign_type="100", app_id = GlobalSetting.app_id, payment=getPayType(),  version=resource_version}		
		local device_info = device_info()
		table.copy_kv(event_data, device_info)
		dump(event_data, "[LoginServerConnectionPlugin.signup] event_data=>")
		GlobalSetting.login_server_websocket:trigger("login.sign_up", 
			event_data , 
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:fast_sign_up(nick_name, password, gender)
		local event_data = {retry="0", sign_type="101", nick_name=nick_name, password=password, payment=getPayType(),  gender=gender, app_id = GlobalSetting.app_id
		, version=resource_version} 
		local device_info = device_info()
		table.copy_kv(event_data, device_info)
		dump(event_data, "[LoginServerConnectionPlugin.fast_sign_up] event_data=>")
		GlobalSetting.login_server_websocket:trigger("login.sign_up", 
			event_data ,
			__bind(self.sign_success, self), 
			__bind(self.sign_failure, self) )
	end
	
	function theClass:forget_password(user_id, mail_address)
		local event_data = {retry="0", user_id=user_id, email=mail_address} 
		local device_info = device_info()
		table.copy_kv(event_data, device_info)
		dump(event_data, "[LoginServerConnectionPlugin.forget_password] event_data=>")
		GlobalSetting.login_server_websocket:trigger("login.forget_password", 
			event_data ,
			__bind(self.do_on_trigger_success, self), 
			__bind(self.do_on_trigger_failure, self) )
	end
	
	function theClass:on_websocket_ready()
		print("[LoginServerConnectionPlugin:on_websocket_ready()]")
		AppStats.endEvent(UM_CONNECT_LOGIN_SERVER)
		GlobalSetting.login_server_websocket:bind("ui.hand_shake", function(data) 
			dump(data, "ui.hand_shake") 
			GlobalSetting.login_server_websocket:unbind_clear("ui.hand_shake")
			CheckSignLua:generate_stoken(data)
			if "function" == type(self.do_on_websocket_ready) then
				self:do_on_websocket_ready()
			end
		end)
	end
	
	function theClass:connect_to_login_server(config)
		print("[LoginServerConnectionPlugin:connect_to_login_server()]")
		AppStats.beginEvent(UM_CONNECT_LOGIN_SERVER)
		local function sign_failure(data)
			print("[LoginServerConnectionPlugin.connect_to_login_server].")
			AppStats.endEvent(UM_CONNECT_LOGIN_SERVER)
			AppStats.event(UM_CONNECT_LOGIN_SERVER_FAILURE)
			dump(data, "fign_failure data")
	--		print("[LoginServerConnectionPlugin.sign_failure] result code: "..data.result_code)
			if "function" == type(self.do_on_connection_failure) then
				self:do_on_connection_failure(data)
			end
		end
		if GlobalSetting.login_server_websocket == nil then
			print("[LoginServerConnectionPlugin:connect_to_login_server()] login_server is nil, init it.")
			local url = config.login_urls[3]
			if GlobalSetting.local_url then
				url = GlobalSetting.local_url
			end
			GlobalSetting.login_server_websocket = WebSocketRails:new(url, true)
			GlobalSetting.login_server_websocket.on_open = __bind(self.on_websocket_ready, self)
			GlobalSetting.login_server_websocket:bind("connection_closed", sign_failure)
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