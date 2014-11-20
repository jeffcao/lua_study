local json = require "cjson"
require "src.UIControllerPlugin"
require "src.RegisterSceneUIPlugin"
require "src.Stats"
require "src.UserLocked"
require 'src.SceneEventPlugin'

RegisterScene = class("RegisterScene", function()
	print("creating new RegisterScene")
	return display.newScene("RegisterScene")
end)

function RegisterScene:ctor()

	ccb.register_scene = self
	self.on_cancel_btn_clicked =  __bind(self.do_cancel_btn_clicked, self)
	self.on_register_btn_clicked = __bind(self.do_register_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("RegisterScene.ccbi", ccbproxy, false, "")
	self:addChild(node)
	
	
	set_anniu_1_3_stroke(self.register_btn_lbl)
	set_anniu_1_3_stroke(self.cancel_btn_lbl)
	
	set_bg(self)
	self:init_input_controller()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end


	
function RegisterScene:onEnter()
	print("[RegisterScene:on_enter()]")
	-- self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	if GlobalSetting.login_server_websocket == nil then
		self:show_progress_message_box(strings.rs_connect_server_ing)
		self:connect_to_login_server(GlobalSetting)
	end
	Stats:on_start("register")
end

function RegisterScene:onExit()
	print("[RegisterScene:on_exit()]")
	Stats:on_end("register")
end

function RegisterScene:onCleanup()
	print("[RegisterScene:onCleanup()]")
	-- self.super.onCleanup(self)
	self:close_login_websocket()
end

function RegisterScene:do_close()
	endtolua()
end

UIControllerPlugin.bind(RegisterScene)
LoginServerConnectionPlugin.bind(RegisterScene)
LoginHallConnectionPlugin.bind(RegisterScene)
RegisterSceneUIPlugin.bind(RegisterScene)
UserLocked.bind(RegisterScene)
SceneEventPlugin.bind(RegisterScene)
function createRegisterScene()
	print("createRegisterScene()")
	local login = RegisterScene.new()
	return login
end

