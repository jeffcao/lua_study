require "src.ArrayUtil" 
require "src.Resources" 
require "src.PokeCard" 
require "src.CardUtility_DDZ" 
require "src.CardAnalysis" 
require "src.WebSocketRails" 
require "src.WebSocketRails_Event" 
require "src.WebSocketRails_Channel" 
require "src.WebSocketRails_Connection" 
require "src.ScaleUtility" 
require "src.CardDumper" 
require "src.Avatar" 
require "src.Explosion" 
require "src.Insects" 
require "src.ButterFly" 
require "GameOverScene" 
require "ExitScene" 
require "src.SoundEffect" 
require "UserInfoScene" 
require "Chat" 

local _all_cards = {}
local _all_cards_ids = ""
local y_ratio = 1.0
local x_ratio = 1.0
local contentScaleFactor = 1.0
local cardContentSize = nil
local winSize = nil
local lastCard = nil
local g_WebSocket = nil
local g_room_id = 5
local ROLE_FARMER = 1
local ROLE_LORD = 2

local _is_playing = false
local _has_gaming_started = false

local game_over_layer = nil
local user_info_layer = nil
local exit_layer = nil

local g_user_id = Math:floor(100 + (Math.random() -- 10000))

local prev_user = nil
local next_user = nil
local self_user = nil

local prevUserLastCard = nil
local nextUserLastCard = nil
local lastPlayCard = nil
local lastPlayer = nil

local g_channel = nil
local m_channel = nil
local c_channel = nil

local pThis = nil

local _playing_timeout = 0

local __IS_DEBUG__ = false
local CHANGE_DESK_TAG  = 1001

local NOTIFY_ORDER = 4000--退出提示层
local GAME_OVER_ORDER = 3000--游戏结束层
local BUTTERFLY_ANIM_ORDER = 2210--动画层
local TOP_PANEL_ORDER = 2200--顶部栏层
local INFO_ORDER = 2110--用户资料层
local ALARM_ORDER = 2100--闹钟层
local INSECT_ANIM_ORDER = 2000
local CHAT_LAYER_ORDER = 2120--聊天板
local MSG_LAYER_ORDER = 2400--聊天气泡

local GAME_STATES = {}
GAME_STATES[0] = "准备中..."
GAME_STATES[1] = "就绪"
GAME_STATES[2] = "" -- 游戏中

local DISPLAY_CHAT_ACTION_TAG = 1230
local GAME_OVER_HIDE_ACTION_TAG = 1232

-- SoundSettings.bg_music = true
-- SoundSettings.effect_music = true

local CHAT_MSGS = {"快点吧，我等到花儿也谢了。",
                 "你的牌打得太好了not ",
                 "别走，我们战斗到天亮。",
                 "又断线了，网络怎么这么差not not ",
                 "大家好，很高兴见到各位not "}

-- 存储用户信息
local users = {}

-- 登录的token
local token = nil

local SoundSettings = {
	["bg_music"] = true,
	["effect_music"] = true
}

function theClass:init() 
	self.self_user_name:setString("uid: " .. g_user_id)
	
	self.menu_tuoguan:getParent():reorderChild(self.menu_tuoguan, 1000)
	
	self.card_layer:setTouchEnabled(true)
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(1)
	
	self.rootNode:onKeyBackClicked() 
		cclog("keyBackClicked")
		-- CCDirector:getInstance():end()
		self:onCloseClicked()
	end
	self.rootNode:onKeyMenuClicked() 
		cclog("onKeyMenuClicked")
	end
	
	contentScaleFactor = CCDirector:getInstance():getContentScaleFactor()
	winSize = CCDirector:getInstance():getWinSize()
	local bgSize = self.background:getContentSize()
	
	ScaleUtility:scaleNode(self.rootNode, contentScaleFactor)
	
	y_ratio = winSize.height / 480.0
	x_ratio = winSize.width / 800.0
	cclog("x_ratio => " .. x_ratio .. " , y_ratio => " .. y_ratio .. ", getContentScaleFactor => " .. contentScaleFactor)
	
	PokeCard:sharedPokeCard(self.rootNode)
	Avatar:sharedAvatars()
	self:initAvatar()
	
	cardContentSize = g_shared_cards[0].card_sprite:getContentSize()

	self:init_websocket()
	self:subscribe_connect()
	self:initParam()
	cclog("bind pause resume events")
	self:initPause()
	
	-- self:enter_room(g_room_id)
	
	self:updatePlayers([])
	self:updateLordValue(self.self_user_lord_value, -1)
	self:updateLordValue(self.prev_user_lord_value, -1)
	self:updateLordValue(self.next_user_lord_value, -1)
	
	local game_room_info = CCWebSocketBridge:sharedWebSocketBridge():getGameRoomInfo()
	cclog("game_room_info => " .. game_room_info)
	if not game_room_info then
		CCWebSocketBridge:sharedWebSocketBridge():notifyGameClose()
		CCDirector:getInstance():end()
		return
	end
	local enter_game_data = JSON:parse(game_room_info)
	g_user_id = parseInt(enter_game_data[0][1].data.user_id)
	g_room_id = parseInt(enter_game_data[0][1].data.room_id)
	cclog("get enter_game_data ok. g_user_id => " .. g_user_id .. " , g_room_id => " .. g_room_id)
	
	self:enter_room(g_room_id)

	cclog("[MainSceneDelegate.:init] start to load settings...")	
	self:loadSettings()
	cclog("[MainSceneDelegate.:init] start to update bg music menu item...")	
	self:updateBgMusicMenuItem()
	cclog("[MainSceneDelegate.:init] start to update effect music menu item...")	
	self:updateEffectMusicMenuItem()
	cclog("[MainSceneDelegate.:init] SoundSettings.bg_music => " .. SoundSettings.bg_music)	
	if SoundSettings.bg_music then
		cclog("delay 0.5 to play background music")
		SoundEffect:playBackgroundMusic()
-- self.rootNode:runAction( CCSequence:create(
-- CCDelayTime:create(0.5),
-- CCCallFunc:create( function()
-- cclog("start to play background music")
-- SoundEffect:playBackgroundMusic()
-- end, this ) ))
	end
	
	Explosion:sharedExplosion()
	Insects:sharedInsects()
	local insect = new Insects()
	self.rootNode:addChild(insect, INSECT_ANIM_ORDER)
	ButterFly:sharedButterFly()
	local fly = new ButterFly()
	self.rootNode:addChild(fly, BUTTERFLY_ANIM_ORDER)
	
	self.socket_label:setVisible(__IS_DEBUG__)
	
	self.top_panel:getParent():reorderChild(self.top_panel, TOP_PANEL_ORDER)
	
	self:initChat()
end

function theClass:initAvatar() 
	local scale = contentScaleFactor -- 0.65
	self.self_user_avatar:setScale(scale)
	self.prev_user_avatar:setScale(scale)
	self.next_user_avatar:setScale(scale)
	--self.self_user_avatar_bg:setScale(scale)
	--self.prev_user_avatar_bg:setScale(scale)
	--self.next_user_avatar_bg:setScale(scale)
end

function theClass:loadSettings() 
	local ls = sys.localStorage
	SoundSettings.bg_music = ls:getItem("bg_music") ~= "0"
	SoundSettings.effect_music = ls:getItem("effect_music") ~= "0"
	
	cclog("[MainSceneDelegate.loadSettings] SoundSettings.bg_music => " .. SoundSettings.bg_music)
	cclog("[MainSceneDelegate.loadSettings] SoundSettings.effect_music => " .. SoundSettings.effect_music)
end

function theClass:saveSettings() 
	local ls = sys.localStorage
	ls:setItem("bg_music", (SoundSettings.bg_music? "1" : "0" ))
	ls:setItem("effect_music", (SoundSettings.effect_music? "1" : "0" ))
	
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 初始化websocket
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:init_websocket() 
	local nd = CCWebSocketBridge:sharedWebSocketBridge()
	nd:setReady(true)
	
	g_WebSocket = new WebSocketRails("", true)
	g_WebSocket.state = 'connected'
	
	g_WebSocket:bind("g:game_start", function(data)
		self:onServerStartGame(data)
	end)
	
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 初始化游戏频道事件
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:init_channel(game_info) 
	local channel_name = game_info.channel_name
	cclog("[initChannel] channel_name => " .. channel_name)
	cclog("self_user " .. self_user)
	cclog("self_user.user_id " .. self_user.user_id)
	local user_channel_name = "channel_" .. self_user.user_id
	g_WebSocket.channels[channel_name] = nil--先把原先的channel移除
	g_WebSocket.channels[user_channel_name] = nil
	g_channel = g_WebSocket:subscribe(channel_name)
	m_channel = g_WebSocket:subscribe(user_channel_name)
	c_channel = g_WebSocket:subscribe(channel_name .. "_chat")
	c_channel:bind("g:on_message", function(data) 
		self:onServerChatMessage(data)
	end)
	self:bind_channel(g_channel)
	self:bind_channel(m_channel)
end

function theClass:bind_channel(channel) 
	channel:bind("g:player_join_notify", function(data) 
		self:onServerPlayerJoin(data)
	end)
	channel:bind("g:grab_lord_notify", function(data)
		self:onServerGrabLordNotify(data)
	end)
	channel:bind("g:play_card", function(data)
		self:onServerPlayCard(data)
	end)
	channel:bind("g:game_over", function(data)
		self:onServerGameOver(data)
	end)
	channel:bind("g:game_start", function(data)
		self:onServerStartGame(data)
	end)
	channel:bind("g:leave_game_notify", function(data)
		self:onServerLeave(data)
	end)
end

function theClass:doSendChatMessage(message) 
	c_channel:trigger("g.on_message", msg:message, user_id:g_user_idend)
end

function theClass:onServerChatMessage(message) 
	cclog("chat messageon server :" .. message.msg .. ", from id:" .. message.user_id)
	local layer = nil
	local id = message.user_id
	if next_user and id == next_user.user_id then
		layer = self.next_liaotian
 elseif  prev_user and id == prev_user.user_id then
		layer = self.prev_liaotian
 else 
		layer = self.self_liaotian
	end
	self:displayChatMessage(message.msg, layer, id)
end

local chat_layer = nil
function theClass:initChat() 
	self.next_liaotian:getChildByTag(1002):setFlipX(true)
	self:reorderChat(self.next_liaotian)
	self:reorderChat(self.prev_liaotian)
	self:reorderChat(self.self_liaotian)
end

function theClass:reorderChat(chat) 
	chat:getParent():reorderChild(chat, MSG_LAYER_ORDER)
	
end

function theClass:showChatBoard() 
	if not chat_layer then
		chat_layer = CCBuilderReader:load("Chat")
		chat_layer.controller.delegate = this
		chat_layer:setTouchEnabled(true)
		ScaleUtility:scaleNode( chat_layer, contentScaleFactor )
		chat_layer:setVisible(false)
		self.rootNode:addChild( chat_layer, CHAT_LAYER_ORDER)
	end
	chat_layer:setVisible(true)
