-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

LUA_DEBUG = false



print("package.path ==> " .. package.path)

CONFIG_SCREEN_WIDTH = 800
CONFIG_SCREEN_HEIGHT = 480


local function load_requires()
require "Version"
require("src/WebsocketRails/WebSocketRails")
require "src/WebsocketRails/WebSocketRails_Event"
require "src/WebsocketRails/WebSocketRails_Connection"
require "src/WebsocketRails/WebSocketRails_Connection_CC"
require "src/WebsocketRails/WebSocketRails_Channel"
require "src.WebsocketRails.Timer"
require "src.strings"
require "src.Scale9Funcs"
--require "framework.init"
--require "framework.client.init"
require "src.GlobalSetting"
require "src.UserInfo"
require "src.GlobalFunction"
require "src.NotificationProxy"
--require "src.functions"
require "LandingScene"
require "GamingScene"
require "src.resources"
require "CCBReaderLoad"
require "GuifanStartScene"
require "GuifanEndScene"
end

local json = require "cjson"


function __bind(fn, obj)
	return function(...) 
		return fn(obj, ...) 
	end
end

function init_modules()
end

function on_GlobalSetting_reload()
	GlobalSetting.user_info = UserInfo:new()
	local size = CCDirector:sharedDirector():getWinSize()
	local contentScaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.content_scale_factor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.current_user = UserInfo:new():load(CCUserDefault:sharedUserDefault())
end

function on_WebSocketRails_reload()
	WebSocketRails.config = GlobalSetting
	package.loaded["src/WebsocketRails/WebSocketRails_Event"] = nil
	require "src/WebsocketRails/WebSocketRails_Event"
	package.loaded["src/WebsocketRails/WebSocketRails_Connection"] = nil
	require "src/WebsocketRails/WebSocketRails_Connection"
	package.loaded["src/WebsocketRails/WebSocketRails_Connection_CC"] = nil
	require "src/WebsocketRails/WebSocketRails_Connection_CC"
	package.loaded["src/WebsocketRails/WebSocketRails_Channel"] = nil
	require "src/WebsocketRails/WebSocketRails_Channel"
end

function on_Timer_reload()
	Timer.scheduler = CCDirector:sharedDirector():getScheduler()
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    require "framework.init"
	require "framework.client.init"
	
	local user_default = CCUserDefault:sharedUserDefault()
	local dbg = user_default:getStringForKey("debug")
	if dbg and dbg == "true" then LUA_DEBUG = true end

    old_print = print
    old_echo = echoInfo
    old_dump = dump
	echoInfo = function(...)
		if not LUA_DEBUG then return end
		old_echo(...)
	end
	print = function(...)
		if not LUA_DEBUG then return end
		old_print(...)
	end
	cclog = function(...)
    	print(string.format(...))
	end
	dump = function(...)
		if not LUA_DEBUG then return end
		old_dump(...)
	end
    
    print("package.path ==> " .. package.path)

	--local path = CCFileUtils:sharedFileUtils():getWritablePath()
	--package.path = path.."?.lua;" .. path.."?.lo;" .. path.."resources/?.lua;" .. path.."resources/?.lo;" ..package.path
	--package.path = package.path .. ";" ..path.."?.lua;" .. path.."?.lo;" .. path.."resources/?.lua;" .. path.."resources/?.lo;"
	--package.path = path.."resources/?.lua"
	--print("package.path ==> " .. package.path)
	
	load_requires()

	Timer.scheduler = CCDirector:sharedDirector():getScheduler()

	GlobalSetting.app_id = user_default:getStringForKey("appid")
	GlobalSetting.user_info = UserInfo:new()
	WebSocketRails.config = GlobalSetting

	local size = CCDirector:sharedDirector():getWinSize()
	local contentScaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.content_scale_factor = CCDirector:sharedDirector():getContentScaleFactor()
	GlobalSetting.current_user = UserInfo:new():load(CCUserDefault:sharedUserDefault())
	--dump(GlobalSetting, "GlobalSetting")
	cclog(string.format("size.width: %d, size.height: %d;  contentScaleFactor: %f", size.width, size.height, contentScaleFactor))
	
	CCEGLView:sharedOpenGLView():setDesignResolutionSize(800, 480, kResolutionExactFit)

	local game_test = function()
		local lg = WebSocketRails:new("ws://login.test.170022.cn:8080/websocket", true)
		lg.on_open = function() print("lg on open") end
		local event_data = {retry="0", login_type="103", user_id = "10004", password = "12345678"}
		local fn = function(data) 
			GlobalSetting.current_user:load_from_json(data.user_profile)
			local cur_user = GlobalSetting.current_user
			--cur_user.user_id = data.user_id
			cur_user.login_token = data.token
			local url = "ws://" .. data.url[1] .. "/websocket"
			local hl = WebSocketRails:new(url, true)
			hl.on_open = function()
				local oauth = {retry = "0", token = cur_user.login_token, user_id = "10004"}
				local oauth_fn = function(data)
					lg:close()
					print("hall on open")
					local get_room = {retry = "0", user_id = "10004"}
					local fnc = function(data) 
						print("get_room succ") 
						local go_game_fn = function(data2)
							print("go_game_fn")
							local url2 = data2.urls[1]
							local gw = WebSocketRails:new(url2, true)
							local gw_oauth_fn = function()
								hl:close()
								print("gw_oauth_fn")
								GlobalSetting.game_info = data2
								dump(data2, 'game_info')
								GlobalSetting.g_WebSocket = gw
								local ls = createGamingScene()
								CCDirector:sharedDirector():runWithScene(ls)
							end
							local gw_oauth_fail = function()
								print("open game socket oauth fail")
							end
							gw.on_open = function()
								print("gw.on_open")
								gw:trigger("g.check_connection", oauth, gw_oauth_fn, gw_oauth_fail)
							end
							local on_close = function(data)
								print("gw.on_close")
								if data then dump(data, "data is") else print("data is nil") end
							end
							local on_error = function(data)
								print("gw.on_error")
								if data then dump(data, "data is") else print("data is nil") end
							end
							gw:bind("connection_closed", on_close)
							gw:bind("connection_error", on_error)
						end
						local go_game = {retry = "0", user_id = "10004", room_id = data.room[1].room_id}
						hl:trigger("ui.request_enter_room", go_game, go_game_fn)
					end
					hl:trigger("ui.get_room", get_room, fnc, fnc)
					
				end
				hl:trigger("ui.check_connection", oauth, oauth_fn)
			end
		end
		lg:trigger("login.sign_in",  event_data, fn, fn)
	end
--	game_test()

--	local ls = createLandingScene()
	CCDirector:sharedDirector():setDisplayStats(false)
	local ls = createGuifanStartScene()
	CCDirector:sharedDirector():runWithScene(ls)
	
	local notify_center = CCNotificationCenter:sharedNotificationCenter()
	local node = display.newSprite()
	local events = {"on_resume", "on_pause", "on_network_change_disable", "on_network_change_available", "set_user_balance"}
	for _,event in pairs(events) do
		notify_center:registerScriptObserver(node, NotificationProxy.on_event, event)
	end
	
	local audio = SimpleAudioEngine:sharedEngine()
	
	audio:setBackgroundMusicVolume(1)
	audio:setEffectsVolume(1)
	
	
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
