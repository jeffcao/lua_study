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
require "IntroduceDialog"
require "src.ServerNotifyPlugin"
require "src.Stats"
require "src.Push"
require "src.UserLocked"
require 'src.GamePush'
require 'src.MarqueePlugin'
require 'src.HallMatchPlugin'
require 'src.MatchLogic'
require 'src.KickOut'
require 'src.PurchasePlugin'
require 'CCBReaderLoadX'


require 'hall.HallPluginBinder'

local cjson = require "cjson"
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
 	self.scene_name = 'HallScene'
	ccb.hall_scene = self
	
	self.on_menu_clicked = __bind(self.onMenuClick, self)
	self.on_info_btn_clicked = __bind(self.onInfoClick, self)
	self.on_avatar_btn_clicked = __bind(self.onAvatarClick, self) 
	self.on_market_btn_clicked = __bind(self.onMarketClick, self)
	self.on_ui_quick_game_btn_clicked = __bind(self.do_quick_game_btn_clicked, self)
	self.on_ui_feedback_btn_clicked = __bind(self.do_ui_feedback_btn_clicked, self)
	self.on_ui_prop_btn_clicked = __bind(self.do_ui_prop_btn_clicked, self)
	self.on_ui_promotion_btn_clicked = __bind(self.do_ui_promotion_btn_clicked, self)
	self.on_task_btn_clicked = __bind(self.do_on_task_btn_clicked, self)
	self.on_vip_clicked = __bind(self.on_vip_click, self)
	self.on_rank_btn_clicked = __bind(self.getRank, self)
	self.on_shouchonglibao_clicked = __bind(self.on_shouchong_click, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBuilderReaderLoad("HallScene.ccbi", ccbproxy)
 	self.rootNode = node
	self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.avatar_btn:setScale(GlobalSetting.content_scale_factor * 0.6)
	self.avatar_bg:setScale(GlobalSetting.content_scale_factor * 0.55)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:addNodeEventListener(cc.KEYPAD_EVENT, __bind(self.onKeypad, self))
	

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.common_plist)
	
	self.socket_label = tolua.cast(self.socket_label, "CCLabelTTF")
	
	self:init_connectivity()
	
	self.music_update = Timer.add_repeat_timer(30, __bind(self.playMusic, self))
	
	self.btn_stroke_color = GlobalSetting.zongse
	self.btn_stroke_size = 2.5
--	self:set_btn_stroke(self.to_info_lbl)
--	self:set_btn_stroke(self.to_feedback_lbl)
--	self:set_btn_stroke(self.task_lbl)
	set_anniu5_stroke(self.quick_game_btn_lbl)
	MarqueePlugin.addMarquee(self.rootNode,ccp(280,380))
	GlobalSetting.hall_scene = self
	print('listen on_bill_cancel')
	NotificationProxy.registerScriptObserver(PurchasePlugin.on_bill_cancel,"on_bill_cancel", self.scene_name)
	
	print('listen on_mili_success')
	NotificationProxy.registerScriptObserver(PurchasePlugin.on_mili_success,"on_mili_success", self.scene_name)
	
	print('listen on_miliuu_success')
	NotificationProxy.registerScriptObserver(PurchasePlugin.on_miliuu_success,"on_miliuu_success", self.scene_name)
	
	print('listen on_letu_success')
	NotificationProxy.registerScriptObserver(PurchasePlugin.on_letu_success,"on_letu_success", self.scene_name)
 
 	require 'ui.UIUtil'
 	local winSize = CCDirector:sharedDirector():getWinSize()
 	local sprite = UIUtil.getRepeatSprite(winSize.width, winSize.height)
 	sprite:setPosition(ccp(winSize.width/2,winSize.height/2))
 	self.back_bg_layer:addChild(sprite)
 end
 
 function HallScene:check_kick_out()
 	local reason = KickOut.check()
 	if not reason then return end
 	if reason == 'match_end' then
 		ToastPlugin.show_message_box_suc(strings.hs_match_end)
 	end
 end
 
 function HallScene:set_btn_stroke(btn_lbl)
	set_stroke(btn_lbl, self.btn_stroke_size, self.btn_stroke_color)
 end
 
 function HallScene:init()
 	print("HallScene:init()")
 end
 
 function HallScene:onEnter() 
	print("HallScene:onEnter()")
	GlobalSetting.player_game_position = 2
	--self.super.onEnter(self)
	GamePush.open()
	
	self:updateTimeTask()
	self:update_player_beans_with_gl()
	self:do_on_enter()
	self:start_push()
	self:refresh_room_list()
	self:playBackgroundMusic()
	
	Stats:on_start("hall")
	
	self:checkVip()
	self:initShouchonglibao()
	
 end
 
 function HallScene:playMusic()
 	print("playMusic")
 	if not bg_music then return true end
 	local running_scene = CCDirector:sharedDirector():getRunningScene()
	if running_scene == self then 
 		self:playBackgroundMusic()
 	end
 	return true
 end
 
 function HallScene:onExit()
 	print("HallScene:onExit()")
 	Stats:on_end("hall")
 end
 
 function HallScene:onCleanup()
	print("[HallScene:onCleanup()]")
	GlobalSetting.hall_scene = nil
	NotificationProxy.removeObservers(self.scene_name)
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
 ServerNotifyPlugin.bind(HallScene)
 Push.bind(HallScene)
 UserLocked.bind(HallScene)
 HallMatchPlugin.bind(HallScene)
 SceneEventPlugin.bind(HallScene)
 
 HallPluginBinder.bind(HallScene)