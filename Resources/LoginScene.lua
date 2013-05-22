local json = require "cjson"
require "src.LoginPlugin"
require "RegisterScene"

LoginScene = class("LoginScene", function()
	print("creating new loginScene")
	return display.newScene("LoginScene")
end)

function LoginScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("LoginScene.ccbi")
	assert(node, "failed to load login scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	print("self.rootNode ==> ", self.rootNode)
	self:addChild(self.rootNode)
	
	local function onRegisterMenuClick()
		print("go to register in login scene")
		CCDirector:sharedDirector():replaceScene(createRegisterScene())	
	end
	
	self.register_menu = self.ccbproxy:getNodeWithType("register_account_btn", "CCMenuItemImage")
	self.register_menu:registerScriptTapHandler(onRegisterMenuClick)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end
	
function LoginScene:onEnter()
	print("[LoginScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function LoginScene:onExit()
	print("[LoginScene:on_exit()]")
end

function LoginScene:onCleanup()
	print("[LoginScene:onCleanup()]")
	self.super.onCleanup(self)

	if self.ccproxy then
		self.ccproxy:release()
	end
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
	CCDirector:sharedDirector():endToLua()
end

LoginPlugin.bind(LoginScene)

function createLoginScene()
	print("createLoginScene()")
	local login = LoginScene.new()
	return login
end

