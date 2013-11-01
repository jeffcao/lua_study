local json = require "cjson"
require "RegisterScene"
require "ForgetPasswordScene"
require "HallScene"
require "src.UIControllerPlugin"
require "src.LoginServerConnectionPlugin"
require "src.LoginHallConnectionPlugin"
require "src.LoginSceneUIPlugin"
require "YesNoDialog2"
require "src.Stats"
require "src.SoundEffect"

LoginScene = class("LoginScene", function()
	print("creating new loginScene")
	return display.newScene("LoginScene")
end)

user_token_chars = "-D-D-Z--"


function LoginScene:ctor()
	
	ccb.login_scene = self
	
	self.on_ui_register_clicked = __bind(self.do_ui_register_clicked, self)
	self.on_ui_forget_pwd_btn_clicked = __bind(self.do_ui_forget_pwd_btn_clicked, self)
	self.on_ui_fast_game_clicked = __bind(self.do_ui_fast_game_clicked, self) 
	self.on_ui_login_clicked = __bind(self.do_ui_login_clicked, self)
	self.on_ui_show_ids_clicked = __bind(self.do_ui_show_ids_clicked, self)
	local function about(tag, sender)
		local scene = createAboutScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	local function help(tag, sender)
		local scene = createHelpScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	local function game_center()
		local jni = DDZJniHelper:create()
		jni:messageJava("on_open_url_intent_http://g.10086.cn")
	end
	
	self.on_help_item_clicked = help
	self.on_about_item_clicked = about
	self.on_more_item_clicked = game_center
	self.on_exit_item_clicked = __bind(self.do_close, self)
	self.on_config_item_clicked = __bind(self.show_set_dialog, self)
	
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("LoginScene.ccbi", ccbproxy, false, "")
	self:addChild(node)
	
	self:init_input_controll()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )

end

function LoginScene:show_set_dialog()
		self.set_dialog_layer = createSetDialog()
		self.rootNode:addChild(self.set_dialog_layer, 1001, 907)
		print("[HallSceneUPlugin:show_set_dialog] set_dialog_layer:show")
		self.set_dialog_layer:show()
end

	
function LoginScene:onEnter()
	print("[LoginScene:on_enter()]")
	require "sa"
	self.super.onEnter(self)
	self:playBackgroundMusic()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	if GlobalSetting.login_server_websocket == nil then
		self:show_progress_message_box("登录服务器...")
		self:connect_to_login_server(GlobalSetting)
	end
	Stats:on_start("login")
end

function LoginScene:onExit()
	print("[LoginScene:on_exit()]")
	Stats:on_end("login")
end

function LoginScene:onCleanup()
	print("[LoginScene:onCleanup()]")
	self.super.onCleanup(self)
end

function LoginScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		self:do_close()
	elseif key == "menuClicked" then
		--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
	end 
end

function LoginScene:do_close()
	endtolua_guifan()
end

UIControllerPlugin.bind(LoginScene)
LoginServerConnectionPlugin.bind(LoginScene)
LoginHallConnectionPlugin.bind(LoginScene)
LoginSceneUIPlugin.bind(LoginScene)

function createLoginScene()
	print("createLoginScene()")
	local login = LoginScene.new()
	return login
end

SoundEffect.bind(LoginScene)



