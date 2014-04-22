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
require "VIP"
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
require 'src.ShouchonglibaoDonghua'

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
 	
	ccb.hall_scene = self
	
	self.on_menu_clicked = __bind(self.onMenuClick, self)
	self.on_info_btn_clicked = __bind(self.onInfoClick, self)
	self.on_avatar_btn_clicked = __bind(self.onAvatarClick, self) 
	self.on_market_btn_clicked = __bind(self.onMarketClick, self)
	self.on_ui_quick_game_btn_clicked = __bind(self.do_quick_game_btn_clicked, self)
	self.on_ui_feedback_btn_clicked = __bind(self.do_ui_feedback_btn_clicked, self)
	self.on_ui_prop_btn_clicked = __bind(self.do_ui_prop_btn_clicked, self)
	self.on_ui_promotion_btn_clicked = __bind(self.do_ui_promotion_btn_clicked, self)
	self.on_ui_share_btn_clicked = __bind(self.onShareClick, self)
	self.on_task_btn_clicked = __bind(self.do_on_task_btn_clicked, self)
	self.on_vip_clicked = __bind(self.on_vip_click, self)
	self.on_rank_btn_clicked = __bind(self.getRank, self)
	self.on_shouchonglibao_clicked = __bind(self.on_shouchong_click, self)
	
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
	
	self.btn_stroke_color = GlobalSetting.zongse
	self.btn_stroke_size = 2.5
	self:set_btn_stroke(self.to_info_lbl)
	self:set_btn_stroke(self.to_feedback_lbl)
	self:set_btn_stroke(self.task_lbl)
	set_blue_stroke(self.quick_game_btn_lbl)
	--self:check_kick_out()
	MarqueePlugin.addMarquee(self.rootNode,ccp(400,355))
	GlobalSetting.hall_scene = self
	--if GlobalSetting.run_env == 'test' then
	--	local func = function()
	--		self:onDiploma({balance = 1002, dp_msg='hhhhhh', dp_award_msg='dpawardmsg'})
	--	end
	--	Timer.add_timer(20, func, 'set balance')
	--end
 end
 
 function HallScene:check_kick_out()
 	local reason = KickOut.check()
 	if not reason then return end
 	if reason == 'match_end' then
 		ToastPlugin.show_message_box_suc(strings.hs_match_end)
 	--	self:show_back_message_box('比赛已经结束')--TODO
 	end
 end
 
 function HallScene:set_btn_stroke(btn_lbl)
 	cclog("hallscece set to info lbl stroke")
	set_stroke(btn_lbl, self.btn_stroke_size, self.btn_stroke_color)
	cclog("hallscece set to info lbl stroke finish")
 end
 
 function HallScene:init()
 	print("HallScene:init()")
 end
 
 function HallScene:onEnter() 
	print("HallScene:onEnter()")
	self.super.onEnter(self)
	GamePush.open()
	
	self:updateTimeTask()
	self:update_player_beans_with_gl()
	self:do_on_enter()
	self:start_push()
	self:refresh_room_list()
	--[[
	local is_playing = SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying()
	if bg_music and not is_playing then
		Timer.add_timer(3, function() 
	 		self:playBackgroundMusic()
		end)
		--self:playBackgroundMusic()
	end
	]]
	self:playBackgroundMusic()
	local is_vip = (GlobalSetting.vip ~= cjson.null)
	print("set vip menu visible to " .. tostring(is_vip))
	self.hall_vip_menu:setVisible(is_vip)
	Stats:on_start("hall")
	
	self:checkVip()
	self:initShouchonglibao()
	--self:refresh_room_data()
 end
 
 function HallScene:initShouchonglibao()
 	print("HallScene:initShouchonglibao, GlobalSetting.shouchong_finished=", GlobalSetting.shouchong_finished)
 	if GlobalSetting.shouchong_finished == 1 then
 		self.hall_shouchong_layer:setVisible(false)
 		if GlobalSetting.shouchong_state_changed then
 			if self.rank_dialog then
				self.rank_dialog:dismiss(true)
				self.rank_dialog = nil
			end
 		end
 	else
 		self.hall_shouchong_layer:setVisible(true)
 		ShouchonglibaoDonghua.show(self.hall_shouchong_layer, ccp(self.hall_shouchonglibao_menu:getPosition()))
 	end
 end
 
 function HallScene:checkVip()
 	local is_vip = (GlobalSetting.vip ~= cjson.null)
 	if not is_vip then return end
 	local fn = function()
 		local is_vip = (GlobalSetting.vip ~= cjson.null)
 		if not is_vip then return false end
		local scene = CCDirector:sharedDirector():getRunningScene()
		local salary_getted = (GlobalSetting.vip.get_salary~=0)
		if scene ~= self or salary_getted then return false end
		
		local blink = CCBlink:create(2, 3)
		self.hall_vip_menu:runAction(blink)
		return true
	end
	local fn2 = function() fn() self.vip_blink_1 = nil end
	local fn3 = function() local re = fn() if not re then self.vip_blink = nil end return re end
	if not self.vip_blink_1 and not self.vip_blink then
		self.vip_blink_1 = Timer.add_timer(0.5, fn2, "vip_blink_1")
	end
	if not self.vip_blink then
		self.vip_blink = Timer.add_repeat_timer(5, fn3, "vip_blink")
	end
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