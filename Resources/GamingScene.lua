require "CCBReaderLoad"
require "GameOver"
require "GChat"
require "SetDialog"
require "PlayerInfo"
require 'Rank'
require "src.GServerMsgPlugin"
require "src.GUIUpdatePlugin"
require "src.GPlayerUpdatePlugin"
require "src.GDataPlugin"
require "src.WebsocketRails.WebSocketRails"
require "src.WebsocketRails.Timer"
require "src.WebsocketRails.WebSocketRails_Event"
require "src.PokeCard"
require "src.GAlarmPlugin"
require "src.SoundEffect"
require "src.Avatar"
require "src.GTouchPlugin"
require "src.CardUtility"
require "src.GActionPlugin"
require "src.WebsocketRails.Timer"
require "src.GTriggerCallback"
require "src.GConnectionPlugin"
require "src.GChatPlugin"
require "src.GAnimationPlugin"
require "src.ConnectivityPlugin"
require "src.SocketStatePlugin"
require "src.CardRoboter2"
require "src.ServerNotifyPlugin"
require "src.UIControllerPlugin"
require "src.Stats"
require "src.UserLocked"
require 'src.GameMatchPlugin'
require "GamingOption"

GamingScene = class("GamingScene", function()
	return display.newScene("GamingScene")
end)

function createGamingScene()
	return GamingScene.new()
end

function GamingScene:ctor()
	self.scene_name = 'GamingScene'
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GamingScene = self
	--self.onTuoguanClicked = __bind(self.onTest, self)
	self.onCancelTuoguanClicked = __bind(self.onCancelTuoguanClicked, self)
	self.onTuoguanClicked = __bind(self.onTuoguanClicked, self)
	self.onSelfUserClicked = __bind(self.onSelfUserClicked, self)
	self.onBgMusicClicked = __bind(self.onBgMusicClicked, self)
	self.onEffectMusicClicked = __bind(self.onEffectMusicClicked, self)
	self.onPrevUserClicked = __bind(self.onPrevUserClicked, self)
	self.onNextUserClicked = __bind(self.onNextUserClicked, self)
	self.onCloseClicked = __bind(self.onCloseClicked, self)
	self.onStartReadyClicked = __bind(self.onStartReadyClicked, self)
	self.onGetLordClicked = __bind(self.onGetLordClicked, self)
	self.onBuchuClicked = __bind(self.onBuchuClicked, self)
	self.onChupaiClicked = __bind(self.onChupaiClicked, self)
	self.onCardTipClicked = __bind(self.onCardTipClicked, self)
	self.onReselectClicked = __bind(self.onReselectClicked, self)
	self.onCancelTuoguanClicked = __bind(self.onCancelTuoguanClicked, self)
	self.onChangeDeskClicked = __bind(self.onChangeDeskClicked, self)
	
	local node = CCBReaderLoad("GamingScene.ccbi", self.ccbproxy, true, "GamingScene")

	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	
	self:initData()
	
	
	self.next_user_avatar:setScale(0.65 * GlobalSetting.content_scale_factor)
	self.self_user_avatar:setScale(0.65 * GlobalSetting.content_scale_factor)
	self.prev_user_avatar:setScale(0.65 * GlobalSetting.content_scale_factor)

	

	
	self.json = require "cjson"
	self.g_WebSocket.on_open = function() print("websockt on open after gaming") end
	
	local str = "GamingScene root node is nil"
	if self.rootNode then str = "GamingScene root node is not nil" end
	print(str)
	self:init_connectivity()
	Timer.add_timer(0.5, function() 
		self:check_tech_msg("enter_room")
	end)
	self:setStrokes()
	
	self:listen_match_event()
	
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile(Res.youxi_zhong_plist)
	
	require 'ui.UIUtil'
 	local winSize = CCDirector:sharedDirector():getWinSize()
 	-- local sprite = UIUtil.getRepeatSprite(winSize.width, winSize.height, "ccbResources/yx-beijing1.png")
 	local sprite = CCSprite:createWithSpriteFrameName("youxizhong1/yx-beijing1.png")
 	sprite:setPosition(ccp(winSize.width/2,winSize.height/2))
 	self.back_bg_layer:addChild(sprite, 0, 1010)

 	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
 	self.lord_poke_card_1:setScale(0.50 * GlobalSetting.content_scale_factor)
	self.lord_poke_card_2:setScale(0.50 * GlobalSetting.content_scale_factor)
	self.lord_poke_card_3:setScale(0.50 * GlobalSetting.content_scale_factor)

 	MarqueePlugin.addMarquee(self.rootNode,ccp(400,355))
