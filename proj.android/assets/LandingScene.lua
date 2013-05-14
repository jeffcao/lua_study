
LandingScene = class("LandingScene", function()
	print("creating new landingScene")
	return display.newScene("LandingScene")
end)

function LandingScene:ctor()
	self.ccproxy = nil
	self.rootNode = nil
end
	
function LandingScene:init()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	local node = self.ccbproxy:readCCBFromFile("LandingScene.ccbi")
	assert(node, "failed to load landing scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	print("self.rootNode ==> ", self.rootNode)
	--self:addChild(self.rootNode)
	--self.rootNode:registerScriptHandler(function(event) LandingScene.onNodeEvent(self, event) end)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( function(key) self:on_keypad_pressed(key) end )
	
	return true
end

	

function LandingScene:onEnter()
	print("[LandingScene:on_enter()]")
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function LandingScene:onExit()
	print("[LandingScene:on_exit()]")
	if self.ccproxy then
		self.ccproxy:release()
	end
end

function LandingScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		self:do_close()
	elseif key == "menuClicked" then
		--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(login_websocket._conn._websocket_id) )
	end 
end

function LandingScene:do_close()
	CCDirector:sharedDirector():endToLua()
end

function createLandingScene()
	print("createLandingScene()")
	local landing = LandingScene.new()
	landing:init()
	local scene = landing
	--local scene = CCScene:create()
	--print ("landing.rootNode ==> " , landing.rootNode)
	scene:addChild(landing.rootNode)
	--scene:retain()
	return scene
end
