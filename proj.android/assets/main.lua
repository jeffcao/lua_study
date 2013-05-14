-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

print("package.path ==> " .. package.path)

CONFIG_SCREEN_WIDTH = 800
CONFIG_SCREEN_HEIGHT = 480

local function load_requires()
require("src/WebsocketRails/WebSocketRails")
require "src/WebsocketRails/WebSocketRails_Event"
require "src/WebsocketRails/WebSocketRails_Connection"
require "src/WebsocketRails/WebSocketRails_Channel"
require "src.WebsocketRails.Timer"
require "framework.init"
require "framework.client.init"
require "src.GlobalSetting"
require "src.UserInfo"
require "src.GlobalFunction"
--require "src.functions"
require "LandingScene"
end

local json = require "cjson"

login_websocket = nil

local function __bind(fn, obj)
    return function(event) fn(obj, event) end
end


local function connect_websocket()
	local websocket_id = 0
	local function on_message(message)
		print("[on_message] [socket_id: " .. websocket_id .. "] message => " .. message)
	end
	
	local function on_open(message)
		print("[on_open] [socket_id: " .. websocket_id .. "] message => " .. message)
	end
	
	local function on_close(message)
		print("[on_close] [socket_id: " .. websocket_id .. "] message => " .. message)
	end
	
	local function on_error(message)
		print("[on_error] [socket_id: " .. websocket_id .. "] message => " .. message)
	end
	
	print("start to connect socket....")
	local socketManager = WebsocketManager:sharedWebsocketManager()
	websocket_id = socketManager:connect("ws://192.168.9.165/websocket", on_open, on_close, on_message, on_error )
	print("websocket_id => " .. websocket_id)
	
	return websocket_id
end

local function sign_success(data)
	print("[sign_success] updating local user info.")
	local userDefault = CCUserDefault:sharedUserDefault()
	userDefault:setStringForKey("user.user_id", data.user_id)
	userDefault:setStringForKey("user.token", data.token)
end

local function sign_failure(data)
	print("[sign_failure] ")
end

local function do_signup()
	local new_event = {}
	new_event.sign_type = "100"
	
	login_websocket:trigger("login.sign_up", {retry="0", sign_type="100"} , sign_success, sign_failure )
end

local function on_server_test(data)
	print("[on_server_test] username ==> " , data.user_name)
end

local function do_login(event)
	print(string.format("[do_login] event: %s", json.encode(event) ))
	print(string.format("[do_login] connection_id: %d", event.connection_id))
	if not login_websocket.already_bound then
		login_websocket:bind("server_test", on_server_test)
		login_websocket.already_bound = true
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
	
	login_websocket:trigger("login.sign_in", event_data, sign_success, function(data) 
			print("login failed, try to sign up")
			do_signup()
		end )
	
end

local function init_websocket()
	login_websocket = WebSocketRails:new("ws://login.game.170022.cn/websocket", true)
	login_websocket.on_open = function(event) do_login(event) end 
end


local function create_progress_animation(layer, sprite)
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

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    load_requires()

    local cclog = function(...)
        print(string.format(...))
    end

	GlobalSetting.user_info = UserInfo:new()
	WebSocketRails.config = GlobalSetting

	cclog("aaaaa")
	local size = CCDirector:sharedDirector():getWinSize()
	local contentScaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.content_scale_factor = CCDirector:sharedDirector():getContentScaleFactor()
	cclog(string.format("size.width: %d, size.height: %d;  contentScaleFactor: %f", size.width, size.height, contentScaleFactor))
	
	CCEGLView:sharedOpenGLView():setDesignResolutionSize(800, 480, kResolutionExactFit)
	
	local ls = createLandingScene()
	CCDirector:sharedDirector():runWithScene(ls)
	
