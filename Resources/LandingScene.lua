local json = require "cjson"
require "src.LoginServerConnectionPlugin"
require "LoginScene"

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
	
--	local node = self.ccbproxy:readCCBFromFile("LandingScene.ccbi")
--	assert(node, "failed to load landing scene")
--	self.rootNode = tolua.cast(node, "CCLayer")
--	print("self.rootNode ==> ", self.rootNode)
--	self:addChild(self.rootNode)
--	
--	self.sprite_loading = self.ccbproxy:getNodeWithType("sprite_loading", "CCSprite")
--	self:create_progress_animation(self.rootNode, self.sprite_loading)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end
	
function LandingScene:onEnter()
	print("[LandingScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:setup_websocket()
end

function LandingScene:do_on_websocket_ready()
	local cur_user = GlobalSetting.current_user
	if is_blank(cur_user.user_id) and is_blank(cur_user.login_token) then
		self:sign_in_by_token(cur_user.user_id, cur_user.login_token)
	else
		self:signup()
	end
end

function LandingScene:onExit()
	print("[LandingScene:on_exit()]")
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
	CCDirector:sharedDirector():endToLua()
end

function LandingScene:on_server_test(data)
	print("[on_server_test] username ==> " , data.user_name)
end


function LandingScene:setup_websocket()
	--self.websocket = WebSocketRails:new("ws://login.game.170022.cn/websocket", true)
	--self.websocket.on_open = __bind(self.do_login, self)
	self:connect_to_login_server(GlobalSetting)
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

function LandingScene:do_ui_clickme(tag, sender)
	print("[LandingScene:do_ui_clickme] tag: ", tag, ", sender: ", sender)
end

function LandingScene:do_on_login_success()
	local hall = createHallScene()
	CCDirector:sharedDirector():replaceScene(hall)
end

function LandingScene:do_on_login_failure()
	local login = createLoginScene()
	CCDirector:sharedDirector():replaceScene(login)
end

LoginServerConnectionPlugin.bind(LandingScene)

function createLandingScene()
	print("createLandingScene()")
	local landing = LandingScene.new()
	return landing
end

