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


function __bind(fn, obj)
	return function(...) fn(obj, ...) end
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    load_requires()

    local cclog = function(...)
        print(string.format(...))
    end
    
	Timer.scheduler = CCDirector:sharedDirector():getScheduler()

	GlobalSetting.user_info = UserInfo:new()
	WebSocketRails.config = GlobalSetting

	cclog("aaaaa")
	local size = CCDirector:sharedDirector():getWinSize()
	local contentScaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.content_scale_factor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.currrent_user = UserInfo:new():load(CCUserDefault:sharedUserDefault())
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