--	return true
--	
--	local proxy = CCBProxy:create()
--	
--	local landing_scene = CCScene:create();
--	local node = proxy:readCCBFromFile("LandingScene.ccbi")
--	local layer = tolua.cast(node, "CCLayer")
--	scaleNode(layer, contentScaleFactor)
--	
--	local function onNodeEvent(event)
--		print("[onNodeEvent] event => ", event)
--	end
--	
--	--layer:registerScriptHandler(onNodeEvent)
--	landing_scene:registerScriptHandler(onNodeEvent)
--	
--	--layer:setScale(size.width / 800);
--	--local layer = node
--	landing_scene:addChild(layer)
--	
--	local function on_close()
--		CCDirector:sharedDirector():endToLua()
--	end
--	
--	local rs = 0
--	
--	local rs_def = {"kResolutionExactFit", "kResolutionNoBorder", "kResolutionShowAll", "kResolutionFixedHeight", "kResolutionFixedWidth"}
--	local label_new_one = nil
--	label_new_one = proxy:getNodeWithType("label_new_one", "CCLabelTTF")
--	local function on_rs()
--		CCEGLView:sharedOpenGLView():setDesignResolutionSize(800, 480, rs)
--		label_new_one:setString(rs_def[rs+1])
--		rs = (rs + 1) % 5 
--	end
--	
--	layer:setKeypadEnabled(true)
--	layer:registerScriptKeypadHandler( function(key)
--			print("on keypad clicked: " .. key)
--			if key == "backClicked" then
--				on_close()
--			elseif key == "menuClicked" then
--				print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(login_websocket._conn._websocket_id) )
--			end 
--		end )
--
--	
--	
--	local button = proxy:getNode("menu_item_close", "CCMenuItemImage")
--	
--	--print("get button..." .. button)
--	if button == nil then
--		print("button is nil")
--	else
--		proxy:handleMenuEvent(button, function()
--			login_websocket._conn:close(false)
--			--login_websocket:close()
--		end)
--	end
--	
--	local rs_button = proxy:getNode("menu_item_rs")
--	proxy:handleMenuEvent(rs_button, on_rs )
--	
--	local layer_progress = proxy:getNodeWithType("layer_progress", "CCLayer")
--	
--	local sprite_loading = proxy:getNodeWithType("sprite_loading", "CCSprite")
--	
--	if (sprite_loading == nil) then
--		print("sprite_loading is nil")
--	end
--	
--	create_progress_animation(layer_progress, sprite_loading)
--	
--	CCDirector:sharedDirector():runWithScene(landing_scene)
--	
--	fn = function()
--		print ("schedule callback!")
--	end
--	
--	Timer.scheduler = CCDirector:sharedDirector():getScheduler()
--	
--	Timer.add_timer(2, fn)
--	
--	init_websocket()
	
	
--	local scene = CCScene:create()
--	
--	local layer = CCLayer:create()
--	
--	local function on_close()
--		CCDirector:sharedDirector():endToLua()
--	end
--	
--	
--	local closeMenuItem = CCMenuItemImage:create("CloseNormal.png", "CloseSelected.png")
--	closeMenuItem:setPosition( ccp(size.width - 20, 20 )  )
--	
--	local connectMenuItem = CCMenuItemImage:create("btn_bujiao.png", "btn_bujiao_b.png")
--	connectMenuItem:setPosition( ccp(200, 30) )
--	
--	local menu = CCMenu:create()
--	menu:setPosition(ccp(0,0))
--	menu:addChild(closeMenuItem)
--	menu:addChild(connectMenuItem)
--	
--	layer:addChild(menu, 1)
--	
--	closeMenuItem:registerScriptTapHandler(on_close)
--	connectMenuItem:registerScriptTapHandler(connect_websocket)
--	
--	local sprite = CCSprite:create("HelloWorld.png");
--	sprite:setPosition( ccp(size.width/2, size.height/2) )
--	layer:addChild(sprite, 0);
--	
--	scene:addChild(layer)
--	
--	
--	CCDirector:sharedDirector():runWithScene(scene)
--	

end

xpcall(main, __G__TRACKBACK__)
