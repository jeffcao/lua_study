GDataPlugin = {}

function GDataPlugin.bind(theClass) 

	function theClass:initData()
	--[[
		self.self_user_name = tolua.cast(self.self_user_name, "CCLabelTTF")
		self.prev_user_name = tolua.cast(self.prev_user_name, "CCLabelTTF")
		self.next_user_name = tolua.cast(self.next_user_name, "CCLabelTTF")
		self.self_user_poke_count = tolua.cast(self.self_user_poke_count, "CCLabelTTF")
		self.prev_user_poke_count = tolua.cast(self.prev_user_poke_count, "CCLabelTTF")
		self.next_user_poke_count = tolua.cast(self.next_user_poke_count, "CCLabelTTF")
		
		self.self_user_lord_value = tolua.cast(self.self_user_lord_value, "CCSprite")
		self.prev_user_lord_value = tolua.cast(self.prev_user_lord_value, "CCSprite")
		self.next_user_lord_value = tolua.cast(self.next_user_lord_value, "CCSprite")
		]]
		
		self.NOTIFY_ORDER = 4000--退出提示层
		self.GAME_OVER_ORDER = 3000--游戏结束层
		self.BUTTERFLY_ANIM_ORDER = 2210--动画层
		self.TOP_PANEL_ORDER = 2200--顶部栏层
		self.INFO_ORDER = 2110--用户资料层
		self.ALARM_ORDER = 2100--闹钟层
		self.INSECT_ANIM_ORDER = 2000
		self.CHAT_LAYER_ORDER = 2120--聊天板
		self.MSG_LAYER_ORDER = 2400--聊天气泡
		self.winSize = CCDirector:sharedDirector():getWinSize()
		self.y_ratio = self.winSize.height / 480.0
		self.x_ratio = self.winSize.width / 800.0
		self._playing_timeout = 0
		self.CHANGE_DESK_TAG  = 1001
		self.GAME_OVER_HIDE_ACTION_TAG = 1232
		self.DISPLAY_CHAT_ACTION_TAG = 1230
		PokeCard.sharedPokeCard(self.rootNode)
		print(g_shared_cards, #g_shared_cards)
		self.cardContentSize = g_shared_cards[1].card_sprite:getContentSize()
		self.CHAT_MSGS = {"快点吧，我等到花儿也谢了。",
                 "你的牌打得太好了！         ",
                 "别走，我们战斗到天亮。     ",
                 "又断线了，网络怎么这么差！！ ",
                 "大家好，很高兴见到各位！   "}
        self:initChat()
        self.users = {}
        
        self.rootNode:registerScriptTouchHandler(__bind(self.onTouch, self))
        self.rootNode:setTouchEnabled(true)
	end

	function theClass:retrievePlayers(player_list)
		self.self_user = nil
		self.prev_user = nil
		self.next_user = nil
		
		if #player_list > 1 then
			if player_list[1].user_id == self.g_user_id then
				self.self_user = player_list[1]
				self.next_user = player_list[2]
				if #player_list > 2 then
					self.prev_user = player_list[3]
				else
					self.prev_user = nil
				end
			elseif player_list[2].user_id == self.g_user_id then
				self.self_user = player_list[2]
				self.prev_user = player_list[1]
				if #player_list > 2 then
					self.next_user = player_list[3]
				else
					self.next_user = nil
				end
			elseif #player_list > 2 and player_list[3].user_id == self.g_user_id then
				self.self_user = player_list[3]
				self.prev_user = player_list[2]
				self.next_user = player_list[1]
			
			end
		else
			self.prev_user = nil
			self.next_user = nil
			self.self_user = player_list[1]
		end
		
		for index, _ in pairs(player_list) do
			local player = player_list[index]
		--TODO_LUA	self:doGetUserProfileIfNeed(player.user_id)
		end
		
	end
end