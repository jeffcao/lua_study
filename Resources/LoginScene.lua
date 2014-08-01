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
	self.scene_name = 'LoginScene'
	
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
		jni:messageJava("do_cmcc_more_game")
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
	
	set_anniu6_stroke(self.login_btn_lbl)
	set_anniu5_stroke(self.kuaisu_login_btn_lbl)
	set_anniu_1_3_stroke(self.forget_password_btn_lbl)
	set_anniu_1_3_stroke(self.register_account_btn_lbl)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end

function set_bg(scene)
	local res, name
	local function setbg()
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		cache:addSpriteFramesWithFile(res)
		scene.sp_game_name:setDisplayFrame(cache:spriteFrameByName(name))
	end
	local pay_type = getPayType()
	if pay_type == 'anzhi' then
		res = 'ccbResources/ui_wenzi.plist'
		name = 'wenzi_fuxingdoudizhu.png'
		setbg()
	elseif pay_type == 'sikai' or pay_type == 'mili' or pay_type == 'miliuu' or pay_type == 'letu' then
		res = 'ccbResources/ui_wenzi.plist'
		name = 'wenzi_quanmingdoudizhu.png'
		setbg()
	end
end

function LoginScene:setMenus()
	--local pay_type = GlobalSetting.pay_type[GlobalSetting.app_id] or GlobalSetting.pay_type["default"]
	local pay_type = getPayType()
	if pay_type == 'cmcc' then
		self.help:setPosition(ccp(36,30))
		self.about:setPosition(ccp(186,30))
		self.more:setVisible(true)
		self.more:setPosition(ccp(340,30))
		self.switch:setPosition(ccp(483,30))
	else--anzhi, leyifu
		self.help:setPosition(ccp(105,30))
		self.about:setPosition(ccp(255,30))
		self.more:setVisible(false)
		self.switch:setPosition(ccp(405,30))
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
	self:initMusic()
	self:playBackgroundMusic()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	if GlobalSetting.login_server_websocket == nil then
		self:show_progress_message_box(strings.lgs_login_server_ing)
		self:connect_to_login_server(GlobalSetting)
	end
	Stats:on_start("login")
end

function LoginScene:initMusic()
	local jni = DDZJniHelper:create()
	local user_default = CCUserDefault:sharedUserDefault()
	local do_effect = function(bg_open, effect_open)
		print('initMusic,bg,effect:', bg_open, effect_open)
		if bg_open then
			jni:messageJava("set_music_volume_" .. user_default:getFloatForKey("music_volume"))
		end
		effect_music = effect_open
		bg_music = bg_open
	end
	if getPayType() == 'cmcc' then
		local music_state = jni:get("MusicEnabled")
		print("music_state=> ", music_state, string.len(music_state))
		do_effect(music_state=="1", music_state=="1")
	else
		print('initMusic not cmcc')
		do_effect(not user_default:getBoolForKey("bg_music"), not user_default:getBoolForKey("effect_music"))
	end
end

function LoginScene:onExit()
	print("[LoginScene:on_exit()]")
	Stats:on_end("login")
end

function LoginScene:onCleanup()
	print("[LoginScene:onCleanup()]")
	NotificationProxy.removeObservers(self.scene_name)
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
 SceneEventPlugin.bind(LoginScene)

