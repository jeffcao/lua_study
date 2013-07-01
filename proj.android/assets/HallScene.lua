require "src.HallSceneUPlugin"
require "src.HallServerConnectionPlugin"
require "src.HallGameConnectionPlugin"
require "src.UIControllerPlugin"
require "src.ConnectivityPlugin"
require "src.SocketStatePlugin"
require "RoomItem"
require "Menu"
require "src.WidgetPlugin"



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
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("HallScene.ccbi", ccbproxy, false, "")
	self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.avatar_btn:setScale(GlobalSetting.content_scale_factor * 0.45)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(__bind(self.onKeypad, self))
	

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.common_plist)
	
	self.socket_label = tolua.cast(self.socket_label, "CCLabelTTF")
	
	self:init_connectivity()
		
 end
 

 
 function HallScene:init()
 	print("HallScene:init()")
 end
 
 function HallScene:onEnter() 
	print("HallScene:onEnter()")
	self.super.onEnter(self)
	self:do_on_enter()
 end
 
 function HallScene:onExit()
 	print("HallScene:onExit()")
 end
 
 function HallScene:onCleanup()
	print("[HallScene:onCleanup()]")
	self.super.onCleanup(self)

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
 