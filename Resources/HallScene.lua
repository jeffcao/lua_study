require "src.HallSceneUPlugin"
require "src.HallServerConnectionPlugin"
require "src.HallGameConnectionPlugin"
require "src.UIControllerPlugin"
require "src.ConnectivityPlugin"
require "src.SocketStatePlugin"
require "src/WebsocketRails/Timer"
require "RoomItem"
require "Menu"
require "src.WidgetPlugin"
require "src.SoundEffect"
require "Share"
require "TimeTask"

HallScene = class("HallScene", function() 
	print("create new hall scene")
	return display.newScene("HallScene")
	end
 )
 
 function createHallScene()
 	print("createHallScene()")
 	return HallScene.new()
 end
 
 function HallScene:ctor()
 	
	ccb.hall_scene = self
	
	self.on_menu_clicked = __bind(self.onMenuClick, self)
	self.on_info_btn_clicked = __bind(self.onInfoClick, self)
	self.on_avatar_btn_clicked = __bind(self.onAvatarClick, self) 
	self.on_market_btn_clicked = __bind(self.onMarketClick, self)
	self.on_ui_quick_game_btn_clicked = __bind(self.do_quick_game_btn_clicked, self)
	self.on_ui_feedback_btn_clicked = __bind(self.do_ui_feedback_btn_clicked, self)
	self.on_ui_prop_btn_clicked = __bind(self.do_ui_prop_btn_clicked, self)
	self.on_ui_share_btn_clicked = __bind(self.onShareClick, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("HallScene.ccbi", ccbproxy, false, "")
 	self.rootNode = node
	self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.avatar_btn:setScale(GlobalSetting.content_scale_factor * 0.6)
	self.avatar_bg:setScale(GlobalSetting.content_scale_factor * 0.9)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(__bind(self.onKeypad, self))
	

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.common_plist)
	
	self.socket_label = tolua.cast(self.socket_label, "CCLabelTTF")
	
	self:init_connectivity()
	
	self.music_update = Timer.add_repeat_timer(30, __bind(self.playMusic, self))
	
	
	
 end
 

 
 function HallScene:init()
 	print("HallScene:init()")
 end
 
 function HallScene:onEnter() 
	print("HallScene:onEnter()")
	self.super.onEnter(self)
	self:updateTimeTask()
	self:do_on_enter()
	local is_playing = SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying()
	if SoundSettings.bg_music and not is_playing then
		self:playBackgroundMusic()
	end
 end
 
 function HallScene:playMusic()
 	print("playMusic")
 	if not SoundSettings.bg_music then return true end
 	local running_scene = CCDirector:sharedDirector():getRunningScene()
	if running_scene == self then 
 		self:playBackgroundMusic()
 	end
 	return true
 end
 
 function HallScene:onExit()
 	print("HallScene:onExit()")
 	
 end
 
 function HallScene:onCleanup()
	print("[HallScene:onCleanup()]")
	self.super.onCleanup(self)
	Timer.cancel_timer(self.music_update)
end
 
 function HallScene:onEnterTransitionDidFinish()
 	print("HallScene:onEnterTransitionDidFinish()")
 end
 
 HallSceneUPlugin.bind(HallScene)
 WidgetPlugin.bind(HallScene)
 HallServerConnectionPlugin.bind(HallScene)
 HallGameConnectionPlugin.bind(HallScene)
 UIControllerPlugin.bind(HallScene)
 ConnectivityPlugin.bind(HallScene)
 SocketStatePlugin.bind(HallScene)
 SoundEffect.bind(HallScene)