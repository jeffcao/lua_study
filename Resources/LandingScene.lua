local json = require "cjson"

LandingScene = class("LandingScene", function()
	print("creating new landingScene")
	return display.newScene("LandingScene")
end)

function LandingScene:ctor()
	self.websocket = nil;
	
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("LandingScene.ccbi")
	assert(node, "failed to load landing scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	print("self.rootNode ==> ", self.rootNode)
	self:addChild(self.rootNode)
	
	self.sprite_loading = self.ccbproxy:getNodeWithType("sprite_loading", "CCSprite")
	self:create_progress_animation(self.rootNode, self.sprite_loading)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end
	
function LandingScene:onEnter()
	print("[LandingScene:on_enter()]")
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:setup_websocket()
end

function LandingScene:onExit()
	print("[LandingScene:on_exit()]")
	if self.ccproxy then
		self.ccproxy:release()
	end
	if self.websocket then
		self.websocket:close()
	end
end

function LandingScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		self:do_close()
	elseif key == "menuClicked" then
		print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
	end 
end

function LandingScene:do_close()
	CCDirector:sharedDirector():endToLua()
end

function LandingScene:sign_success(data)
	print("[sign_success] updating local user info.")
	local userDefault = CCUserDefault:sharedUserDefault()
	userDefault:setStringForKey("user.user_id", data.user_id)
	userDefault:setStringForKey("user.token", data.token)
end

function LandingScene:sign_failure(data)
	print("[sign_failure] ")
end

function LandingScene:do_signup()
	local new_event = {}
	new_event.sign_type = "100"
	
	self.websocket:trigger("login.sign_up", {retry="0", sign_type="100"} , 
		__bind(self.sign_success, self), 
		__bind(self.sign_failure, self) )
end

function LandingScene:on_server_test(data)
	print("[on_server_test] username ==> " , data.user_name)
end

function LandingScene:do_login(event)
	print(string.format("[do_login] event: %s", json.encode(event) ))
	print(string.format("[do_login] connection_id: %d", event.connection_id))
	if not self.websocket.already_bound then
		self.websocket:bind("server_test", on_server_test)
		self.websocket.already_bound = true
	end
	
	local userDefault = CCUserDefault:sharedUserDefault()
	local user_id = userDefault:getStringForKey("user.user_id")
	local user_token = userDefault:getStringForKey("user.token")
	
	print(string.format("user_id => [%s], user_token => [%s]", user_id, user_token))
	
	if user_id == "" or user_token == "" then
		do_signup()
		return
	end
	
	-- fast login
	local event_data = {retry="0", login_type="102", user_id = user_id, token = user_token, version="1.0"}
	
	self.websocket:trigger("login.sign_in", event_data, 
		__bind(self.sign_success, self), 
		function(data) 
			print("login failed, try to sign up")
			self:do_signup()
		end )
	
end

function LandingScene:setup_websocket()
	self.websocket = WebSocketRails:new("ws://login.game.170022.cn/websocket", true)
	self.websocket.on_open = __bind(self.do_login, self)
end

function LandingScene:create_progress_animation(layer, sprite)
	local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
	if frameCache == nil then
		print("frame cache is null")
	end
	
	local animationCache = CCAnimationCache:sharedAnimationCache()
	--frameCache:addSpriteFramesWithFile("ccbResources/landing.plist")
	local frames = CCArray:create()
	for i=1, 10 do
		local image_file = string.format("load%02d.png", i)
		print(image_file)
		local frame = frameCache:spriteFrameByName(image_file)
		if frame == nil then
			print("frame should not be nil")
		end
		frames:addObject(frame)		
	end
	
	local anim = CCAnimation:createWithSpriteFrames(frames, 0.05);
	animationCache:addAnimation(anim, "progress")
	
	local animate = CCAnimate:create(anim)
	sprite:runAction( CCRepeatForever:create(animate) )
	
end


function createLandingScene()
	print("createLandingScene()")
	local landing = LandingScene.new()
	--landing:init()
	local scene = landing
	--local scene = CCScene:create()
	--print ("landing.rootNode ==> " , landing.rootNode)
	--scene:addChild(landing.rootNode)
	--scene:retain()
	return scene
end
