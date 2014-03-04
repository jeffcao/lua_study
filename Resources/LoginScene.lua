local json = require "cjson"
require "RegisterScene"
require "ForgetPasswordScene"
require "HallScene"
require "src.UIControllerPlugin"
require "src.LoginServerConnectionPlugin"
require "src.LoginHallConnectionPlugin"
require "src.LoginSceneUIPlugin"
require "src.Stats"
require "src.SoundEffect"
require "src.UserLocked"
require 'src.GamePush'
require 'src.MarqueePlugin'
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
	
	self:setMenus()
	
	set_bg(self)
	self:init_input_controll()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	set_blue_stroke(self.login_btn_lbl)
	set_blue_stroke(self.kuaisu_login_btn_lbl)
	set_light_blue_stroke(self.forget_password_btn_lbl)
	set_light_blue_stroke(self.register_account_btn_lbl)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end

function set_bg(scene)
	local bg = GlobalSetting.login_bg[GlobalSetting.app_id]
	if bg then
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		cache:addSpriteFramesWithFile(bg.res)
		scene.bg_sprite:setDisplayFrame(cache:spriteFrameByName(bg.name))
	end
end

function LoginScene:setMenus()
	local pay_type = GlobalSetting.pay_type[GlobalSetting.app_id] or GlobalSetting.pay_type["default"]
	if pay_type == 'anzhi' then
		self.help:setPosition(ccp(36,30))
		self.about:setPosition(ccp(186,30))
		self.more:setVisible(false)
		self.switch:setPosition(ccp(340,30))
	elseif pay_type == 'cmcc' then
		self.help:setPosition(ccp(36,30))
		self.about:setPosition(ccp(186,30))
		self.more:setVisible(true)
		self.more:setPosition(ccp(340,30))
		self.switch:setPosition(ccp(483,30))
	end
end

function LoginScene:show_set_dialog()
		self.set_dialog_layer = createSetDialog()
		self.rootNode:addChild(self.set_dialog_layer, 1001, 907)
		print("[HallSceneUPlugin:show_set_dialog] set_dialog_layer:show")
		self.set_dialog_layer:show()
end

	
function LoginScene:onEnter()
	print("[LoginScene:on_enter()]")
	--require "sa"
	self.super.onEnter(self)
	GamePush.close()
	self:playBackgroundMusic()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	if GlobalSetting.login_server_websocket == nil then
		self:show_progress_message_box(strings.lgs_login_server_ing)
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
	if hasDialogFloating(self) then print("login scene there is dialog floating") return end
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
UserLocked.bind(LoginScene)


