local json = require "cjson"
require "src.LoginPlugin"

RegisterScene = class("RegisterScene", function()
	print("creating new RegisterScene")
	return display.newScene("RegisterScene")
end)

function RegisterScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("RegisterScene.ccbi")
	assert(node, "failed to load Register scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	print("self.rootNode ==> ", self.rootNode)
	self:addChild(self.rootNode)
	
	local function onCancelMenuClick()
		print("go to login in register scene")
		CCDirector:sharedDirector():replaceScene(createLoginScene())	
	end
	
	self.cancel_menu = self.ccbproxy:getNodeWithType("cancel_btn", "CCMenuItemImage")
	self.cancel_menu:registerScriptTapHandler(onCancelMenuClick)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end
	
function RegisterScene:onEnter()
	print("[RegisterScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function RegisterScene:onExit()
	print("[RegisterScene:on_exit()]")
end

function RegisterScene:onCleanup()
	print("[RegisterScene:onCleanup()]")
	self.super.onCleanup(self)

	if self.ccproxy then
		self.ccproxy:release()
	end
end

function RegisterScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		print("go to login in register scene")
		local login = createLoginScene()
		CCDirector:sharedDirector():replaceScene(login)
	elseif key == "menuClicked" then
		--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
	end 
end

function RegisterScene:do_close()
	CCDirector:sharedDirector():endToLua()
end

LoginPlugin.bind(RegisterScene)

function createRegisterScene()
	print("createRegisterScene()")
	local login = RegisterScene.new()
	return login
end

