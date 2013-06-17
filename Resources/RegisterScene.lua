local json = require "cjson"
require "src.UIControllerPlugin"
require "src.RegisterSceneUIPlugin"

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
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:init_input_controller()

	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end


	
function RegisterScene:onEnter()
	print("[RegisterScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	if GlobalSetting.login_server_websocket == nil then
		self:show_progress_message_box("连接服务器...")
		self:connect_to_login_server(GlobalSetting)
	end
end

function RegisterScene:onExit()
	print("[RegisterScene:on_exit()]")
end

function RegisterScene:onCleanup()
	print("[RegisterScene:onCleanup()]")
	self.super.onCleanup(self)

end

function RegisterScene:do_close()
	CCDirector:sharedDirector():endToLua()
end

UIControllerPlugin.bind(RegisterScene)
LoginServerConnectionPlugin.bind(RegisterScene)
RegisterSceneUIPlugin.bind(RegisterScene)

function createRegisterScene()
	print("createRegisterScene()")
	local login = RegisterScene.new()
	return login
end

