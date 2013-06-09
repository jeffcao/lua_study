require "CCBReaderLoad"
require "src.GServerMsgPlugin"
require "src.GUIUpdatePlugin"
require "src.GPlayerUpdatePlugin"
require "src.GDataPlugin"
require "src/WebsocketRails/WebSocketRails"
require "src/WebsocketRails/WebSocketRails_Event"
require "src.PokeCard"
require "src.GAlarmPlugin"
require "src.SoundEffect"
require "src.Avatar"
require "src.GTouchPlugin"
require "src.CardUtility"

GamingScene = class("GamingScene", function()
	return display.newScene("GamingScene")
end)

function createGamingScene()
	return GamingScene.new()
end

function GamingScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GamingScene = self
	self.onSelfUserClicked = __bind(self.onPrevUserClicked, self)
	local node = CCBReaderLoad("GamingScene.ccbi", self.ccbproxy, true, "GamingScene")

	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	self:initData()
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self.next_user_avatar:setScale(0.65 * GlobalSetting.content_scale_factor)
	self.self_user_avatar:setScale(0.65 * GlobalSetting.content_scale_factor)
	self.prev_user_avatar:setScale(0.65 * GlobalSetting.content_scale_factor)
	
	self.json = require "cjson"
	
end

function GamingScene:onNextUserClicked()
	print("onNextUserClicked")
end

function GamingScene:onPrevUserClicked()

	--local s = "[[\"g.game_start\",{\"id\":null,\"channel\":\"channel_10006\",\"data\":{\"user_id\":10006,\"next_user_id\":40005,\"grab_lord\":0,\"lord_value\":-1,\"poke_card_count\":17,\"poke_cards\":[\"w02\",\"a02\",\"c02\",\"d01\",\"c01\",\"b01\",\"a01\",\"a13\",\"c13\",\"c12\",\"d11\",\"a10\",\"c10\",\"d10\",\"b10\",\"b09\",\"c09\",\"a07\",\"b07\",\"c07\",\"d07\",\"d06\",\"c06\",\"a06\",\"b06\",\"d05\",\"c05\",\"b05\",\"a05\",\"b04\",\"b03\",\"a03\"],\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40053,\"avatar\":\"51\",\"nick_name\":\"7231\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40005,\"avatar\":\"6\",\"nick_name\":\"4e3b\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":1,\"player_role\":-1,\"poke_card_count\":17}],\"notify_id\":726,\"__srv_seq_id\":7813477},\"success\":null,\"result\":null,\"server_token\":\"FZhv3iLTemKqBbWubh_OlA\"}]]"
	local self_join = "[[\"g.player_join_notify\",{\"id\": null,\"channel\": \"1_513\",\"data\": { \"game_info\": {\"id\": \"513\",\"name\": \"fresh\",\"room_base\": \"20\",\"channel_name\": \"1_513\"},\"players\": [{\"user_id\": 10005,\"avatar\": \"5\",\"nick_name\": \"run_away\",\"gender\": \"2\",\"is_robot\": \"0\",\"state\": 1,\"tuo_guan\": 0,\"lord_value\": -1,\"grab_lord\": 0,\"player_role\": -1,\"poke_card_count\": 0}],\"notify_id\": 793,\"__srv_seq_id\": 13802381},\"success\": null,\"result\": null,\"server_token\": \"-1Ihu6-JFBkEhGOcTmCZ8g\"}]]"
	local another_join = "[[\"g.player_join_notify\",{\"id\":null,\"channel\":\"1_34\",\"data\":{\"game_info\":{\"id\":\"34\",\"name\":\"65b0624b623f95f41\",\"room_base\":\"20\",\"channel_name\":\"1_34\"},\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0},{\"user_id\":40025,\"avatar\":\"2\",\"nick_name\":\"7d2b660e\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":0,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0}],\"notify_id\":965,\"__srv_seq_id\":12065821},\"success\":null,\"result\":null,\"server_token\":\"xOJF23eIpmxgbb0IY9vEPg\"}]]"
	local all_join = "[[\"g.player_join_notify\",{\"id\":null,\"channel\":\"1_34\",\"data\":{\"game_info\":{\"id\":\"34\",\"name\":\"65b0624b623f95f41\",\"room_base\":\"20\",\"channel_name\":\"1_34\"},\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0},{\"user_id\":40025,\"avatar\":\"2\",\"nick_name\":\"7d2b660e\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":0,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0},{\"user_id\":40020,\"avatar\":\"3\",\"nick_name\":\"82cf582466256653\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":0,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":0}],\"notify_id\":966,\"__srv_seq_id\":7106166},\"success\":null,\"result\":null,\"server_token\":\"xOJF23eIpmxgbb0IY9vEPg\"}]]"
	local arr = {self_join, another_join, all_join}
	local s = arr[math.random(3)]
	self:onEvent(s, self.onServerPlayerJoin)
	--local data = self.json.decode(s)
	
	--self.g_user_id = 10006
	--local event = WebSocketRails.Event:new(data[1])
	--self:onServerPlayerJoin(event.data)
	--print("onPrevUserClicked")
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