end

function theClass:onChatTouchesBegan(touches, event) 
	return true
end

function theClass:onChatTouchesMoved(touches, event) 
	if not chat_layer or not chat_layer:isVisible( then
		return
	end
	local loc = touches[0]:getLocation()
	local childrens = chat_layer.controller.text_layer:getChildren()
	for(local index in childrens) 
		local label = childrens[index]
		if CCrectContainsPoint(label:getBoundingBox(), loc then
			if label:getTag() ~= 1 then
				label:setTag(1)
				label:setColor(CCc3b(0,255,255))
			end
 elseif  label:getTag() == 1 then
			label:setTag(0)
			label:setColor(CCc3b(255,255,255))
		end
	end
end

--点击用户资料对话框
function theClass:onChatTouchesEnded(touches, event) 
	if not chat_layer or not chat_layer:isVisible( then
		return
	end
	local loc = touches[0]:getLocation()
	local childrens = chat_layer.controller.text_layer:getChildren()
	local need_break = false
	for(local index in childrens) 
		local label = childrens[index]
		 if label:getTag() == 1 then
				label:setTag(0)
				label:setColor(CCc3b(255,255,255))
		end
		if CCrectContainsPoint(label:getBoundingBox(), loc then
			self:doSendChatMessage(CHAT_MSGS[index])
			chat_layer:setVisible(false)
			need_break = true
		end
	end
	if need_break then
		return
	end
	if CCrectContainsPoint(chat_layer.controller.text_container:getBoundingBox(), loc then
		return
	end
	chat_layer:setVisible(false)
end

function theClass:displayChatMessage(message, layer, uid) 
	local bg = layer:getChildByTag(1002)
	local text = layer:getChildByTag(3)
	text:setString(message)
	if not layer:isVisible( then
		layer:setVisible(true)
	local delayTime = CCDelayTime:create(5)
	-- self.rootNode.ws_data = data
	local callFunc = CCCallFunc:create(function()
		layer:setVisible(false)
	end, this)
	local seq = CCSequence:create(delayTime, callFunc)
	seq:setTag(uid -- 43)
	self.rootNode:stopActionByTag(uid -- 43)
	self.rootNode:runAction(seq)	
end
	

function theClass:enter_room(room_id) 
	local event_data = user_id:g_user_id, room_id:room_idend
	g_WebSocket:trigger("g.enter_room", 
			event_data, 
			function(data) 
				self:onEnterRoomSuCCss(data)
				
			end,
			function(data) 
				self:onEnterRoomFailure(data)
			end)
end

String:addCommas (nStr) 
    nStr += ''
    local x = nStr:split('.')
    local x1 = x[0]
    local x2 = x.length > 1 ? '.' + x[1] : ''
    local rgx = /(\d+)(\d3end)/
     
    while (rgx.test(x1)) 
        x1 = x1:replace(rgx, '$1,$2')
    end
     
    return x1 + x2
end



function theClass:onEnterRoomSuCCss(data) 
	g_WebSocket:clear_notify_id()
	cclog("[onEnterRoomSuCCss] data => " .. JSON.stringify(data))
	local game_info = data.game_info
	
	self:updatePlayers(data.players)
	self:init_channel(game_info)
	self.menu_ready:setVisible(true)
	self.menu_huanzhuo:setVisible(true)
	
	cclog("[onEnterRoomSuCCss] update room base...")
	local room_base = "底注: " .. String:addCommas(data.game_info.room_base)
	--self.lbl_base:setString(room_base)
	self.dizhu:setString(room_base)
	
	cclog("[onEnterRoomSuCCss] start tick count...")
	self:startSelfUserAlarm(20, function()
		cclog("do not auto ready")
		self:exit()
	--	self:doStartReady()
	end)
	
	cclog("[onEnterRoomSuCCss] exit...")
end

function theClass:retrievePlayers(player_list) 
	self_user = nil
	prev_user = nil
	next_user = nil
	
	if player_list.length > 1 then

		if player_list[0].user_id == g_user_id then
			self_user = player_list[0]
			next_user = player_list[1]
			if player_list.length > 2 then
				prev_user = player_list[2]
 else 
				prev_user = nil
			end
 elseif  player_list[1].user_id == g_user_id then
			self_user = player_list[1]
			prev_user = player_list[0]
			if player_list.length > 2 then
				next_user = player_list[2]
 else 
				next_user = nil
			end
 elseif  player_list.length > 2 and player_list[2].user_id == g_user_id then
			self_user = player_list[2]
			prev_user = player_list[1]
			next_user = player_list[0]
		end
 else 
		prev_user = nil
		next_user = nil
		self_user = player_list[0]
	end
	
	for (local index in player_list) 
		local player = player_list[index]
		self:doGetUserProfileIfNeed(player.user_id)
	end
	
	cclog("[retrivePlayers] self_user => " .. JSON.stringify(self_user))
	cclog("[retrivePlayers] prev_user => " .. JSON.stringify(prev_user))
	cclog("[retrivePlayers] next_user => " .. JSON.stringify(next_user))
	
	
end

function theClass:updatePlayers(player_list) 
	-- cclog("[updatePlayers] player_list.length => " .. player_list.length)
	if player_list  then
		self:retrievePlayers(player_list)
	
	self:updateTuoguan()
	self:updatePlayerNames()
	self:updatePlayerStates()
	self:updatePlayerRoles()
	self:updatePlayerPokeCounts()
	self:updatePlayerAvatars()
	
	
end

function theClass:updateTuoguan() 
	if self_user and self_user.tuo_guan == 1 and self_user.poke_card_count > 0 then
		cclog("is tuoguan status")
		if not self.menu_tuoguan:isVisible( then
			cclog("show tuoguan")
			self.menu_tuoguan:setVisible(true)
		end
 else 
		cclog("is not tuoguan status")
		if self.menu_tuoguan:isVisible( then
			cclog("hide tuoguan")
			self.menu_tuoguan:setVisible(false)
		end
	end
end

function theClass:updatePlayerNames() 
	self:updatePlayerName(self_user, self.self_user_name)
	self:updatePlayerName(prev_user, self.prev_user_name)
	self:updatePlayerName(next_user, self.next_user_name)
end

function theClass:updatePlayerStates() 
	self:updatePlayerState(self_user, self.self_user_state)
	self:updatePlayerState(prev_user, self.prev_user_state)
	self:updatePlayerState(next_user, self.next_user_state)
	
	self:updatePlayerPrepare(self_user, self.self_user_prepare)
	self:updatePlayerPrepare(prev_user, self.prev_user_prepare)
	self:updatePlayerPrepare(next_user, self.next_user_prepare)
end

function theClass:updatePlayerRoles() 
	self:updatePlayerRole(self_user, self.self_user_role, true)
	self:updatePlayerRole(prev_user, self.prev_user_role, true) 
	self:updatePlayerRole(next_user, self.next_user_role, false)
end

function theClass:updatePlayerPokeCounts() 
	self:updatePlayerPokeCount(self_user, self.self_user_poke_count, self.self_user_card_tag)
	self:updatePlayerPokeCount(prev_user, self.prev_user_poke_count, self.prev_user_card_tag)
	self:updatePlayerPokeCount(next_user, self.next_user_poke_count, self.next_user_card_tag)
end

function theClass:updatePlayerName(player, player_name_ui) 
	if player  then
		local player_name = player.nick_name-- .. "[" .. player.user_id .. "]"
		player_name_ui:setString(player_name)
 else 
		player_name_ui:setString("")
	end
end

function theClass:updatePlayerAvatars() 
	self:updatePlayerAvatar(self_user, self.self_user_avatar, self.self_user_avatar_bg)
	self:updatePlayerAvatar(prev_user, self.prev_user_avatar, self.prev_user_avatar_bg)
	self:updatePlayerAvatar(next_user, self.next_user_avatar, self.next_user_avatar_bg)
end

function theClass:updatePlayerAvatar(player, player_avatar_ui, player_avatar_bg) 
	local avatarFrame = nil
	if nil == player then
		if player_avatar_bg:isVisible( then
			player_avatar_bg:setVisible(false)
		end
		if player_avatar_ui:isVisible( then
			player_avatar_ui:setVisible(false)
		end
 else 
		if not player_avatar_ui:isVisible( then
			player_avatar_ui:setVisible(true)
		end
		if not player_avatar_bg:isVisible( then
			player_avatar_bg:setVisible(true)
		end
		avatarFrame = Avatar:getUserAvatarFrame(player)
		player_avatar_ui:setNormalSpriteFrame(avatarFrame)
		player_avatar_ui:setSelectedSpriteFrame(avatarFrame)
	end
	
end

function theClass:updatePlayerPrepare(player, player_ui) 
	if player  and player.state ==1 and player.poke_card_count == 0 then
		player_ui:setVisible(true)
 elseif  player_ui:isVisible() then
		player_ui:setVisible(false)
	end
end

function theClass:updatePlayerState(player, player_state_ui) 
	if player  then
		local state = GAME_STATES[player.state]
	--	player_state_ui:setString( state ) --隐藏
		--表明是服务器自动帮忙准备的
		if player == self_user and player.state ==1 and self.menu_ready:isVisible( then
			self.menu_ready:setVisible(false)
			self.menu_huanzhuo:setVisible(false)
			self:stopUserAlarm()
		end
		if game_over_layer and game_over_layer:isVisible() and player == self_user and player.state == 1  then
			cclog("服务器自动准备，要隐藏游戏结束对话框，并reset所有的牌")
			game_over_layer:setVisible(false)
			self:reset_all()
			local x = self.alarm:getPositionX()
			local y = self.alarm:getPositionY()
			cclog("alarm position:(" .. x .. ", " .. y .. ")")
			if self.alarm:isVisible() and x === 200 and y === 100 then
				cclog("stop user alarm")
				self:stopUserAlarm()
			end
		end
 else 
		player_state_ui:setString( "" )
	end				
end

function theClass:updatePlayerPokeCount(player, player_poke_count_ui, player_card_tag_ui) 
	cclog("card tag ui " .. player_card_tag_ui)
	if player  and player.poke_card_count > 0  then
		if not player_card_tag_ui:isVisible( then
			player_card_tag_ui:setVisible(true)
		end
		player_poke_count_ui:setString( "" .. player.poke_card_count )
 else 
		if player_card_tag_ui:isVisible( then
			player_card_tag_ui:setVisible(false)
		end
		player_poke_count_ui:setString( "" )
	end				
end
	
function theClass:updatePlayerRole(player, role_ui, flip_x) 
	if player == nil or player.player_role < ROLE_FARMER then
		role_ui:setVisible(false)
		return
	end
	
	cclog("[updatePlayerRole] player.player_role => " .. player.player_role)
	
	local farmerFrame = CCSpriteFrameCache:getInstance():getSpriteFrame("role_farmer.png")
	local lordFrame = CCSpriteFrameCache:getInstance():getSpriteFrame("role_lord.png")
	
	if player.player_role == ROLE_FARMER then
		role_ui:initWithSpriteFrame(farmerFrame)
 else 
		role_ui:initWithSpriteFrame(lordFrame)
	end

	role_ui:setScale(contentScaleFactor)
	role_ui:setAnchorPoint(CCp(0, 0.5)) 	
	if player.player_role == ROLE_FARMER then
		role_ui:setFlipX(flip_x)
	end
	role_ui:setVisible(true)
end

function theClass:onEnterRoomFailure(data) 
	cclog("[onEnterRoomFailure] data => " .. JSON.stringify(data))
end

function theClass:updateLordCard(lord_card_ui, lord_poke_card) 
	if lord_poke_card  then
		lord_card_ui:initWithSpriteFrameName(lord_poke_card.image_filename)
		local scale = 0.4 -- contentScaleFactor
		lord_card_ui:setScale(scale)
 else 
		
		lord_card_ui:initWithSpriteFrameName("poke_bg_small.png")
		local scale = 1.0 -- contentScaleFactor
		lord_card_ui:setScale(scale)
	end
end

function theClass:showLordCards(lord_card_ids, lord_value) 
	poke_card_ids = {}
	if lord_card_ids == nil or lord_card_ids.length ==0 then
		-- poke_card_ids:push("poke_bg_medium.png")
 else 
		local tmp_ids = lord_card_ids:split(",")
		for each(local tmp_id in tmp_ids) 
			tmp_id = tmp_id:trim()
			if tmp_id.length > 0 then
				poke_card_ids:push(tmp_id)
		end
	end
	
	if  poke_card_ids.length == 3  then
		_is_playing = true
		
		local poke_cards = {}
		for each(local poke_id in poke_card_ids)
			poke_cards:push(PokeCard:getCardById(poke_id))
		poke_cards:sort(function(a, b)
			return b.index - a.index
		end)
		
		self:updateLordCard(self.lord_poke_card_1, poke_cards[0])
		self:updateLordCard(self.lord_poke_card_2, poke_cards[1])
		self:updateLordCard(self.lord_poke_card_3, poke_cards[2])
		
		--self.lbl_lord_value:setString("倍数: " .. lord_value .. " 倍")
		--self.lbl_lord_value:setVisible(true)
		
		self.beishu:setString("倍数: " .. lord_value .. " 倍")
		--self.beishu:setVisible(true)
		
 else 
		self:updateLordCard(self.lord_poke_card_1, nil)
		self:updateLordCard(self.lord_poke_card_2, nil)
		self:updateLordCard(self.lord_poke_card_3, nil)
		--self.lbl_lord_value:setVisible(false)
		--self.beishu:setVisible(false)
	end
	
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 来自服务器的叫地主事件通知
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:onServerGrabLordNotify(data) 
	local log_prefix = "[onServerGrabLordNotify] "
	cclog(log_prefix .. " data => " .. JSON.stringify(data) )
	
	cclog("hide the get lord menu firstlynot ")
	self:hideGetLordMenu()
	-- 更新各玩家信息
	self:updatePlayers(data.players)
	-- _is_playing = (data.lord_user_id  and (data.lord_user_id .. "" ~=
	-- ""))
	-- 服务器通知自己已是地主？
	if data.lord_user_id == g_user_id then
		-- 从数据中提取出地主牌，加入到手上的牌里面
		local new_data = end
		new_data.user_id = g_user_id
		new_data.poke_cards = _all_cards_ids .. "," .. data.lord_cards
		new_data.grab_lord = 0
		new_data.players = data.players
		
		-- 开始牌局
		self:onServerStartGame(new_data)
		-- 显示出牌菜单
		self:showPlayCardMenu(true)
		self:showLordCards(data.lord_cards, data.lord_value)
		-- self.lbl_base_x:setString("倍数: " .. data.lord_value)
 else 
		-- 自己不是地主，先更新各玩家的叫地主分数
		self:updateLordValue(self.self_user_lord_value, self_user.lord_value)
		self:updateLordValue(self.prev_user_lord_value, prev_user.lord_value)
		self:updateLordValue(self.next_user_lord_value, next_user.lord_value)
		
		local prev = data.prev_lord_user_id
		local value = 0
		
		if prev then
			if prev == prev_user.user_id then
				value = prev_user.lord_value
 elseif  prev == next_user.user_id then
				value = next_user.lord_value
 else 
				value = self_user.lord_value
			end
			
			cclog("grab_lord: value is " .. value)
			SoundEffect:playGrabLordEffect(value, true)
		end
		
		
		-- 轮到自己叫地主?
		if data.next_user_id == g_user_id then
			-- 显示叫地主菜单
			local new_data = end
			new_data.user_id = g_user_id
			new_data.players = data.players
			new_data.lord_value = data.lord_value
			self:showGrabLordMenu(new_data)
 elseif  data.lord_user_id > 0 then
			-- 已经有地主， 隐藏所有地主分数
			self:updateLordValue(self.self_user_lord_value, -1)
			self:updateLordValue(self.prev_user_lord_value, -1)
			self:updateLordValue(self.next_user_lord_value, -1)
			-- 开始地主的出牌计时提示
			if data.lord_user_id == next_user.user_id then
				self:startNextUserAlarm(30, nil)
			else
				self:startPrevUserAlarm(30, nil)
			self:showLordCards(data.lord_cards, data.lord_value)
 else 
			-- 还没有地主产生，也轮不到自己叫地主， 则标示出叫地主的玩家，并启动计时提示
			if data.next_user_id == next_user.user_id then
				self:updateLordValue(self.next_user_lord_value, 4)
				self:startNextUserAlarm(30, nil)
 elseif  data.next_user_id == prev_user.user_id then
				self:updateLordValue(self.prev_user_lord_value, 4)
				self:startPrevUserAlarm(30, nil)
			end
		end
	end
	self:setHasGamingStarted(true)
	
end

function theClass:onServerPlayerJoin(data) 
	cclog("[onServerPlayerJoin] data => " .. JSON.stringify(data))
	if typeof data.players ~= "undefined" then
		cclog("_has_gaming_started:" .. _has_gaming_started)
		if _has_gaming_started then
			cclog("流局的join notify")
			self:stopUserAlarm()
			self:reset_all(data.players)
			self:startSelfUserAlarm(20, function()
				cclog("do not auto ready")
				self:exit()
			--	self:doStartReady()
			end)
			self.menu_ready:setVisible(true)
			self.menu_huanzhuo:setVisible(true)
 else 
			cclog("一般的join notify")
			self:updatePlayers(data.players)
		end
	end
end

function theClass:onStartReadyClicked() 
	SoundEffect:playButtonEffect()	

	self:doStartReady()
end


function theClass:doStartReady(isServer) 
	self:stopUserAlarm()
	self:reset_all()
	self.menu_ready:setVisible(false)
	self.menu_huanzhuo:setVisible(false)
	-- 只有在客户端发起的准备才需要调用此接口，若是恢复数据，则不用通知服务器
	if not isServer then
		g_WebSocket:trigger("g.ready_game", user_id: g_user_idend)
	end
		
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 复位全部状态与显示
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:reset_all(data) 
	-- 隐藏叫地主菜单
	self:hideGetLordMenu()
	self.play_card_menu:setVisible(false)
	self:showLordCards(nil, 0)
	self.menu_tuoguan:setVisible(false)
	
	_playing_timeout = 0
	_is_playing = false
	--_has_gaming_started = false
	cclog("reset_all gaming to false")
	self:setHasGamingStarted(false)

	-- 复位全部牌的状态为初始状态
	self:reset_all_cards()
	
	-- 清除本用户上手牌
	lastCard = nil
	-- 清除上次出牌玩家
	lastPlayer = nil
	-- 清除上手出牌
	lastPlayCard = nil
	nextUserLastCard = nil
	prevUserLastCard = nil
	
	-- 更新玩家信息
	self:updatePlayers(data)

	-- 隐藏不出提示
	self:updatePlayerBuchu(self.self_user_lord_value, false)
	self:updatePlayerBuchu(self.prev_user_lord_value, false)
	self:updatePlayerBuchu(self.next_user_lord_value, false)
	
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 发牌
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:drawPokeCards(data) 
	-- self:reset_all_cards()
	-- 根据服务器发的牌编号(a03, b03...)提取相应的扑克牌
	_all_cards = {}
	local card_ids = {}
	_all_cards_ids = data.poke_cards
	cclog("typeof data.poke_cards => " .. typeof data.poke_cards)
	if typeof data.poke_cards == "string" then
		card_ids = data.poke_cards:split(",")
	else
		card_ids = data.poke_cards
	
	for each(local card_id in card_ids) 
		card_id = card_id:trim()
		_all_cards:push( PokeCard:getCardById(card_id) )
	end
	
	-- 从左到右，按牌面由大到小排序
	_all_cards:sort( function(a,b)
		return (b.index - a.index)
	end)
	
	self:show_cards()		
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 游戏开始，发牌
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:onServerStartGame(data) 
	cclog("[game_start] data -> " .. JSON.stringify(data) )
	
	--暂时注释掉，还不知道到底需不需要这个TODO
	--cclog("[game_start] user_id -> " .. data.user_id)
	
	if data.user_id ~= g_user_id then
		cclog("[game_start] not my cards, return.")
		return			
	end--
	
	-- 复位
	self:reset_all(data)
	-- 发牌
	self:drawPokeCards(data)
	-- 显示各玩家牌数
-- self:updatePlayerPokeCounts()
	self:updatePlayers(data.players)
	
	if  data.grab_lord > 0  then
		data.lord_value = 0
		self:showGrabLordMenu(data, true)
	end
	
	-- 清除所有人的地主分数
	self:updateLordValue(self.self_user_lord_value, -1)
	self:updateLordValue(self.prev_user_lord_value, -1)
	self:updateLordValue(self.next_user_lord_value, -1)
	
	-- 如果当前叫地主是下家，则显示下家在叫地主，并开始计时提示
	if data.next_user_id == next_user.user_id then
		self:updateLordValue(self.next_user_lord_value, 4)
		self:startNextUserAlarm(30, nil)
	end
	elseif  data.next_user_id == prev_user.user_id then
		-- 是上家在叫地主
		self:updateLordValue(self.prev_user_lord_value, 4)
		self:startPrevUserAlarm(30, nil)
	end
	
	SoundEffect:playDeliverCardsEffect()
	
	--_has_gaming_started = true
	cclog("onServerStartGame gaming to true")
	self:setHasGamingStarted(true)
end

function theClass:setHasGamingStarted(value) 
	if _has_gaming_started == value then
		return
	end
	cclog("set _has_gaming_started to " .. value)
	self.self_user_state:setVisible(not value)
	self.prev_user_state:setVisible(not value)
	self.next_user_state:setVisible(not value)
	_has_gaming_started = value
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 显示出牌菜单
 ------------------------------------------------------------------------------------------------------------------------------------------------------------	
function theClass:showPlayCardMenu(bShow) 
	self.play_card_menu:setVisible(bShow)
	if bShow then
		local buchuCallback() 
			_playing_timeout = _playing_timeout + 1
			self:doBuchu()
			if _playing_timeout > 1 then
				self:doTuoguan()
			end
		end
		local chupaiCallback() 
			_playing_timeout = _playing_timeout + 1
			self:playMinSingleCard()
			if _playing_timeout > 1 then
				self:doTuoguan()
			end
		end
		
		cclog("[showPlayCardMenu] lastPlayCard => " .. lastPlayCard)
		cclog("[showPlayCardMenu] lastPlayer.user_id => " .. (lastPlayer  ? lastPlayer.user_id : nil) )
		cclog("[showPlayCardMenu] g_user_id => " .. g_user_id )
		local bSelfFirst = false
		-- 自己是第一个出牌的人?
		if lastPlayCard == nil or lastPlayer.user_id == g_user_id then
			bSelfFirst = true
		end
		
		self.menu_item_buchu:setEnabled(not bSelfFirst)
		local res_enable = false
		for(local index in _all_cards) 
			if _all_cards[index].picked then
				res_enable = true
				break
			end
		end
		self.menu_item_reselect:setEnabled(res_enable)
		
		if bSelfFirst then
			-- 是, 自动出一张
			cclog("[showPlayCardMenu] self is the first playernot not not ")
			self:startSelfUserAlarm(30, chupaiCallback)
 else 
			cclog("[showPlayCardMenu] self is NOT the first playernot not not ")
			-- 不是, 自动不出
			self:startSelfUserAlarm(30, buchuCallback)
		end
	end
	else
		self:stopUserAlarm()
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 显示叫地主菜单
 ------------------------------------------------------------------------------------------------------------------------------------------------------------	
function theClass:showGrabLordMenu(data, needDelay) 
	if needDelay then
		cclog("grab lord delay 0.5s")
		-- 延时0.5秒后显示叫地主菜单
		local delayTime = CCDelayTime:create(0.5)
		-- self.rootNode.ws_data = data
		local callFunc = CCCallFunc:create(function(sender, data_param)
			self:onGrabLordNotice(data_param)
		end, this, data)
		local seq = CCSequence:create(delayTime, callFunc)
		self.rootNode:runAction(seq)	
 else 
		cclog("grab lord do not delay")
		self:onGrabLordNotice(data)
	end
end

function theClass:onGrabLordNotice(data) 
	if data.user_id == g_user_id  then
		self.menu_item_1fen:setEnabled( data.lord_value < 1 )
		self.menu_item_2fen:setEnabled( data.lord_value < 2 )
		self.menu_item_3fen:setEnabled( data.lord_value < 3 )
		self.menu_get_lord:setVisible(true)
	end
	-- 开始计时提示
	self:startSelfUserAlarm(30, function()
		-- 超时为不叫
		self:doGetLord(0)
	end)
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 隐藏叫地主菜单
 ------------------------------------------------------------------------------------------------------------------------------------------------------------	
function theClass:hideGetLordMenu() 
	self.menu_get_lord:setVisible(false)
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 响应抢地主菜单事件 参数： sender - 被点击的菜单项 选择的分数 ＝ sender.tag - 1000 0 - 不叫 1 - 叫1分 2 -
 -- 叫2分 3 - 叫3分
 ------------------------------------------------------------------------------------------------------------------------------------------------------------	
function theClass:onGetLordClicked(sender) 
	-- 取叫的分数
	local lord_value = sender:getTag() - ScaleUtility.NODE_SCALE_TAG_BASE
	cclog("[onGetLord] lord_value => " .. lord_value)

	self:doGetLord(lord_value)
	SoundEffect:playButtonEffect()	
end

function theClass:doGetLord(lord_value) 
	cclog("[onGetLord] lord_value => " .. lord_value)
	
	-- 通知服务器叫地主的分数
	get_lord_event = user_id:g_user_id, lord_value:lord_valueend
	g_WebSocket:trigger("g.grab_lord", get_lord_event)
	-- 隐藏叫地主菜单，并显示叫的分数
	self:hideGetLordMenu()
	self:updateLordValue(self.self_user_lord_value, lord_value)
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 更新抢地主分数 参数： lord_value_ui - ui control lord_value - 地主分数 (0 - 不叫，1 - 1分, 2 -
 -- 2分, 3 - 3分, 4 - 叫地主中)
 ------------------------------------------------------------------------------------------------------------------------------------------------------------	
function theClass:updateLordValue(lord_value_ui, lord_value) 
	if lord_value < 0 then
		lord_value_ui:setVisible(false)
		return
	end

	local frameCache = CCSpriteFrameCache:getInstance()
	local info_bujiao_frame = frameCache:getSpriteFrame("info_bujiao.png")
	local info_1fen_frame = frameCache:getSpriteFrame("1fen.png")
	local info_2fen_frame = frameCache:getSpriteFrame("2fen.png")
	local info_3fen_frame = frameCache:getSpriteFrame("3fen.png")
	local info_getting_lord_frame = frameCache:getSpriteFrame("be_lord.png")
	
	local value_frames = {}
	value_frames:push(info_bujiao_frame)
	value_frames:push(info_1fen_frame)
	value_frames:push(info_2fen_frame)
	value_frames:push(info_3fen_frame)
	value_frames:push(info_getting_lord_frame)
	
	lord_value_ui:initWithSpriteFrame(value_frames[lord_value])
	lord_value_ui:setVisible(true)
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 响应来自服务器的玩家出牌通知 参数： data - 出牌通知协议， 具体参见Wiki
 ------------------------------------------------------------------------------------------------------------------------------------------------------------	
function theClass:onServerPlayCard(data) 
	cclog("[onServerPlayCard] data => " .. JSON.stringify(data))
	-- 提取玩家信息
	self:retrievePlayers(data.players)
	self:updateTuoguan()
	
	if lastPlayer == nil or lastPlayer.user_id == data.player_id then
		-- 隐藏不出提示
		self:updatePlayerBuchu(self.self_user_lord_value, false)
		self:updatePlayerBuchu(self.prev_user_lord_value, false)
		self:updatePlayerBuchu(self.next_user_lord_value, false)		
	end
	
	-- 出牌玩家的 user_id
	local the_player_id = data.player_id
	---- 是自己的出牌回传？
	if the_player_id == g_user_id then
		-- 应该由下家出牌， 开始下家出牌计时
		if not _is_playing then
			return

		self:startNextUserAlarm(30, nil)
		-- 隐藏下家不出标签
		self:updatePlayerBuchu(self.next_user_lord_value, false)
		return
	end--
	
	-- 提取所出的牌
	local poke_cards = {}
	local poke_card_ids = data.poke_cards:split(",")
	for each(local poke_card_id in poke_card_ids) 
		tmp_id = poke_card_id:trim()
		if tmp_id.length > 0 then
			poke_cards:push(PokeCard:getCardById(tmp_id))
	end
	
	cclog("[onPlayCard] poke_cards.length => " .. poke_cards.length)
	for (local index in poke_cards) 
		cclog("[onPlayCard] poke_cards[" .. index .. "] => " .. poke_cards[index])
	end
	
	-- 根据所出的牌生成牌型
	local card = CardUtility:getCard(poke_cards)
	if the_player_id == prev_user.user_id then
		card.owner = prev_user
 elseif  the_player_id == next_user.user_id then
		card.owner = next_user
	end
	cclog("[onPlayCard] card.type => " .. card.card_type)
	if the_player_id ~= g_user_id then
		SoundEffect:playCardEffect(card)
	end
	

	if _is_playing then
		local player
		
		-- 是自己的出牌回传？
		if the_player_id == g_user_id then
			-- 应该由下家出牌， 开始下家出牌计时
			cclog("hide play is self card, is tuoguan?" .. self:isTuoguan() .. ", is menu show?" .. self.play_card_menu.isVisible())
			--服务器自动帮忙出牌play card TODO
			--if self.play_card_menu:isVisible() or self:isTuoguan()) 
				cclog("hide play card menu firstlynot ")
				self:showPlayCardMenu(false)
				self:doChupai(card, true)
				if self_user.tuo_guan == 1 and not self:isTuoguan( then
					self:doTuoguan(true)
				end
				---- 隐藏上一手出的牌
				if prevUserLastCard  then
					self:reset_card(prevUserLastCard)
					prevUserLastCard = nil
				end--
			--end

			self:startNextUserAlarm(30, nil)
			-- 隐藏下家不出标签
			self:updatePlayerBuchu(self.next_user_lord_value, false)
			return
		end
		-- 是上家出的牌？
		if the_player_id == prev_user.user_id then
			player = prev_user
			-- 执行上家出牌效果
			self:doPrevUserPlayCard(card)
			
			if self:isTuoguan( then
			--	self:doTuoguanPlaying()
 else 
				
				-- 轮到自己出牌，显示出牌菜单
				self:showPlayCardMenu(true)
				
				-- 隐藏上一手出的牌
				if lastCard  then
					self:reset_card(lastCard)
					lastCard = nil
				end 
				
				-- 开始自己计时提示
				-- self:startSelfUserAlarm()
				-- 隐藏自己的不出标签
				self:updatePlayerBuchu(self.self_user_lord_value, false)
				
			end
 else 
			player = next_user
			-- 是下家出的牌，执行下家出牌
			self:doNextUserPlayCard(card)
			-- 开始下家出牌计时提示
			self:startPrevUserAlarm(30, nil)
			-- 隐藏下家不出标签
			self:updatePlayerBuchu(self.prev_user_lord_value, false)
		end
		if player.poke_card_count <= 2 and poke_cards.length > 0 then
			SoundEffect:playCardTips(player.poke_card_count, player.gender == 1)
		end
	end
	
	-- 更新各更手上的牌数
	self:updatePlayerPokeCounts()
	
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 下家出牌
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:doPrevUserPlayCard(card) 

	-- 隐藏上一手出的牌
	if prevUserLastCard  then
		self:reset_card(prevUserLastCard)
		prevUserLastCard = nil
	end
	
	if card.card_type == CardType.NONE then
		-- 无效牌型，表示不出牌
		self:updatePlayerBuchu(self.prev_user_lord_value, true)
		return			
 else 
		-- 有效出牌，隐藏不出标签
		self:updatePlayerBuchu(self.prev_user_lord_value, false)
		-- 保存为最后出牌信息
		lastPlayer = prev_user
		lastPlayCard = card
	end
	
	
	-- 初始化出牌位置
	local start_point = CCp(-100, winSize.height + 100)
	for(local index=card.poke_cards.length-1 index>=0 index--) 
		local p = card.poke_cards[index].card_sprite
		p:setPosition(start_point)
		p:setScale(contentScaleFactor)
		p:setTag(0)
		-- self.rootNode:addChild(p)
		p:getParent():reorderChild(p, 100 - index )
		p:setVisible(true)
	end

	-- 产生出牌效果
	local poke_size = card.poke_cards[0].card_sprite:getContentSize().width / 2
	local center_point = CCp(winSize.width/2, cardContentSize.height -- contentScaleFactor + 15)
	local step = 35 -- 0.7
	local start_x = 165
	local start_y = 300
	
	for(local index=card.poke_cards.length-1 index >=0 index--) 
		local poke_card = card.poke_cards[index].card_sprite
		local moveAnim = CCMoveTo:create(0:2, CCp(start_x, start_y) )
		local scaleAnim = CCScaleTo:create(0.1, 0.7 -- contentScaleFactor)
		local sequence = CCSequence:create(moveAnim, scaleAnim)
		poke_card:runAction( moveAnim )
		poke_card:runAction( scaleAnim )
		start_x = start_x + 35 -- 0.7

		-- poke_card:getParent():reorderChild(poke_card, -10 - index)
		poke_card:setTag(-1)
	end
	
	if card.card_type === CardType.BOMB or card.card_type === CardType.ROCKET then
		cclog("炸弹效果")
		Explosion:explode(self.rootNode)
	end
	
	-- 记住本次出牌
	prevUserLastCard = card
	
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 下家出牌
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:doNextUserPlayCard(card) 
	-- 隐藏上一手出的牌
	if nextUserLastCard  then
		self:reset_card(nextUserLastCard)
		nextUserLastCard = nil
	end
	
	if card.card_type == CardType.NONE then
		-- 无效牌型，表示不出牌
		self:updatePlayerBuchu(self.next_user_lord_value, true)
		return			
 else 
		-- 有效出牌，隐藏不出标签
		self:updatePlayerBuchu(self.next_user_lord_value, false)
		-- 保存为最后出牌信息
		lastPlayer = next_user
		lastPlayCard = card
	end
	
	-- 初始化出牌位置
	local start_point = CCp(winSize.width + 100, winSize.height + 100)
	for(local index=card.poke_cards.length-1 index>=0 index--) 
		local p = card.poke_cards[index].card_sprite
		p:setPosition(start_point)
		p:setScale(contentScaleFactor)
		p:setTag(0)
		p:setVisible(true)
		-- self.rootNode:addChild(p)
		p:getParent():reorderChild(p, 100 - index )
	end

	-- 产生出牌效果
	local poke_size = card.poke_cards[0].card_sprite:getContentSize().width / 2
	local center_point = CCp(winSize.width/2, cardContentSize.height -- contentScaleFactor + 15)
	local step = 35 -- 0.7
	local start_x = 585
	local start_y = 300
	
	for(local index=0 index < card.poke_cards.length index++) 
		local poke_card = card.poke_cards[index].card_sprite
		local moveAnim = CCMoveTo:create(0:2, CCp(start_x, start_y) )
		local scaleAnim = CCScaleTo:create(0.1, 0.7 -- contentScaleFactor)
		local sequence = CCSequence:create(moveAnim, scaleAnim)
		poke_card:runAction( moveAnim )
		poke_card:runAction( scaleAnim )
		start_x = start_x - 35 -- 0.7

		-- poke_card:getParent():reorderChild(poke_card, -10 - index)
		poke_card:setTag(-1)
	end
	
	if card.card_type === CardType.BOMB or card.card_type === CardType.ROCKET then
		cclog("炸弹效果")
		Explosion:explode(self.rootNode)
	end
	
	-- 记住本次出牌
	nextUserLastCard = card
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 显示不出标签 参数： buchu_ui 显示不出图片的UI控件 bBuchu True 显示 False 隐藏
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:updatePlayerBuchu(buchu_ui, bBuchu) 
	if not bBuchu then
		buchu_ui:setVisible(false)
		return
	end
	
	local frameCache = CCSpriteFrameCache:getInstance()
	buchu_ui:initWithSpriteFrame(frameCache:getSpriteFrame("info_buchu.png"))
	buchu_ui:setVisible(true)
end

function theClass:onAlarmTick(callbackFunc) 
	-- cclog("[onAlarmTick] current_tick => " .. current_tick)
	local current_tick = self.alarm_tick:getTag()
	current_tick --
	self.alarm_tick:setString("" .. current_tick)
	self.alarm_tick:setTag(current_tick)
	
	if current_tick < 10 and current_tick >5 then
		if current_tick == 9 then
			self.alarm_tick:setColor( CCc3b(255,0,0))
		if typeof callbackFunc == "function" then
			SoundEffect:playCountdownEffect()
	end
	elseif  current_tick <= 5 then
		if current_tick > 0 and typeof callbackFunc == "function" then
			SoundEffect:playWarningEffect()
		
		if current_tick <= 0 then
			if typeof callbackFunc == "function" then
				callbackFunc()
			self:stopUserAlarm()
			return
		end
	end
	
	-- cclog("[onAlarmTick] current_tick => " .. current_tick)
	local seqAction = CCSequence:create( CCDelayTime:create(1), CCCallFunc:create(function()
		self:onAlarmTick(callbackFunc)
	end))
	seqAction:setTag(9000)
	-- cclog("[onAlarmTick] start new tick count.")
	self.rootNode:runAction( seqAction )
end

function theClass:startAlarm(showPoint, tick_count, callbackFunc) 
	
	self:stopUserAlarm()
	
	self.alarm:setPosition(showPoint)
	self.alarm_tick:setString("" .. tick_count)
	self.alarm_tick:setTag(tick_count)
	self.alarm_tick:setColor(CCc3b(0,0,0))	
	self.alarm:setVisible(true)
	self.alarm:getParent():reorderChild(self.alarm, ALARM_ORDER)
	local seqAction = CCSequence:create( CCDelayTime:create(1), CCCallFunc:create(function()
		self:onAlarmTick(callbackFunc)
	end))
	seqAction:setTag(9000)
	self.rootNode:runAction( seqAction )
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 开始自己计时动作
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:startSelfUserAlarm(tick_count, callbackFunc) 
	self:startAlarm( CCp(400,230), tick_count, callbackFunc )
end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 停止计时动作
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:stopUserAlarm() 
	-- self.alarm:setPosition(CCp(165,175))
	cclog("[stopUserAlarm] stop.")
	self.alarm:setVisible(false)
	self.rootNode:stopActionByTag(9000)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 开始前位玩家计时动作
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:startPrevUserAlarm(tick_count, callbackFunc) 
-- self.alarm:setPosition(CCp(120, 310))
-- self.alarm:setVisible(true)
	local callback() 
		local id = prev_user.user_id
		cclog("player over time " .. id)
		--TODO trigger over time
		g_WebSocket:trigger("g.player_timeout", "user_id":self_user.user_id, "timeout_user_id":idend)
		if callbackFunc then
			callbackFunc()
		end
	end
	self:startAlarm( CCp(120, 310), tick_count, callback )
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 开始下位玩家计时动作
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:startNextUserAlarm(tick_count, callbackFunc) 
-- self.alarm:setPosition(CCp(700, 310))
-- self.alarm:setVisible(true)
	local callback() 
		local id = next_user.user_id
		cclog("player over time " .. id)
		g_WebSocket:trigger("g.player_timeout", "user_id":self_user.user_id, "timeout_user_id":idend)
		--TODO trigger over time
		if callbackFunc then
			callbackFunc()
		end
	end
	self:startAlarm( CCp(680, 310), tick_count, callback )
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 复位所有牌，tag: 0, scale: 1.0, no parent
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:reset_all_cards() 
-- for each(local poke_card in g_shared_cards) 
-- poke_card:reset()
-- -- if poke_card:getParent()) 
-- -- poke_card:removeFromParent()
-- -- end
-- -- poke_card:setTag(0)
-- -- poke_card:setScale(1.0)
-- end
--	
	PokeCard:resetAll(self.rootNode)
	
	_all_cards = {}
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 显示牌:
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:show_cards() 
	local p = CCp(20, (winSize.height - cardContentSize.height)/2)
	p.y = 0
	
	for(local index in _all_cards)
		local card = _all_cards[index].card_sprite
		local cardValue = _all_cards[index].index

		cclog("cardValue: " .. cardValue .. ", card: " .. card)
		card:setTag(0)
		card:setPosition( CCp((winSize.width - cardContentSize.width)/2, p.y) )
		card:setScale(contentScaleFactor)
		card:setVisible(true)

		-- self.rootNode:addChild(card)
		-- self.card_layer:addChild(card)
		-- p.x = p.x + 35 -- x_ratio
	end
	self:align_cards()
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 根据牌的数量重新排列展示
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:align_cards() 
	
	self.self_user_poke_count:setString(_all_cards.length .. "")
	
	-- 无牌？返回
	if _all_cards.length < 1 then
		return
	
	p = CCp(0, 0)	
	local cardWidth = cardContentSize.width -- contentScaleFactor
	-- 计算牌之间的覆盖位置，最少遮盖30% 即显示面积最多为70%
	local step = (winSize.width) / (_all_cards.length + 1)
	if step > cardWidth -- 0.7 then
		step = cardWidth -- 0.7

	-- 计算中心点
	local poke_size = cardWidth / 2
	local center_point = CCp(winSize.width/2, 0)
	
	-- 第一张牌的起始位置，必须大于等于0
	local start_x = center_point:x - (step -- _all_cards.length/2 + poke_size / 2)
	if start_x < 0 then
		start_x = 0
	
	p.x = start_x
	
	-- 排列并产生移动效果
	for(index in _all_cards) 
		local card = _all_cards[index]
		if card.card_sprite:getParent( then
			card.card_sprite:getParent():reorderChild(card.card_sprite, index)
		card.picked = false
		card.card_sprite:runAction( CCMoveTo:create(0:3, CCp(p.x, p.y) ) )
		p.x = p.x + step-- -- x_ratio
	end		
end

-- 点击用户资料对话框
function theClass:onInfoTouchesEnded(touches, event) 
	if user_info_layer and user_info_layer.isVisible then
		user_info_layer:setVisible(false)
	end
end

function theClass:getCardIndex (loc) 
	local result = -1
	for (index=_all_cards.length-1 index>=0 index--) 		
		local poke_card = _all_cards[index]
		if  CCrectContainsPoint(poke_card.card_sprite:getBoundingBox() , loc then
			result = index
			break
		end
	end
	return result
end

function theClass:getCheckedCards() 
	local result = {}
	local checked_cards = {}
	for (index=_all_cards.length-1 index>=0 index--) 		
		local poke_card = _all_cards[index]
		if poke_card.card_sprite:getTag() == 1003 then
			checked_cards:push(poke_card)
		end
	end
	local is_self_play = self.play_card_menu:isVisible()
	local is_last_card_self = lastPlayer and lastPlayer.user_id == g_user_id
	result = CardUtility:slide_card(lastPlayCard, checked_cards, is_self_play, is_last_card_self)
	cclog("result is: " .. result)
	return result
end

function theClass:onTouchesBegan (touches, event) 
	local loc = touches[0]:getLocation()
	begin = self:getCardIndex(loc)
end

local begin = -1
local last_check = -1
--当触屏按下并移动事件被响应时的处理。
function theClass:onTouchesMoved (touches, event) 
	--if not self.play_card_menu:isVisible())
	--	return
	
	local loc = touches[0]:getLocation()
	local cur_check = self:getCardIndex(loc)
	if cur_check == -1 or cur_check == last_check then
		return
	end
	if begin == -1 then
		begin = cur_check
	end
	self:move_check(begin, cur_check)
	last_check = cur_check
end

function theClass:move_check(start, end) 
	if start == end then
		return
	
	local s = start < end ? start : end
	local e = start < end ? end : start
	local white = CCc3b(255,255,255)
	local red = CCc3b(187,187,187)
	for (index=_all_cards.length-1 index>=0 index--) 
		local poke_card = _all_cards[index]
		if index > e or index < s then
			if poke_card.card_sprite:getTag() ~= 1000 then
				poke_card.card_sprite:setColor(white)
				poke_card.card_sprite:setTag(1000)
			end
 else 
			if poke_card.card_sprite:getTag() ~= 1003 then
				poke_card.card_sprite:setColor(red)
				poke_card.card_sprite:setTag(1003)
			end
		end
	end
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 点击牌，产生效果选取或取消的效果
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:onTouchesEnded(touches, event) 
	-- cclog("onTouchesEnded")
	-- 如果不是轮到自己出牌，退出
	--if not self.play_card_menu:isVisible())
	--	return
	local checked_cards = self:getCheckedCards()
	if checked_cards.length > 0 then
		for (index=_all_cards.length-1 index>=0 index--) 		
			local poke_card = _all_cards[index]
			if poke_card.picked then
			self:unpickPokeCard(poke_card)
			end
		end
		for (index=checked_cards.length-1 index>=0 index--) 
			local poke_card = checked_cards[index]
			if not poke_card.picked then
				self:pickPokeCard(poke_card)
			end
		end
		self.menu_item_reselect:setEnabled(true)
		SoundEffect:playDealCardEffect()
 else 
		
	local loc = touches[0]:getLocation()
	for (index=_all_cards.length-1 index>=0 index--) 		
		local poke_card = _all_cards[index]
		-- cclog("card ==> " .. card)
		
		if  CCrectContainsPoint(poke_card.card_sprite:getBoundingBox() , loc then
			-- cclog("card touched: card_value " .. card.poke_value .. " ,
			-- card_type: " .. card.poke_card_type)
			if not poke_card.picked then
				self:pickPokeCard(poke_card)
 else 
				self:unpickPokeCard(poke_card)
			end
			
			SoundEffect:playDealCardEffect()
			
			self.menu_item_reselect:setEnabled( self:getPickedPokeCards().length > 0 )
			
			break
		end
	end
	
	end
	for (index=_all_cards.length-1 index>=0 index--) 		
		local poke_card = _all_cards[index]
		if poke_card.card_sprite:getTag() ~= 1000 then
			poke_card.card_sprite:setColor(CCc3b(255,255,255))
			poke_card.card_sprite:setTag(1000)
		end
	end
	begin = -1
	last_check = -1
end

function theClass:getPickedPokeCards () 
	local poke_cards = {}
	-- 选取所有选中的牌
	for(local index=_all_cards.length-1 index>=0 index --) 
		local poke_card = _all_cards[index]
		if poke_card.picked then
			poke_cards:push(poke_card)
	end
	
	return poke_cards
end

function theClass:pickPokeCard(poke_card) 
	if not poke_card.picked then
		cclog("[pickPokeCard] pick " .. poke_card)
		poke_card.card_sprite:runAction(CCMoveBy:create(0:08, CCp(0, 30 -- y_ratio)))
		poke_card.picked = true
	end 
end

function theClass:unpickPokeCard(poke_card) 
	if poke_card.picked then
		cclog("[unpickPokeCard] unpick " .. poke_card)
		poke_card.card_sprite:runAction(CCMoveBy:create(0:08, CCp(0, -30 -- y_ratio)))
		poke_card.picked = false
	end 
end

function theClass:unpickPokeCards(poke_cards) 
	for each(local poke_card in poke_cards) 
		self:unpickPokeCard(poke_card)
	end
end

function theClass:pickPokeCards(poke_cards) 
	for each(local poke_card in poke_cards) 
		self:pickPokeCard(poke_card)
	end
end


function theClass:reset_card(card) 
	for each(local poke_card in card.poke_cards) 
		poke_card:reset()
	end
end

function theClass:playMinSingleCard()
-- local poke_cards = self:getPickedPokeCards()
-- if poke_cards.length == 0 or CardUtility:getCard(poke_cards).card_type ==
-- CardType.NONE) 
-- if poke_cards.length > 0)
-- self:unpickPokeCards(poke_cards)
-- self:pickPokeCard(_all_cards[_all_cards.length-1])
-- end
	
	-- self:onChupai()
	
	local poke_cards = {}
	poke_cards:push( _all_cards[_all_cards.length-1] )
	local card = CardUtility:getCard(poke_cards)
	self:doChupai( card )	
end

function theClass:onReselectClicked() 
	local poke_cards = self:getPickedPokeCards()
	self:unpickPokeCards(poke_cards)
	self.menu_item_reselect:setEnabled(false)
	SoundEffect:playButtonEffect()	
end

function theClass:onCardTip() 
	local is_self_last_player = lastPlayer and lastPlayer.user_id == g_user_id
	local last_play_card = lastPlayCard
	local source_card = _all_cards ? _all_cards:slice(0) : nil
	local cards = CardUtility:tip_card(last_play_card, source_card, is_self_last_player)
	if cards.length == 0 then
		cclog("tip is nil")
		self:onBuchuClicked()
		return
	end
	self:unpickPokeCards(_all_cards)
	self:pickPokeCards(cards)
	self.menu_item_reselect:setEnabled(true)
	SoundEffect:playDealCardEffect()
end

function theClass:onBuchuClicked() 
	-- 如果自己是一个出牌的人，或者其他两人都选择不出，则自己必须出牌
	if  lastPlayCard == nil or lastPlayer.user_id == g_user_id  then
		return

	_playing_timeout = 0
	
	self:doBuchu()
end

function theClass:doBuchu(isServerAuto) 
	-- 如果自己是一个出牌的人，或者其他两人都选择不出，则自己必须出牌
	if  (lastPlayCard == nil or lastPlayer.user_id == g_user_id) and not isServerAuto then
		return
	
	-- 隐藏上一手出的牌
	if lastCard  then
		self:reset_card(lastCard)
		lastCard = nil
	end 

	
	if isServerAuto then
	-- 显示不出标签
	cclog("show self buchu.")
	self:updatePlayerBuchu(self.self_user_lord_value, true)
	end
	
	-- 退回所选的牌
	local poke_cards = self:getPickedPokeCards()
	self:unpickPokeCards(poke_cards)

	if not isServerAuto then
		-- 通知服务器，出牌
		local event_data = player_id:g_user_id, poke_cards: ""end
		g_WebSocket:trigger("g:play_card", event_data, function(data) 
			cclog("========game.play return suCCss: " .. JSON.stringify(data))
		end, function(data) 
			cclog("----------------game.play return failure: " .. JSON.stringify(data))
		end)
	end
	
	-- 隐藏出牌菜单
	self:showPlayCardMenu(false)
	if isServerAuto then
		-- 不要就是打一手无效空牌
		local card = new Card
		card.owner = self_user
		SoundEffect:playCardEffect(card)
	end
	if not isServerAuto then
	SoundEffect:playButtonEffect()	
	end
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 出牌
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:onChupaiClicked()
	-- cclog("chu pai")
	local poke_cards = {}
	
	-- 选取所有选中的牌
	for(local index=_all_cards.length-1 index>=0 index --) 
		local card = _all_cards[index]
		if card.picked then
			poke_cards:push(card)
	end
	
	SoundEffect:playButtonEffect()	

	-- 获取牌型
	local card = CardUtility:getCard(poke_cards)
	
	cclog("card.card_type => " .. card.card_type .. " , max_poke_value => " .. card.max_poke_value .. ", card_length => " .. card.card_length)
	-- 无效牌型？ 返回
	if card.card_type == CardType.NONE then
		return
	end
	
	_playing_timeout = 0
	
	self:doChupai(card)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 出牌
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:doChupai(card, isServerAutoPlay)

	cclog("card.card_type => " .. card.card_type .. " , max_poke_value => " .. card.max_poke_value .. ", card_length => " .. card.card_length)
	-- 无效牌型？ 返回
	if card.card_type == CardType.NONE then
		if not isServerAutoPlay then
			return
 else 
			--buyao
			self:doBuchu(true)
			return
		end
	end
	
	-- 如果最后一个出牌的人是自己（其他人不出牌，或自己第一手出牌），则不需要比较牌的大小
	if lastPlayCard  and lastPlayer.user_id ~= g_user_id then
		-- 上一手牌不是自己出的，则要求本次出的牌大于上手牌
		if not CardUtility:compare(card, lastPlayCard then
			return
	end
	
	if isServerAutoPlay then
	-- 隐藏上一手出的牌
	if lastCard  then
		self:reset_card(lastCard)
		lastCard = nil
	end 
	
	-- 记住本人是当前最后一个出牌人，和所出的牌
	lastPlayer = self_user
	lastPlayCard = card
	
	-- 产生出牌效果
	local poke_size = card.poke_cards[0].card_sprite:getContentSize().width / 2
	local center_point = CCp(winSize.width/2, 200)
	local step = 35 -- 0.7
	local start_x = center_point:x - (step -- card.poke_cards.length/2 + poke_size) -- 0.7 
	
	for(local index=card.poke_cards.length-1 index >=0 index--) 
		local poke_card = card.poke_cards[index].card_sprite
		local moveAnim = CCMoveTo:create(0:2, CCp(start_x, center_point.y) )
		local scaleAnim = CCScaleTo:create(0.1, 0.7 -- contentScaleFactor)
		local sequence = CCSequence:create(moveAnim, scaleAnim)
		poke_card:runAction( moveAnim )
		poke_card:runAction( scaleAnim )
		start_x = start_x + 35 -- 0.7

		poke_card:getParent():reorderChild(poke_card, 20 - index)
		-- poke_card:setTag(-1)
		-- poke_card.picked = false
	end
	
	if card.card_type === CardType.BOMB or card.card_type === CardType.ROCKET then
		cclog("炸弹效果")
		Explosion:explode(self.rootNode)
	end
	
	-- 记住本次出牌
	lastCard = card

	-- 从手上的牌里面去除所出的牌
	_all_cards = _all_cards:filter(function(element, index, array) 
		return card.poke_cards:indexOf(element) == -1
	end)
	
	-- 对已出牌取消选取标志
	for each(local poke_card in card.poke_cards) 
		poke_card.picked = false
	end
	
	-- 重新排列现有的牌
	self:align_cards()
	end
	
	-- 如果不是服务器自动帮助出牌，发送出牌命令
	if not isServerAutoPlay then
		-- 通知服务器，出牌
		local event_data = player_id:g_user_id, poke_cards: card:getPokeIds():join(",")end
		g_WebSocket:trigger("g:play_card", event_data, function(data) 
			cclog("========game.play return suCCss: " .. JSON.stringify(data))
		end, function(data) 
			cclog("----------------game.play return failure: " .. JSON.stringify(data))
		end)
	end
	
	-- 隐藏出牌菜单
	self:showPlayCardMenu(false)
	if isServerAutoPlay then
		card.owner = self_user
		SoundEffect:playCardEffect(card)
	end
end

-- TODO
function theClass:showUserInfo(user_id) 
	if not user_id then
		return
	cclog("call show user info ")
	if user_info_layer == nil  then
		user_info_layer = CCBuilderReader:load("UserInfoScene")
		user_info_layer.controller.delegate = this
		user_info_layer:setTouchEnabled(true)
		ScaleUtility:scaleNode( user_info_layer, contentScaleFactor )
		--user_info_layer.controller.avatar_bg:setScale(1.6 -- contentScaleFactor)
		self.rootNode:addChild( user_info_layer, INFO_ORDER)
		user_info_layer:setVisible(false)
	end
	local info = users[user_id]
	if info then
		user_info_layer.controller.lbl_info_name:setString(info.nick_name)
		user_info_layer.controller.lbl_info_gender:setString(info.gender and info.gender == 1 ? "男" : "女")
		user_info_layer.controller.lbl_info_beans:setString(info.score)
		local player = nil
		if next_user and user_id == next_user.user_id then
			player = next_user
 elseif  prev_user and user_id == prev_user.user_id then
			player = prev_user
 else 
			player = self_user
		end
		local avatarFrame = Avatar:getUserAvatarFrame(player)
		user_info_layer.controller.user_info_avatar:initWithSpriteFrame(avatarFrame)
		local win = info.win_count
		local lost = info.lost_count
		local percent = lost == 0 ? 100 : 100 -- win / (win + lost)
		user_info_layer.controller.lbl_info_achievement:setString(parseInt(percent) .. "%  " .. win .. "胜" .. lost .. "负")
		user_info_layer:setVisible(true)
	end
	
end

function theClass:onServerGameOver (data) 
	_is_playing = false
	cclog("onServerGameOver gaming to false")
	self:setHasGamingStarted(false)
	self:showGameOver(data)
end

function theClass:onServerLeave (data) 
	if g_user_id == data.user_id then
		cclog("被踢出房间")
		CCWebSocketBridge:sharedWebSocketBridge():notifyGameClose()
		CCDirector:getInstance():end()
 else 
		cclog("其他用户被踢出房间，刷新界面")
		if typeof data.players ~= "undefined" then
			self:updatePlayers(data.players)
		end
	end
end

function theClass:showGameOver(data) 
	-- self:stopUserAlarm()
	self.menu_tuoguan:setVisible(false)
	
	-- cclog("[showGameOver] data =>" .. )
	if game_over_layer == nil  then
		game_over_layer = CCBuilderReader:load("GameOverScene")
		game_over_layer.controller.delegate = this
		game_over_layer:setTouchEnabled(true)
		-- game_over_layer:setScale(contentScaleFactor)
		ScaleUtility:scaleNode( game_over_layer, contentScaleFactor )
		game_over_layer:setVisible(false)
		cclog("[showGameOver] game_over_layer" .. game_over_layer)
		self.rootNode:addChild( game_over_layer, GAME_OVER_ORDER)
	end
	game_over_layer:setVisible(false)
	self:retrievePlayers(data.players)
	
	local frameCache = CCSpriteFrameCache:getInstance()
	local game_result = data.game_result
	
	local win_flag = false
	local win_user = nil
	
	self_user_win_value = game_result.balance[self_user.user_id]
	

	win_flag = self_user_win_value > 0
	
	if win_flag then
		game_over_layer.controller.lbl_self_user_chong:setPosition(CCp(539,413))
		game_over_layer.controller.lbl_self_user_win:initWithSpriteFrame(frameCache:getSpriteFrame("win.png"))
		game_over_layer.controller.lbl_self_user_chong:initWithSpriteFrame(frameCache:getSpriteFrame("shenglichong.png"))
		SoundEffect:playWinEffect()
	end
	else 
		game_over_layer.controller.lbl_self_user_chong:setPosition(CCp(525,388))
		game_over_layer.controller.lbl_self_user_win:initWithSpriteFrame(frameCache:getSpriteFrame("lose.png"))
		game_over_layer.controller.lbl_self_user_chong:initWithSpriteFrame(frameCache:getSpriteFrame("shibaichong.png"))
		SoundEffect:playLoseEffect()
	end
	
	game_over_layer.controller.lbl_base:setString("" .. game_result.base)
	game_over_layer.controller.lbl_base_x:setString("" .. game_result.lord_value)
	game_over_layer.controller.lbl_bomb:setString("" .: (1+parseInt(game_result.bombs)))
	game_over_layer.controller.lbl_spring:setString("" .: (1+parseInt(game_result.spring)))
	game_over_layer.controller.lbl_anti_spring:setString("" .: (1+parseInt(game_result.anti_spring)))
	
	local self_name = self_user.nick_name-- .. "[" .. self_user.user_id .. "]"
	game_over_layer.controller.lbl_self_user_name:setString(self_name)
	game_over_layer.controller.lbl_self_user_win_value:setString("" ..  self_user_win_value)
	
	local next_user_name = next_user.nick_name-- .. "[" .. next_user.user_id .. "]"
	game_over_layer.controller.lbl_next_user_name:setString(next_user_name)
	game_over_layer.controller.lbl_next_user_win:setString( (next_user.user_id == game_result.winner_player_id) ? "胜利" : "失败" )
	game_over_layer.controller.lbl_next_user_win_value:setString("" .. game_result.balance[next_user.user_id])
	
	local prev_user_name = prev_user.nick_name-- .. "[" .. prev_user.user_id .. "]"
	game_over_layer.controller.lbl_prev_user_name:setString(prev_user_name)
	game_over_layer.controller.lbl_prev_user_win:setString( (prev_user.user_id == game_result.winner_player_id) ? "胜利" : "失败" )
	game_over_layer.controller.lbl_prev_user_win_value:setString("" .. game_result.balance[prev_user.user_id])

	local avatarFrame = Avatar:getUserAvatarFrame(self_user)
	game_over_layer.controller.game_over_avatar:initWithSpriteFrame(avatarFrame)
	game_over_layer.controller.game_over_avatar:setScale(0.7 -- contentScaleFactor)
	--game_over_layer.controller.game_over_avatar_bg:setScale(0.7)
	
	-- 延时3秒后显示game over layer
	local delayTime = CCDelayTime:create(2)
	local callFunc = CCCallFunc:create(function(sender)
		
		cclog("_has_gaming_started " .. _has_gaming_started)
		if _has_gaming_started then
			return
		end
		
		game_over_layer:setVisible(true)

		-- self:reset_all()
		self:showPlayCardMenu(false)
		self:hideGetLordMenu()
		
		---- self:stopUserAlarm()
		self:startAlarm( CCp(200, 100), 25, function() 
			game_over_layer:setVisible(false)
			self:reset_all()
			self:doStartReady()
		end)--
	end, this)
	local seq = CCSequence:create(delayTime, callFunc)
	self.rootNode:runAction(seq)
	local close_seq = CCSequence:create(CCDelayTime:create(7),CCCallFunc:create(function() 
		self:closeGameOver()
	end, this))
	close_seq:setTag(GAME_OVER_HIDE_ACTION_TAG)
	self.rootNode:runAction(close_seq)
end

function theClass:onReturn()

	-- CCDirector:getInstance():end()
	self:closeGameOver()
	SoundEffect:playButtonEffect()	
end

function theClass:closeGameOver() 
	self.menu_tuoguan:setVisible(false)
	self.alarm:setPosition(CCp(400,230))
	if game_over_layer and game_over_layer:isVisible( then
		game_over_layer:setVisible(false)
		cclog("on closeGameOver music")
		SoundEffect:playBackgroundMusic()
	end
	self:reset_all()
	self.menu_ready:setVisible(true)
	
	
	local tag = self.menu_huanzhuo:getTag()
	if tag ~= CHANGE_DESK_TAG then
		cclog("tag is 1000 set huanzhuo true")
		self.menu_huanzhuo:setVisible(true)
		self.menu_ready:setVisible(true)
 else 
		cclog("tag is 1001 set huanzhuo false")
		self.menu_huanzhuo:setVisible(false)
		self.menu_ready:setVisible(false)
	end
	
	self:startSelfUserAlarm( 20, function() 
		game_over_layer:setVisible(false)
		self:reset_all()
		cclog("do not auto start")
		self:exit()
	--	self:doStartReady()
	end)
	self.rootNode:stopActionByTag(GAME_OVER_HIDE_ACTION_TAG)
end

function theClass:onGameOverChangeDesk() 
	self:onChangeDesk()
end

-- TODO
function theClass:onChangeDesk()

	-- 通知服务器，换桌
	local event_data = player_id:g_user_id, poke_cards: ""end
	self.menu_huanzhuo:setTag(CHANGE_DESK_TAG)
	self.menu_huanzhuo:setVisible(false)
	self.menu_ready:setVisible(false)
	if game_over_layer then
		game_over_layer.controller.gm_change_table:setVisible(false)
	end
	g_WebSocket:trigger("g:user_change_table", event_data, function(data) 
		cclog("========game.user_change_table return suCCss: " .. JSON.stringify(data))
		self.menu_huanzhuo:setVisible(true)
		self.menu_ready:setVisible(true)
		self.menu_huanzhuo:setTag(ScaleUtility.NODE_SCALE_TAG_BASE)
		if game_over_layer then
			game_over_layer.controller.gm_change_table:setVisible(true)
		end
		self:onReturn()
		self:onEnterRoomSuCCss(data)
	end, function(data) 
		self.menu_huanzhuo:setVisible(true)
		self.menu_ready:setVisible(true)
		self.menu_huanzhuo:setTag(ScaleUtility.NODE_SCALE_TAG_BASE)
		if game_over_layer then
			game_over_layer.controller.gm_change_table:setVisible(true)
		end
		cclog("----------------game.user_change_table return failure: " .. JSON.stringify(data))
	end)
	cclog("MainSceneDelegate on change desk")
end

function theClass:onBgMusiCCicked() 
	self:showChatBoard()
end

function theClass:onEffectMusiCCicked() 
	SoundSettings.effect_music = not SoundSettings.effect_music
	self:updateEffectMusicMenuItem()
	self:saveSettings()
	SoundSettings.bg_music = not SoundSettings.bg_music
	self:updateBgMusicMenuItem()
	if SoundSettings.bg_music then
		SoundEffect:playBackgroundMusic()
	else
		SoundEffect:stopBackgroundMusic()

	self:saveSettings()
end

function theClass:updateBgMusicMenuItem() 
	--local frameCache = CCSpriteFrameCache:getInstance()
	local bg_frame_name = "top_panel_bg_music.png"
	
	if not SoundSettings.bg_music then
		bg_frame_name = "top_panel_bg_music_a.png"
 else 
	end
	
	self.menu_item_bg_music:setNormalSpriteFrame(frameCache:getSpriteFrame(bg_frame_name))--
end

function theClass:updateEffectMusicMenuItem() 
	local frameCache = CCSpriteFrameCache:getInstance()
	local bg_frame_name = "top_pane_sound.png"
	
	if not SoundSettings.effect_music then
		bg_frame_name = "top_pane_sound_a.png"
 else 
	end
	
	self.menu_item_effect_music:setNormalSpriteFrame(frameCache:getSpriteFrame(bg_frame_name))
end

function theClass:isTuoguan() 
	return self.menu_tuoguan:isVisible()
end

function theClass:doTuoguan(isNotServerAuto) 
	self.menu_tuoguan:setVisible(true)
	_playing_timeout = 2
	if not isNotServerAuto then
		--TODO 通知服务器托管
		local event_data = "user_id":g_user_idend
		g_WebSocket:trigger("g:on_tuo_guan", event_data, function(data) 
			cclog("========game.on_tuo_guan return suCCss: " .. JSON.stringify(data))
		end, function(data) 
			cclog("----------------game.on_tuo_guan return failure: " .. JSON.stringify(data))
		end)
	end
end

function theClass:cancelTuoguan(isNotServerAuto) 
	self.menu_tuoguan:setVisible(false)
	_playing_timeout = 0
	if not isNotServerAuto then
		--TODO 通知服务器取消托管
		local event_data = "user_id":g_user_idend
		g_WebSocket:trigger("g:off_tuo_guan", event_data, function(data) 
			cclog("========game.off_tuo_guan return suCCss: " .. JSON.stringify(data))
		end, function(data) 
			cclog("----------------game.off_tuo_guan return failure: " .. JSON.stringify(data))
		end)
	end
end

function theClass:doTuoguanPlaying() 
	local bSelfFirst = false
	-- 自己是第一个出牌的人?
	if lastPlayCard == nil or lastPlayer.user_id == g_user_id then
		bSelfFirst = true
	end
	
	if bSelfFirst then
		self:playMinSingleCard()
 else 
		self:doBuchu()
	end
	
end

function theClass:onCancelTuoguanClicked() 
	--self.menu_tuoguan:setVisible(false)
	_playing_timeout = 0--
	self:cancelTuoguan()
end

function theClass:onTuoguanClicked() 
	if self:isTuoguan() or not _is_playing then
		return
	
	self:doTuoguan()
	SoundEffect:playButtonEffect()
end

function theClass:onCloseClicked() 
	if _has_gaming_started then
		self:showExit()
 else 
		self:exit()
	end
end

function theClass:exit() 
	local event_data = user_id:g_user_idend
	g_WebSocket:trigger("g.leave_game", event_data)
	
	CCWebSocketBridge:sharedWebSocketBridge():notifyGameClose()
	CCDirector:getInstance():end()
end

-- 假如用户资料没有get下来，去服务器获取用户资料
function theClass:doGetUserProfileIfNeed(user_id) 
	if user_id then
		if not users[user_id] then
			cclog("user profile " .. user_id .. " not find")
			-- 获取用户资料
			local event_data = "user_id":user_idend
			g_WebSocket:trigger("g:get_rival_msg", event_data, function(data) 
				cclog("========game:get_rival_msg return suCCss: " .. JSON.stringify(data))
				users[user_id] = data
				data.user_id = user_id
			end, function(data) 
				cclog("----------------game:get_rival_msg return failure: " .. JSON.stringify(data))
			end)
			cclog("to get user profile")
 else 
			cclog("user profile " .. users[user_id].nick_name)
		end
	end
end

function theClass:onNextUserClicked() 
	cclog("onNextUserClicked")
	if next_user then
		self:showUserInfo(next_user.user_id)
	end
end

function theClass:onSelfUserClicked() 
	cclog("onSelfUserClicked")
	self:showUserInfo(self_user.user_id)
end

function theClass:onPrevUserClicked() 
	cclog("onPrevUserClicked")
	if prev_user then
		self:showUserInfo(prev_user.user_id)
	end
end

function theClass:updateSocket(status) 
	cclog("update socket status to " .. status)
	self.socket_label:setString(status)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 监听websocket连接事件
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
function theClass:subscribe_connect() 
	g_WebSocket:bind("connect_event", function(data)
		cclog("game listen connect event type " .. data.type .. ", url " .. data.url)
		self:updateSocket("socket: " .. data.type)
		local event = data.type
		if event == "connect_event_interrupted" then
			self:onSocketInterrupted()
 elseif  event == "connect_event_reopening" then
			self:onSocketReopening()
 elseif  event == "connect_event_openfail" then
			self:onSocketOpenFail()
 elseif  event == "connect_event_reopened" then
			cclog("call reopened function")
			self:onSocketReopened()
 elseif  event == "connect_event_closed" then
			self:onSocketClosed()
		end
		cclog("call function finish")
	end)
end

-- socket重连失败
function theClass:onSocketOpenFail() 
	-- 重连失败会导致关闭socket,这里不需要处理，进入socket关闭事件处理
	cclog("game onSocketOpenFail")
end

-- socket已关闭
function theClass:onSocketClosed() 
	cclog("game onSocketClosed")
	self:exit()
end

-- 网络已激活，正在重连
function theClass:onSocketReopening() 
	cclog("game onSocketReopening")
end

-- socket已经重连上，下一步需要restore connection
function theClass:onSocketReopened() 
	self:updateSocket("socket: reopened")
	cclog("game onSocketReopened")
	self:restoreConnection()
end

-- 恢复游戏状态
function theClass:restoreConnection() 
	g_WebSocket:trigger("g.restore_connection", "user_id": g_user_id, "token" : token, "notify_id":g_WebSocket.last_notify_idend,
			function(data) 
				self:onSocketRestored(data)
			end,
			function(data) 
				self:onSocketRestoreFail()
			end)
end

-- 网络断线
function theClass:onSocketInterrupted() 
	cclog("game onSocketInterrupted")
end

-- restore connection成功，恢复游戏
function theClass:onSocketRestored(data) 
	cclog("game onSocketRestored")
	--cclog("game onSocketRestored stop user alarm")
	-- self:stopUserAlarm()
	--cclog("game onSocketRestored reset all")
	-- self:reset_all()
	cclog("game onSocketRestored init websocket again")
--	self:init_websocket()
	cclog("game onSocketRestored")
	local game_info = data.game_info
	 self:init_channel(game_info)
	cclog("[game onSocketRestored] subscribe connect event")
--	self:subscribe_connect()
	cclog("bind pause resume events")
--	self:initPause()
	self:updateSocket("socket: restored")
	--解析事件，模拟发送
	local game_channel = game_info.channel_name
	for(local index in data.events) 
		local event = data.events[index]
		local name = event.notify_name
		local channel = event.is_channel == 1 ? "\"" .. game_channel .. "\"" : nil
		local template = "[[\"event_name\",\"id\":nl, \"suCCss\":nl, \"channel\":channel_value, \"data\":data_valueend]]"
		-- local event_msg = "[[\"" .. name .. "\",\"channel\":" .. channel .. ",data:" .. JSON:stringify(event.notify_data) .. "endend]]"
		local event_msg = template:replace("event_name", name):replace("channel_value", channel):replace("data_value", JSON:stringify(event.notify_data)):replace("nl", nil):replace("nl", nil)
		cclog("monitor event is " .. event_msg)
		local nd = CCWebSocketBridge:sharedWebSocketBridge()
		nd:onRead(event_msg)
	end
	self:updateTuoguan()
end

-- restore connection失败，退出游戏
function theClass:onSocketRestoreFail() 
	cclog("game onSocketRestoreFail")
	self:exit()
end

-- 接收java层传过来的数据
function theClass:initParam(data) 
	g_WebSocket:bind("pass_param", function(data) 
		cclog("game pass param: " .. JSON.stringify(data))
		self:initToken(data.token)
	end)
end

-- 接收java层传过来的token
function theClass:initToken(data) 
	token = data
	cclog("set token to " .. token)
end

-- 监听on pause和on resume事件
function theClass:initPause() 
	g_WebSocket:bind("on_pause", function(data)
		
		self:on_pause(data)
	end)
	g_WebSocket:bind("on_resume", function(data)
		self:on_resume(data)
	end)
end

--游戏界面已暂停
function theClass:on_pause(data) 
	cclog("game on pause: " .. JSON.stringify(data))
	local nd = CCWebSocketBridge:sharedWebSocketBridge()
	nd:setReady(false)
end

--游戏界面重新激活
function theClass:on_resume(data) 
	cclog("game on resume: " .. JSON.stringify(data))
	-- 延时1.5秒后启动websocket bridge发送事件
	local delayTime = CCDelayTime:create(1.5)
	local callFunc = CCCallFunc:create(function(sender)
		local nd = CCWebSocketBridge:sharedWebSocketBridge()
		nd:setReady(true)
	end, this)
	local seq = CCSequence:create(delayTime, callFunc)
	self.rootNode:runAction(seq)	
end

-- 弹出强退对话框
function theClass:showExit() 
	if not _has_gaming_started then
		return
	cclog("call exit ")
	if exit_layer == nil  then
		exit_layer = CCBuilderReader:load("ExitScene")
		exit_layer.controller.delegate = this
		exit_layer:setTouchEnabled(true)
		ScaleUtility:scaleNode( exit_layer, contentScaleFactor )
		self.rootNode:addChild( exit_layer, NOTIFY_ORDER)
		exit_layer:setVisible(false)
	end
	if exit_layer:isVisible( then
		return
	end
	exit_layer:setVisible(true)
end
-- 取消强退
function theClass:onExitCancel() 
	if exit_layer   then
		exit_layer:setVisible(false)
	end
end
-- 强制退出
function theClass:onExitConfirm() 
	self:exit()
end

function theClass:onToHall() 
	self:exit()
end