local json = require "cjson"
require "src.LoginServerConnectionPlugin"
require "src.LoginHallConnectionPlugin"
require "src.UIControllerPlugin"
require "LoginScene"
require "CCBReaderLoad"
require "src.Stats"


LandingScene = class("LandingScene", function()
	print("creating new landingScene")
	return display.newScene("LandingScene")
end)

function LandingScene:ctor()

	
	ccb.landing_scene = self
	self.on_ui_clickme_clicked = __bind(self.do_ui_clickme, self)
	
	

	local ccbproxy = CCBProxy:create()
	
	local node = CCBReaderLoad("LandingScene.ccbi", ccbproxy, false, "")
	
	self:addChild(node)
	
--	self.sprite_loading = self.ccbproxy:getNodeWithType("sprite_loading", "CCSprite")
	self:create_progress_animation(self.rootNode, self.sprite_loading)
	
	local bg_color = tolua.cast(self.bg_color, "CCLayerColor")
	bg_color:setColor(ccc3(0, 83, 121))
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end
	
function LandingScene:onEnter()
	print("[LandingScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:show_progress_message_box("连接服务器...")
	self:setup_websocket()
	--Stats:on_start("landing")
	
end

--websocket连接上之后，首先去访问服务器需不需要更新apk或者resource
function LandingScene:do_on_websocket_ready()
	self:hide_progress_message_box()
	local event_data = {retry="0"}
	local device_info = device_info()
	table.copy_kv(event_data, device_info)
	local check_update_fail = function()
		print("check_update_fail then exit")
		endtolua()
	end
	local check_update_succ = function(data)
		dump(data, "check_update_succ")
		if data.kind == "res" then
			self:do_update_resource(data)
		elseif data.kind == "apk" then
			self:do_update_apk(data)
		else
			self:do_on_go_sign()
		end
	end
	GlobalSetting.login_server_websocket:trigger("login.check_update", 
			event_data , check_update_succ, check_update_fail)
	self:show_progress_message_box("加载数据...")
	
	--self:do_on_go_sign()
end

--检查到apk有更新，下载并更新apk
function LandingScene:do_update_apk(data)
	--local path = CCFileUtils:sharedFileUtils():getWritablePath()
	local jni_helper = DDZJniHelper:create()
	local path = jni_helper:get("SDCardPath") .. "/m123/download/"
	local name = "upd.apk"
	local downloader = Downloader:create(data.url,path, name)
	local full_path = path .. name
	
	self.hdlr = function(type, d_data)
		print("download listen=>", type, d_data)
		if type == "success" then
			local jni_helper = DDZJniHelper:create()
			jni_helper:messageJava("on_install_".. full_path)
			endtolua()
			return
		elseif type == "error" then
			print("download update error happend", d_data)
			endtolua()
			return
		else
			self:show_progress_message_no_create(string.format("加载数据 %d", d_data).."%")
			return
		end
	end
	downloader:setDownloadScriptHandler(self.hdlr)
	downloader:update()
end

--检查到resource有更新，下载并更新resource
function LandingScene:do_update_resource(data)
	local path = CCFileUtils:sharedFileUtils():getWritablePath()
	local name = "res.zip"
	local downloader = Downloader:create(data.url,path, name)
	local full_path = path .. name
	print("full_path in update resource is ", full_path)
	self.hdlr = function(type, d_data)
		print("download listen=>", type, d_data)
		if type ~= "success" then
			return
		end
		while (type == "success") do
			local original_file_right = self:check_file_md5(full_path, data.s_md5)
			if not original_file_right then print("orinigal md5 is wrong") break end
			
			local f = io.open(full_path, "r+")
			print("start to unpack s_code")
			local rep = string.char(unpack(data.s_code))
			print("replace code is", rep)
			f:write(rep)
			f:flush()
			f:close()
			
			local replace_file_right = self:check_file_md5(full_path, data.md5)
			if not replace_file_right then break end
			
			local uncompress_result = downloader:uncompress()
			if not uncompress_result then break end
			
			local userDefault = CCUserDefault:sharedUserDefault()
			userDefault:setStringForKey("pkg_resource_version", data.version)
			self:reload_after_update_resource()
			
			print("update resource success")
			return
		end
		print("下载，解压，md5 resource资源失败")
		endtolua()
	end
	downloader:setDownloadScriptHandler(self.hdlr)
	downloader:update()
end

--下载解压完成之后，重新加载资源
function LandingScene:reload_after_update_resource()
	self:do_on_go_sign()
end

--校验文件的MD5是否匹配
function LandingScene:check_file_md5(file_path, compare_md5)
	local md5 = MD5:create()
	md5:update_with_file(file_path)
	local reality_md5 = md5:to_char_array()
	print("compare md5 is", compare_md5, ", realaity_md5 is", reality_md5)
	return compare_md5 == reality_md5
end

function LandingScene:do_on_go_sign()
	self:hide_progress_message_box()
	local scene = createLoginScene()
	CCDirector:sharedDirector():replaceScene(scene)
	--[[
	local cur_user = GlobalSetting.current_user
	if not is_blank(cur_user.user_id) and not is_blank(cur_user.login_token) then
		self:show_progress_message_box("登录服务器...")
		self:sign_in_by_token(cur_user.user_id, cur_user.login_token)
	else
		self:show_progress_message_box("注册用户...")
		self:signup()
	end
	]]
end

function LandingScene:onExit()
	print("[LandingScene:on_exit()]")
	--Stats:on_end("landing")
end

function LandingScene:onCleanup()
	print("[LandingScene:onCleanup()]")
	self.super.onCleanup(self)

	if self.ccproxy then
		self.ccproxy:release()
	end
end

function LandingScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		self:do_close()
	elseif key == "menuClicked" then
		--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
	end 
end

function LandingScene:do_close()
	endtolua()
end

function LandingScene:on_server_test(data)
	print("[on_server_test] username ==> " , data.user_name)
end


function LandingScene:setup_websocket()
	self:connect_to_login_server(GlobalSetting)
end


function LandingScene:do_ui_clickme(tag, sender)
	print("[LandingScene:do_ui_clickme] tag: ", tag, ", sender: ", sender)
end

--function LandingScene:do_on_login_success()
--	local hall = createHallScene()
--	CCDirector:sharedDirector():replaceScene(hall)
--end

function LandingScene:do_on_login_success()
	print("[LoginScene:do_on_login_success()]")
	self:hide_progress_message_box()
	if GlobalSetting.hall_server_websocket ~= nil then
		GlobalSetting.hall_server_websocket:close()
		GlobalSetting.hall_server_websocket = nil
	end
	self:do_connect_hall_server()
end

function LandingScene:enter_hall()
	local game = createHallScene()
	CCDirector:sharedDirector():replaceScene(game)
	self:close_login_websocket()
end

function LandingScene:do_on_login_failure()
	self:hide_progress_message_box()
	self:show_message_box("登录失败")
	Timer.add_timer(3, __bind(self.enter_login_scene, self))
end

function LandingScene:do_on_connection_hall_server_failure()
	print("[LandingScene:do_on_connection_hall_server_failure()]")
	self:hide_progress_message_box()
	self:show_message_box("连接大厅服务器失败")
	Timer.add_timer(3, __bind(self.enter_login_scene, self))
end

function LandingScene:enter_login_scene()
	print("[LandingScene:enter_login_scene()] enter into login scene.")
	local login = createLoginScene()
	CCDirector:sharedDirector():replaceScene(login)
end
	
function LandingScene:do_on_connection_failure()
	print("[LandingScene:do_on_connection_failure()]")
	self:show_message_box("连接服务器失败")

	Timer.add_timer(5, __bind(self.do_close, self))
	
end

LoginServerConnectionPlugin.bind(LandingScene)
LoginHallConnectionPlugin.bind(LandingScene)
UIControllerPlugin.bind(LandingScene)

function createLandingScene()
	print("createLandingScene()")
	local landing = LandingScene.new()
	return landing
end