end

function GamingScene:setStrokes()
	set_anniu_1_3_stroke(self.menu_item_buchu_lbl)
	set_anniu_1_3_stroke(self.menu_item_reselect_lbl)
	set_anniu_1_3_stroke(self.menu_item_tip_lbl)
	set_anniu_1_3_stroke(self.menu_item_play_lbl)
	
	set_anniu_1_3_stroke(self.menu_item_bujiao_lbl)
	set_anniu_1_3_stroke(self.menu_item_1fen_lbl)
	set_anniu_1_3_stroke(self.menu_item_2fen_lbl)
	set_anniu_1_3_stroke(self.menu_item_3fen_lbl)
	
	set_anniu_1_3_stroke(self.menu_item_ready_lbl)
	
	set_anniu_1_3_stroke(self.menu_item_huanzhuo_lbl)
end

function GamingScene:onEnter()
	-- self.super.onEnter(self)
	--self:registerCleanup()
	Stats:on_start("gaming")
	AppStats.beginScene("GamingScene_"..GlobalSetting.game_info.room_name)
end

function GamingScene:onExit()
	-- self.super.onExit(self)
	Stats:on_end("gaming")
	if self.rank_dialog then
		self.rank_dialog:removeFromParentAndCleanup(true)
	end
	if self.rank_dialog then
		if self.rank_dialog.set_rank_time_hdlr then
			Timer.cancel_timer(self.rank_dialog.set_rank_time_hdlr)
		end
		if self.rank_dialog.set_huafei_rank_time_hdlr then
			Timer.cancel_timer(self.rank_dialog.set_huafei_rank_time_hdlr)
		end
	end
	self.rank_dialog = nil
	GlobalSetting.game_id = nil
	self.list_cache = nil
	print("[GamingScene:on_exit()]")
	
	AppStats.endScene("GamingScene_"..GlobalSetting.game_info.room_name)
	if self.umeng_game_play == true then
		self:endPlayEvent()
		AppStats.event(UM_EXCEPTION_GAME_PLAY)
	end
end

function GamingScene:onCleanup()
	print("[GamingScene:onCleanup()]")
	NotificationProxy.removeObservers(self.scene_name)
	self:close_game_websocket()
	-- self.super.onCleanup(self)
end

function GamingScene:onNextUserClicked()
	print("onNextUserClicked")
end

