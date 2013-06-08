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
	self.onPrevUserClickedvv = __bind(self.onPrevUserClicked, self)
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

	local s = "[[\"g.game_start\",{\"id\":null,\"channel\":\"channel_10006\",\"data\":{\"user_id\":10006,\"next_user_id\":40005,\"grab_lord\":0,\"lord_value\":-1,\"poke_card_count\":17,\"poke_cards\":[\"w02\",\"a02\",\"c02\",\"d01\",\"c01\",\"b01\",\"a01\",\"a13\",\"c13\",\"c12\",\"d11\",\"a10\",\"c10\",\"d10\",\"b10\",\"b09\",\"c09\",\"a07\",\"b07\",\"c07\",\"d07\",\"d06\",\"c06\",\"a06\",\"b06\",\"d05\",\"c05\",\"b05\",\"a05\",\"b04\",\"b03\",\"a03\"],\"players\":[{\"user_id\":10006,\"avatar\":\"6\",\"nick_name\":\"10006\",\"gender\":\"1\",\"is_robot\":\"0\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40053,\"avatar\":\"51\",\"nick_name\":\"7231\",\"gender\":\"2\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":0,\"player_role\":-1,\"poke_card_count\":17},{\"user_id\":40005,\"avatar\":\"6\",\"nick_name\":\"4e3b\",\"gender\":\"1\",\"is_robot\":\"1\",\"state\":1,\"tuo_guan\":0,\"lord_value\":-1,\"grab_lord\":1,\"player_role\":-1,\"poke_card_count\":17}],\"notify_id\":726,\"__srv_seq_id\":7813477},\"success\":null,\"result\":null,\"server_token\":\"FZhv3iLTemKqBbWubh_OlA\"}]]"
	local data = self.json.decode(s)
	
	self.g_user_id = 10006
	local event = WebSocketRails.Event:new(data[1])
	self:onServerStartGame(event.data)
	print("onPrevUserClicked")
end

GServerMsgPlugin.bind(GamingScene)
GUIUpdatePlugin.bind(GamingScene)
GDataPlugin.bind(GamingScene)
GAlarmPlugin.bind(GamingScene)
SoundEffect.bind(GamingScene)
GTouchPlugin.bind(GamingScene)
GTouchPlugin.bind(GamingScene)