GDataPlugin = {}

function GDataPlugin.bind(theClass) 

	function theClass:initData()
		self.NOTIFY_ORDER = 4000--退出提示层
		self.GAME_OVER_ORDER = 3000--游戏结束层
		self.RANK_ORDER = 2300--排行榜层
		self.BUTTERFLY_ANIM_ORDER = 2210--动画层
		self.TOP_PANEL_ORDER = 2200--顶部栏层
		self.INFO_ORDER = 2110--用户资料层
		self.ALARM_ORDER = 2100--闹钟层
		self.INSECT_ANIM_ORDER = 2000
		self.CHAT_LAYER_ORDER = 2120--聊天板
		self.MSG_LAYER_ORDER = 2400--聊天气泡
		self.SET_LAYER_ORDER = 2130--设置板
		self.GAMING_OPTION_ORDER = 2140--弹出的组合按钮
		self.JIPAIQI_ORDER = 2000--记牌器
		self.BOMB_ORDER = 2500--爆炸
		self.winSize = CCDirector:sharedDirector():getWinSize()
		self.y_ratio = self.winSize.height / 480.0
		self.x_ratio = self.winSize.width / 800.0
		self._playing_timeout = 0
		self.CHANGE_DESK_TAG  = 1001
		self.GAME_OVER_HIDE_ACTION_TAG = 1232
		self.DISPLAY_CHAT_ACTION_TAG = 1230
		self.ROLE_FARMER = 1
		self.ROLE_LORD = 2
		PokeCard.sharedPokeCard(self.rootNode)
		print(g_shared_cards, #g_shared_cards)
		self.cardContentSize = 
			g_shared_cards[1].
			card_sprite:getContentSize()
		self.CHAT_MSGS = {"快点吧，我等到花儿也谢了。",
                 "你的牌打得太好了！         ",
                 "别走，我们战斗到天亮。     ",
                 "又断线了，网络怎么这么差！！ ",
                 "大家好，很高兴见到各位！   "}
        self:initChat()
        self.users = {}
        
        self.finding_lbl = CCLabelTTF:create(strings.gdp_finding, "Helvetica", 22)
        self.finding_lbl:setPosition(ccp(400, 80))
        self.rootNode:addChild(self.finding_lbl)
        
        self.rootNode:registerScriptTouchHandler(__bind(self.onTouch, self))
        self.rootNode:setTouchEnabled(true)
        self.rootNode:setKeypadEnabled(true)
        local key_fn = function(event)
        	print(event)
        	if event == "back" then
        		self:onReturnClicked()
        	end
        end
		self.rootNode:registerScriptKeypadHandler(key_fn)
        
        --TODO bind onPause和onResume事件
        GAnimationPlugin.sharedAnimation()

        self.g_WebSocket = GlobalSetting.g_WebSocket
        self.self_user = GlobalSetting.current_user
        self.g_user_id = self.self_user.user_id
        self.g_room_id = GlobalSetting.game_info.room_id
        self.self_user_name:setString("uid: " .. tonumber(self.g_user_id))
        self.menu_tuoguan:getParent():reorderChild(self.menu_tuoguan, 1000)
        
        self:updatePlayers({})
        self:updateLordValue(self.self_user_lord_value, -1)
		self:updateLordValue(self.prev_user_lord_value, -1)
		self:updateLordValue(self.next_user_lord_value, -1)

        
        self:loadSettings()
        
        if bg_music then
			self:playBackgroundMusic()
		end
		
		self.top_panel:getParent():reorderChild(self.top_panel, self.TOP_PANEL_ORDER)
		
		--Explosion.sharedExplosion()
		
		self.users = {}
		
		self.using_props = {}
		self.show_jipaiqi = 0
		
		self.socket_label:setVisible(true)
		
		--[[
		local notify_center = CCNotificationCenter:sharedNotificationCenter()
		notify_center:registerScriptObserver(self.rootNode, __bind(self.on_resume, self),"on_resume")
		notify_center:registerScriptObserver(self.rootNode, __bind(self.on_pause, self),"on_pause")
		]]
		
		NotificationProxy.registerScriptObserver(__bind(self.on_resume, self),"on_resume", self.scene_name)
		NotificationProxy.registerScriptObserver(__bind(self.on_pause, self),"on_pause", self.scene_name)
		
		
		self:enter_room(self.g_room_id)
		
		self.socket_label:setVisible(false)
	end
	
	function theClass:set_my_rank(rank, event)
		print(event, 'set my rank from ', self.myrank, 'to', rank)
		self.myrank = rank
		self:updateMyRank()
	end
	
	function theClass:refreshProps(data) 
		self.using_props = data.using_props
		self.show_jipaiqi = data.show_jipaiqi
	end

	function theClass:retrievePlayers(player_list)
		if not player_list then return end
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
			dump(player, "player_list[index]")
			local uid = player.user_id
			player.user_id = tonumber(uid)
			self:doGetUserProfileIfNeed(player.user_id)
		end
		
	end
end