function GamingScene:onTestAnim()
	print("onTestAnim")
	Explosion.explode(self.rootNode, self.BOMB_ORDER)
	--local game_over = "{\"game_result\":{\"winner_player_id\":\"10006\",\"bombs\":\"0\",\"spring\":\"0\",\"anti_spring\":\"0\",\"base\":20,\"lord_value\":\"3\",\"total\":120,\"balance\":{\"10006\":60,\"40188\":60,\"40189\":-120}},\"players\":[{\"user_id\":10006,\"avatar\":\"0\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":0},{\"user_id\":40188,\"avatar\":\"1\",\"nick_name\":\"4e664e66\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":0,\"grab_lord\":1,\"player_role\":1,\"poke_card_count\":15},{\"user_id\":40189,\"avatar\":\"0\",\"nick_name\":\"82cf582466256653\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":3,\"grab_lord\":0,\"player_role\":2,\"poke_card_count\":8}],\"notify_id\":30,\"__srv_seq_id\":5099984}"
	--self:showGameOver(game_over)
	self.g_WebSocket:close_when_server_kill()
	self.g_WebSocket._conn:on_close({})
end

function GamingScene:onTest()

	local start = "[[\"g.game_start\",{\"id\":null,\"channel\":\"channel_10006\",\"data\":{\"user_id\":10006,\"next_user_id\":40005,\"grab_lord\":0,\"lord_value\":-1,\"poke_card_count\":17,\"poke_cards\":[\"d11\",\"c11\",\"a10\",\"c10\",\"d10\",\"b10\",\"b09\",\"c09\",\"c07\",\"d06\",\"c06\",\"a06\",\"b04\"],\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40053,\"avatar\":\"51\",\"nick_name\":\"7231\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40005,\"avatar\":\"6\",\"nick_name\":\"4e3b\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":1,\"player_role\":-1,\"poke_card_count\":17}],\"notify_id\":726,\"__srv_seq_id\":7813477},\"success\":null,\"result\":null,\"server_token\":\"FZhv3iLTemKqBbWubh_OlA\"}]]"
	local self_join = "[[\"g.player_join_notify\",{\"id\": null,\"channel\": \"1_513\",\"data\": { \"game_info\": {\"id\": \"513\",\"name\": \"fresh\",\"room_base\": \"20\",\"channel_name\": \"1_513\"},\"players\": [{\"user_id\": 10005,\"avatar\": \"5\",\"nick_name\": \"run_away\",\"gender\": \"2\",\"is_robot\": \"0\",\"state\": 1,\"tuo_guan\": 0,\"lord_value\": -1,\"grab_lord\": 0,\"player_role\": -1,\"poke_card_count\": 0}],\"notify_id\": 793,\"__srv_seq_id\": 13802381},\"success\": null,\"result\": null,\"server_token\": \"-1Ihu6-JFBkEhGOcTmCZ8g\"}]]"
	local another_join = "[[\"g.player_join_notify\",{\"id\":null,\"channel\":\"1_34\",\"data\":{\"game_info\":{\"id\":\"34\",\"name\":\"65b0624b623f95f41\",\"room_base\":\"20\",\"channel_name\":\"1_34\"},\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0},{\"user_id\":40025,\"avatar\":\"2\",\"nick_name\":\"7d2b660e\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":0,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0}],\"notify_id\":965,\"__srv_seq_id\":12065821},\"success\":null,\"result\":null,\"server_token\":\"xOJF23eIpmxgbb0IY9vEPg\"}]]"
	local all_join = "[[\"g.player_join_notify\",{\"id\":null,\"channel\":\"1_34\",\"data\":{\"game_info\":{\"id\":\"34\",\"name\":\"65b0624b623f95f41\",\"room_base\":\"20\",\"channel_name\":\"1_34\"},\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0},{\"user_id\":40025,\"avatar\":\"2\",\"nick_name\":\"7d2b660e\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":0,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0},{\"user_id\":40020,\"avatar\":\"3\",\"nick_name\":\"82cf582466256653\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":0,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0}],\"notify_id\":966,\"__srv_seq_id\":7106166},\"success\":null,\"result\":null,\"server_token\":\"xOJF23eIpmxgbb0IY9vEPg\"}]]"
	local grab_1 = "[[\"g.grab_lord_notify\",{\"id\":null,\"channel\":\"1_408\",\"data\":{\"lord_user_id\":0,\"lord_value\":1,\"prev_lord_user_id\":40029,\"next_user_id\":40052,\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40029,\"avatar\":\"6\",\"nick_name\":\"57304e3b603b52a85458\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":1,\"grab_lord\":1,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40052,\"avatar\":\"50\",\"nick_name\":\"590f6c50\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17}],\"notify_id\":770,\"__srv_seq_id\":2336434},\"success\":null,\"result\":null,\"server_token\":\"9WuZItsIpGgGkpkos13JZA\"}]]"
	local grab_2 = "[[\"g.grab_lord_notify\",{\"id\":null,\"channel\":\"1_408\",\"data\":{\"lord_user_id\":0,\"lord_value\":1,\"prev_lord_user_id\":40052,\"next_user_id\":10006,\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40029,\"avatar\":\"6\",\"nick_name\":\"57304e3b603b52a85458\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":1,\"grab_lord\":1,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40052,\"avatar\":\"50\",\"nick_name\":\"590f6c50\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":0,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17}],\"notify_id\":771,\"__srv_seq_id\":6986677},\"success\":null,\"result\":null,\"server_token\":\"9WuZItsIpGgGkpkos13JZA\"}]]"
	local grab_3 = "[[\"g.grab_lord_notify\",{\"id\":null,\"channel\":\"1_408\",\"data\":{\"lord_user_id\":10006,\"lord_value\":3,\"lord_cards\":\"d04,d12,b06\",\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":3,\"grab_lord\":0,\"player_role\":2,\"poke_card_count\":20},{\"user_id\":40029,\"avatar\":\"6\",\"nick_name\":\"57304e3b603b52a85458\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":1,\"grab_lord\":1,\"player_role\":1,\"poke_card_count\":17},{\"user_id\":40052,\"avatar\":\"50\",\"nick_name\":\"590f6c50\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":0,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":17}],\"notify_id\":772,\"__srv_seq_id\":16380966},\"success\":null,\"result\":null,\"server_token\":\"9WuZItsIpGgGkpkos13JZA\"}]]"
	local play_card1 = "[[\"g.play_card\",{\"id\":null,\"channel\":\"1_374\",\"data\":{\"player_id\":\"40056\",\"poke_cards\":\"a07,a06,a05,a04,a03\",\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":11},{\"user_id\":40056,\"avatar\":\"51\",\"nick_name\":\"59826b4c4ea6598268a6\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":0,\"grab_lord\":1,\"player_role\":1,\"poke_card_count\":10},{\"user_id\":40006,\"avatar\":\"1\",\"nick_name\":\"53d154e5\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":3,\"grab_lord\":0,\"player_role\":2,\"poke_card_count\":8}],\"next_user_id\":\"40006\",\"notify_id\":220,\"__srv_seq_id\":16492393},\"success\":null,\"result\":null,\"server_token\":\"tgZBlgd7D3FZ-fZIpX3I4w\"}]]"
	local play_card2 = "[[\"g.play_card\",{\"id\":null,\"channel\":\"1_374\",\"data\":{\"player_id\":\"40006\",\"poke_cards\":\"a10,d09,c09,b09,d08,c08,b08,a07\",\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":11},{\"user_id\":40056,\"avatar\":\"51\",\"nick_name\":\"59826b4c4ea6598268a6\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":0,\"grab_lord\":1,\"player_role\":1,\"poke_card_count\":10},{\"user_id\":40006,\"avatar\":\"1\",\"nick_name\":\"53d154e5\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":3,\"grab_lord\":0,\"player_role\":2,\"poke_card_count\":4}],\"next_user_id\":\"10006\",\"notify_id\":221,\"__srv_seq_id\":13760717},\"success\":null,\"result\":null,\"server_token\":\"tgZBlgd7D3FZ-fZIpX3I4w\"}]]"
	local play_card3 = "[[\"g.play_card\",{\"id\":null,\"channel\":\"1_374\",\"data\":{\"player_id\":\"10006\",\"poke_cards\":\"d11,c11,,d10,c10,b10,a10,d06,a06\",\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":7},{\"user_id\":40056,\"avatar\":\"51\",\"nick_name\":\"59826b4c4ea6598268a6\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":0,\"grab_lord\":1,\"player_role\":1,\"poke_card_count\":10},{\"user_id\":40006,\"avatar\":\"1\",\"nick_name\":\"53d154e5\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":3,\"grab_lord\":0,\"player_role\":2,\"poke_card_count\":4}],\"next_user_id\":\"40056\",\"notify_id\":222,\"__srv_seq_id\":6356404},\"success\":null,\"result\":null,\"server_token\":\"tgZBlgd7D3FZ-fZIpX3I4w\"}]]"
	local game_over1 = "[[\"g.game_over\",{\"id\":null,\"channel\":\"3_1387\",\"data\":{\"game_result\":{\"winner_player_id\":\"40040\",\"bombs\":\"0\",\"spring\":\"0\",\"anti_spring\":1,\"base\":100,\"lord_value\":\"3\",\"total\":1200,\"balance\":{\"10006\":-1200,\"40040\":600,\"40016\":600}},\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":1,\"lord_value\":3,\"grab_lord\":1,\"player_role\":2,\"poke_card_count\":14},{\"user_id\":40040,\"avatar\":\"50\",\"nick_name\":\"73b273b2\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":0},{\"user_id\":40016,\"avatar\":\"5\",\"nick_name\":\"4e0a5e1d76845de67738\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":17}],\"notify_id\":23,\"__srv_seq_id\":1411253},\"success\":null,\"result\":null,\"server_token\":\"Tp9BAwGm0aE8TQBxAaI95w\"}]]"
	local game_over2 = "[[\"g.game_over\",{\"id\":null,\"channel\":\"1_374\",\"data\":{\"game_result\":{\"winner_player_id\":\"10006\",\"bombs\":\"0\",\"spring\":1,\"anti_spring\":\"0\",\"base\":20,\"lord_value\":\"3\",\"total\":240,\"balance\":{\"10006\":240,\"40035\":-120,\"40002\":-120}},\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":3,\"grab_lord\":0,\"player_role\":2,\"poke_card_count\":0},{\"user_id\":40035,\"avatar\":\"51\",\"nick_name\":\"51b084dd68b57130\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":1,\"grab_lord\":1,\"player_role\":1,\"poke_card_count\":17},{\"user_id\":40002,\"avatar\":\"3\",\"nick_name\":\"MT5f526765\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":1,\"lord_value\":0,\"grab_lord\":0,\"player_role\":1,\"poke_card_count\":17}],\"notify_id\":259,\"__srv_seq_id\":4160951},\"success\":null,\"result\":null,\"server_token\":\"xOJF23eIpmxgbb0IY9vEPg\"}]]"
	local message1 = "[[\"g.on_message\",{\"id\":101472,\"channel\":\"1_513_chat\",\"data\":{\"msg\":\"快点吧，等到花儿都谢了！\",\"user_id\":10006,\"__srv_seq_id\":3243059},\"success\":null,\"result\":null,\"server_token\":\"tgZBlgd7D3FZ-fZIpX3I4w\"}]]"
	local message2 = "[[\"g.on_message\",{\"id\":101472,\"channel\":\"1_513_chat\",\"data\":{\"msg\":\"快点吧，等到花儿都谢了！\",\"user_id\":40029,\"__srv_seq_id\":3243059},\"success\":null,\"result\":null,\"server_token\":\"tgZBlgd7D3FZ-fZIpX3I4w\"}]]"
	local message3 = "[[\"g.on_message\",{\"id\":101472,\"channel\":\"1_513_chat\",\"data\":{\"msg\":\"快点吧，等到花儿都谢了！\",\"user_id\":40052,\"__srv_seq_id\":3243059},\"success\":null,\"result\":null,\"server_token\":\"tgZBlgd7D3FZ-fZIpX3I4w\"}]]"
	
	--local arr = {self_join, another_join, all_join}
	--local arr = {grab_1, grab_2, grab_3}
	--local arr = {play_card1, play_card2, play_card3}
	local arr = {message1, message2, message3}
	local s = arr[math.random(3)]
	self:onEvent(start, self.onServerStartGame)
	self:onEvent(play_card1, self.onServerPlayCard)
	--self:onEvent(start, self.onServerStartGame)
	--self:onEvent(grab_3, self.onServerGrabLordNotify)
	--Timer.add_timer(2, function()
	--	self:onEvent(s, self.onServerPlayCard)
	--	end)
	--self:onEvent(game_over2, self.onServerGameOver)
end

function GamingScene:onEvent(json_str, fn)
	fn = __bind(fn, self)
	local data = self.json.decode(json_str)
	
	self.g_user_id = 10006
	local event = WebSocketRails.Event:new(data[1])
	fn(event.data)
end

GServerMsgPlugin.bind(GamingScene)
GUIUpdatePlugin.bind(GamingScene)
GDataPlugin.bind(GamingScene)
GAlarmPlugin.bind(GamingScene)
SoundEffect.bind(GamingScene)
GTouchPlugin.bind(GamingScene)
GTouchPlugin.bind(GamingScene)
GActionPlugin.bind(GamingScene)
GTriggerCallback.bind(GamingScene)
GConnectionPlugin.bind(GamingScene)
GChatPlugin.bind(GamingScene)
ConnectivityPlugin.bind(GamingScene)
SocketStatePlugin.bind(GamingScene)
ServerNotifyPlugin.bind(GamingScene)
UIControllerPlugin.bind(GamingScene)
UserLocked.bind(GamingScene)
GameMatchPlugin.bind(GamingScene)