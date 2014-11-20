GActionPlugin = {}

function GActionPlugin.bind(theClass)
	function theClass:doBuchu(isServerAuto) 
		-- 如果自己是一个出牌的人，或者其他两人都选择不出，则自己必须出牌
		if  (self.lastPlayCard == nil or self.lastPlayer.user_id == self.g_user_id) 
				and not isServerAuto then
			return
		end
		
		-- 隐藏上一手出的牌
		if self.lastCard  then
			self:reset_card(self.lastCard)
			self.lastCard = nil
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
			local event_data = {player_id=self.g_user_id, poke_cards=""}
			self.g_WebSocket:trigger("g.play_card", event_data, function(data) 
				print("========game.play return suCCss: " , data)
			end, function(data) 
				print("----------------game.play return failure: " , data)
			end)
		end
		
		-- 隐藏出牌菜单
		self:showPlayCardMenu(false)
		if isServerAuto then
			-- 不要就是打一手无效空牌
			local card = Card.new()
			card.owner = self.self_user
			self:playCardEffect(card)
		end
		if not isServerAuto then
			self:playButtonEffect()	
		end
	end
	
	function theClass:doSendChatMessage(data) 
		self.g_WebSocket:trigger("g.chat_in_playing", {prop_id=data, user_id=self.g_user_id}, function(data)
			print("========g.chat_in_playing succeess: " , data)
		end, function(data)
			print("========g.chat_in_playing failure: " , data)
		end)
		--self.c_channel:trigger("g.on_message", {msg = message, user_id = self.g_user_id})
	end
	
	function theClass:doTuoguan(isNotServerAuto) 
		self.menu_tuoguan:setVisible(true)
		self._playing_timeout = 2
		if not isNotServerAuto then
			--通知服务器托管
			local event_data = {user_id = self.g_user_id}
			self.g_WebSocket:trigger("g.on_tuo_guan", event_data, function(data) 
				print("========game.on_tuo_guan return succeess: " , data)
			end, function(data) 
				print("----------------game.on_tuo_guan return failure: " , data)
			end)
		end
	end
	
	function theClass:playMinSingleCard()
		local poke_cards = {self._all_cards[#self._all_cards]}
		local card = CardUtility:getCard(poke_cards)
		self:doChupai( card )	
	end
	
	---------------------------------------------------------------------------------------
	-- 出牌
	---------------------------------------------------------------------------------------
	function theClass:doChupai(card, isServerAutoPlay)
		dump(card, "doChupai")
		print("card.card_type => " .. card.card_type .. " .. max_poke_value => " .. card.max_poke_value .. ".. card_length => " .. card.card_length)
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
		if self.lastPlayCard  and self.lastPlayer.user_id ~= self.g_user_id then
			-- 上一手牌不是自己出的，则要求本次出的牌大于上手牌
			if not CardUtility.compare(card, self.lastPlayCard) then
				return
			end
		end
		
		if isServerAutoPlay then
			-- 隐藏上一手出的牌
			if self.lastCard  then
				self:reset_card(self.lastCard)
				self.lastCard = nil
			end 
			
			-- 记住本人是当前最后一个出牌人，和所出的牌
			self.lastPlayer = self.self_user
			self.lastPlayCard = card
			
			-- 产生出牌效果
			local poke_size = card.poke_cards[1].card_sprite:getContentSize().width / 2
			local center_point = ccp(self.winSize.width/2, 200)
			local step = 35 * 0.7
			local start_x = center_point.x - (step * (#(card.poke_cards))/2 + poke_size) * 0.7
			
			for index = -#(card.poke_cards), -1 do
				cclog("index is ".. (-index))
				cclog("card_value is "..card.poke_cards[-index].poke_value)
				local poke_card = card.poke_cards[-index].card_sprite
				local moveAnim = CCMoveTo:create(0.2, ccp(start_x, center_point.y) )
				cclog("position is (%d,%d)", start_x, center_point.y)
				local scaleAnim = CCScaleTo:create(0.1, 0.7 * GlobalSetting.content_scale_factor)
				local sequence = CCSequence:createWithTwoActions(moveAnim, scaleAnim)
				poke_card:runAction( moveAnim )
				poke_card:runAction( scaleAnim )
				
				start_x = start_x + 35 * 0.7
		
				poke_card:getParent():reorderChild(poke_card, 19 + index)
			end
			
			if card.card_type == CardType.BOMB then
				cclog("炸弹效果")
				Explosion.explode(self.rootNode, self.BOMB_ORDER)
			elseif card.card_type == CardType.ROCKET then
				cclog("DDZRocket")
				DDZRocket.fly(self.rootNode, self.BOMB_ORDER)
			elseif card.card_type == CardType.PLANE or card.card_type == CardType.PLANE_WITH_WING  then
				cclog("DDZPlane")
				DDZPlane.fly(self.rootNode, self.BOMB_ORDER)
			end
			
			-- 记住本次出牌
			self.lastCard = card
		
			local not_contains = function(value)
				for _,v in pairs(card.poke_cards) do
					if value == v then
						return false
					end
				end
				return true
			end
			-- 从手上的牌里面去除所出的牌
			self._all_cards = table.filter(self._all_cards, not_contains)
			
			-- 对已出牌取消选取标志
			for _, poke_card in pairs(card.poke_cards) do 
				poke_card.picked = false
			end
			
			-- 重新排列现有的牌
			cclog("self:align_cards()")
			self:align_cards()
		end
		
		-- 如果不是服务器自动帮助出牌，发送出牌命令
		if not isServerAutoPlay then
			-- 通知服务器，出牌
			local event_data = {player_id=g_user_id, poke_cards = table.join(card:getPokeIds(), ",")}
			self.g_WebSocket:trigger("g.play_card", event_data, function(data) 
				print("========game.play return suCCss: " , data)
			end, function(data) 
				print("----------------game.play return failure: " , data)
			end)
		end
		
		-- 隐藏出牌菜单
		self:showPlayCardMenu(false)
		if isServerAutoPlay then
			card.owner = self.self_user
			self:playCardEffect(card)
		end
	end
	
	function theClass:doGetLord(lord_value) 
		cclog("[onGetLord] lord_value => " .. lord_value)
		AppStats.event(UM_GRAB_LORD, tostring(lord_value))
		-- 通知服务器叫地主的分数
		local get_lord_event = {user_id=self.g_user_id, lord_value=lord_value}
		self.g_WebSocket:trigger("g.grab_lord", get_lord_event)
		-- 隐藏叫地主菜单，并显示叫的分数
		self:hideGetLordMenu()
		self:updateLordValue(self.self_user_lord_value, lord_value)
	end
	
	-----------------------------------------------------------------------------------------
	-- 下家出牌
	-----------------------------------------------------------------------------------------
	function theClass:doPrevUserPlayCard(card) 
	
		-- 隐藏上一手出的牌
		if self.prevUserLastCard  then
			self:reset_card(self.prevUserLastCard)
			self.prevUserLastCard = nil
		end
		
		if card.card_type == CardType.NONE then
			-- 无效牌型，表示不出牌
			self:updatePlayerBuchu(self.prev_user_lord_value, true)
			return			
	 	else 
			-- 有效出牌，隐藏不出标签
			self:updatePlayerBuchu(self.prev_user_lord_value, false)
			-- 保存为最后出牌信息
			self.lastPlayer = self.prev_user
			self.lastPlayCard = card
		end
		
		
		-- 初始化出牌位置
		local start_point = ccp(-100, self.winSize.height + 100)
		for index = -#(card.poke_cards), -1 do 
			local p = card.poke_cards[-index].card_sprite
			p:setPosition(start_point)
			p:setScale(GlobalSetting.content_scale_factor)
			p:setTag(0)
			-- self.rootNode:addChild(p)
			p:getParent():reorderChild(p, 100 + index )
			p:setVisible(true)
		end
	
		-- 产生出牌效果
		local poke_size = card.poke_cards[1].card_sprite:getContentSize().width / 2
		local center_point = ccp(self.winSize.width/2, self.cardContentSize.height * GlobalSetting.content_scale_factor + 15)
		local step = 35 * 0.7
		local start_x = 165
		local start_y = 300
		
		for index = -#(card.poke_cards), -1 do 
			local poke_card = card.poke_cards[-index].card_sprite
			local moveAnim = CCMoveTo:create(0.2, ccp(start_x, start_y) )
			local scaleAnim = CCScaleTo:create(0.1, 0.7 * GlobalSetting.content_scale_factor)
			local sequence = CCSequence:createWithTwoActions(moveAnim, scaleAnim)
			poke_card:runAction( moveAnim )
			poke_card:runAction( scaleAnim )
			start_x = start_x + 35 * 0.7
	
			-- poke_card:getParent():reorderChild(poke_card, -10 - index)
			poke_card:setTag(-1)
		end
		
		if card.card_type == CardType.BOMB or card.card_type == CardType.ROCKET then
			cclog("炸弹效果")
			Explosion.explode(self.rootNode, self.BOMB_ORDER)
		elseif card.card_type == CardType.ROCKET then
			cclog("DDZRocket")
			DDZRocket.fly(self.rootNode, self.BOMB_ORDER)
		elseif card.card_type == CardType.PLANE or card.card_type == CardType.PLANE_WITH_WING  then
			cclog("DDZPlane")
			DDZPlane.fly(self.rootNode, self.BOMB_ORDER)
		end
		
		-- 记住本次出牌
		self.prevUserLastCard = card
		
	end
		
	------------------------------------------------------------------------------------------
	-- 下家出牌
	------------------------------------------------------------------------------------------
	function theClass:doNextUserPlayCard(card) 
		-- 隐藏上一手出的牌
		if self.nextUserLastCard  then
			self:reset_card(self.nextUserLastCard)
			self.nextUserLastCard = nil
		end
		
		if card.card_type == CardType.NONE then
			-- 无效牌型，表示不出牌
			self:updatePlayerBuchu(self.next_user_lord_value, true)
			return			
	 	else 
			-- 有效出牌，隐藏不出标签
			self:updatePlayerBuchu(self.next_user_lord_value, false)
			-- 保存为最后出牌信息
			self.lastPlayer = self.next_user
			self.lastPlayCard = card
		end
		
		-- 初始化出牌位置
		local start_point = ccp(self.winSize.width + 100, self.winSize.height + 100)
		for index = -#(card.poke_cards), -1 do 
			local p = card.poke_cards[-index].card_sprite
			p:setPosition(start_point)
			p:setScale(GlobalSetting.content_scale_factor)
			p:setTag(0)
			p:setVisible(true)
			-- self.rootNode:addChild(p)
			p:getParent():reorderChild(p, 100 + index )
		end
	
		-- 产生出牌效果
		local poke_size = card.poke_cards[1].card_sprite:getContentSize().width / 2
		local center_point = ccp(self.winSize.width/2, self.cardContentSize.height * GlobalSetting.content_scale_factor + 15)
		local step = 35 * 0.7
		local start_x = 585
		local start_y = 300
		
		for index, _ in pairs(card.poke_cards) do
			local poke_card = card.poke_cards[index].card_sprite
			local moveAnim = CCMoveTo:create(0.2, ccp(start_x, start_y) )
			local scaleAnim = CCScaleTo:create(0.1, 0.7 * GlobalSetting.content_scale_factor)
			local sequence = CCSequence:createWithTwoActions(moveAnim, scaleAnim)
			poke_card:runAction( moveAnim )
			poke_card:runAction( scaleAnim )
			start_x = start_x - 35 * 0.7
	
			-- poke_card:getParent():reorderChild(poke_card, -10 - index)
			poke_card:setTag(-1)
		end
		
		if card.card_type == CardType.BOMB then
			cclog("炸弹效果")
			Explosion.explode(self.rootNode, self.BOMB_ORDER)
		elseif card.card_type == CardType.ROCKET then
			cclog("DDZRocket")
			DDZRocket.fly(self.rootNode, self.BOMB_ORDER)
		elseif card.card_type == CardType.PLANE or card.card_type == CardType.PLANE_WITH_WING  then
			cclog("DDZPlane")
			DDZPlane.fly(self.rootNode, self.BOMB_ORDER)
		end
		
		-- 记住本次出牌
		self.nextUserLastCard = card
	end
	
	
	function theClass:doChangeDesk()
		-- 通知服务器，换桌
		local event_data = {player_id = self.g_user_id, poke_cards = ""}
		self.menu_huanzhuo:setTag(self.CHANGE_DESK_TAG)
		self.menu_huanzhuo:setVisible(false)
		self.menu_ready:setVisible(false)
		if self.game_over_layer and self.game_over_layer:isShowing() then
			self.game_over_layer:dismiss()
		end
		self.g_WebSocket:trigger("g.user_change_table", event_data, function(data) 
			dump(data, "========game.user_change_table return succss: ")
			self.menu_huanzhuo:setVisible(true)
			self.menu_ready:setVisible(true)
			self.menu_huanzhuo:setTag(1000)
			if self.game_over_layer and self.game_over_layer:isShowing() then
				self.game_over_layer:dismiss()
			end
			self:onReturn()
			self:onEnterRoomSuccss(data)
		end, function(data) 
			self.menu_huanzhuo:setVisible(true)
			self.menu_ready:setVisible(true)
			self.menu_huanzhuo:setTag(1000) 
			if self.game_over_layer and self.game_over_layer:isShowing() then
				self.game_over_layer:dismiss()
			end
			dump(data, "----------------game.user_change_table return failure: ")
		end)
		cclog("MainSceneDelegate on change desk")
	end
	
	function theClass:enter_room(room_id) 
		local event_data = {user_id = self.g_user_id, room_id = self.g_room_id}
		self.g_WebSocket:trigger("g.enter_room", event_data, 
			__bind(self.onEnterRoomSuccess, self),
			__bind(self.onEnterRoomFailure, self))
	end
	
	function theClass:loadSettings() 
		--[[
		local ls = CCUserDefault:sharedUserDefault()
		bg_music = ls:getStringForKey("bg_music") ~= "0"
		effect_music = ls:getStringForKey("effect_music") ~= "0"
		
		print("[MainSceneDelegate.loadSettings] bg_music => " , bg_music)
		print("[MainSceneDelegate.loadSettings] effect_music => " , effect_music)
		]]
	end
	
	function theClass:saveSettings() 
	
	--[[
		local ls = CCUserDefault:sharedUserDefault()
		local bg = "0"
		if bg_music then bg = "1" end
		local effect = "0"
		if effect_music then effect = "1" end
		ls:setStringForKey("bg_music", bg)
		ls:setStringForKey("effect_music", effect)
	]]
	end
	
	function theClass:doStartReady(isServer) 
		self:stopUserAlarm()
		self:reset_all()
		self.menu_ready:setVisible(false)
		self.menu_huanzhuo:setVisible(false)
		-- 只有在客户端发起的准备才需要调用此接口，若是恢复数据，则不用通知服务器
		if not isServer then
			self.g_WebSocket:trigger("g.ready_game", {user_id = self.g_user_id})
		end
			
	end
	--[[
	function theClass:doGetLord(lord_value) 
		cclog("[onGetLord] lord_value => " .. lord_value)
		
		-- 通知服务器叫地主的分数
		local get_lord_event = {user_id = self.g_user_id, lord_value = lord_value}
		self.g_WebSocket:trigger("g.grab_lord", get_lord_event)
		-- 隐藏叫地主菜单，并显示叫的分数
		self:hideGetLordMenu()
		self:updateLordValue(self.self_user_lord_value, lord_value)
	end
	]]
	function theClass:docancelTuoguan(isNotServerAuto) 
		self.menu_tuoguan:setVisible(false)
		self._playing_timeout = 0
		if not isNotServerAuto then
			local event_data = {user_id = self.g_user_id}
			self.g_WebSocket:trigger("g.off_tuo_guan", event_data, function(data) 
				print("========game.off_tuo_guan return success: " , data)
			end, function(data) 
				print("========game.off_tuo_guan return failure: " , data)
			end)
		end
	end
	
	function theClass:use_prop_bought(data)
		dump(data, 'use prop bought')
		local prop_id = data.id
		local name = data.name
		local event_data = {user_id = self.g_user_id, prop_id = prop_id}
		local failure_func = function(data) dump(data, 'use prop failure') end
		local success_func = function(data) 
			dump(data, 'use prop success') 
			if name == '记牌器' then
				self:set_jipaiqi_enable(true)
				if not self.card_roboter:isShowing() and self._is_playing then
					self.card_roboter:show()
				end
			end
		end
		self.g_WebSocket:trigger("g.use_cate", event_data, success_func, failure_func)
	end
	
	function theClass:get_user_profile()
		self:doGetUserProfileIfNeed(self.g_user_id, true) 
	end
	
	-- 假如用户资料没有get下来，去服务器获取用户资料
	function theClass:doGetUserProfileIfNeed(user_id, mandantory) 
		if not user_id then
			cclog("user_id is nil")
			return
		end
		user_id = tostring(user_id)
		if not self.users[user_id] or mandantory then
			cclog("user profile " .. user_id .. " not find")
			-- 获取用户资料
			local event_data = {user_id = user_id}
			self.g_WebSocket:trigger("g.get_rival_msg", event_data, function(data) 
					print("========game:get_rival_msg return success: " , data)
					self.users[user_id] = data
					data.user_id = user_id
					self:updatePlayerLevels()
					print("game:get_rival_msg, GlobalSetting.current_user.user_id=", GlobalSetting.current_user.user_id)
					print("game:get_rival_msg, user_id=", user_id)
					print("game:get_rival_msg, GlobalSetting.current_user.user_id==user_id, ", GlobalSetting.current_user.user_id == user_id)
					if GlobalSetting.current_user.user_id == tonumber(user_id) then
						print("game:get_rival_msg, refesh my data")
						GlobalSetting.current_user.score = data.score
						GlobalSetting.current_user.win_count = data.win_count
						GlobalSetting.current_user.lost_count = data.lost_count
					end
				end, 
				function(data) 
					print("========game:get_rival_msg return failure: " , data) 
				end)
			cclog("to get user profile")
	 	else 
			cclog("user profile " .. self.users[user_id].nick_name)
		end
	end
	
	function theClass:doChangeDesk()
		-- 通知服务器，换桌
		local event_data = {player_id = self.g_user_id, poke_cards = ""}
		self.menu_huanzhuo:setTag(self.CHANGE_DESK_TAG)
		self.menu_huanzhuo:setVisible(false)
		self.menu_ready:setVisible(false)
		if self.game_over_layer then
			self.game_over_layer.gm_change_table_layer:setVisible(false)
		end
		self.g_WebSocket:trigger("g.user_change_table", event_data, function(data) 
			print("========game.user_change_table return success: " , data)
			self.menu_huanzhuo:setVisible(true)
			self.menu_ready:setVisible(true)
			self.menu_huanzhuo:setTag(1000)
			if self.game_over_layer then
				self.game_over_layer.gm_change_table_layer:setVisible(true)
			end
			self:onReturn()
			self:onEnterRoomSuccess(data)
		end, function(data) 
			self.menu_huanzhuo:setVisible(true)
			self.menu_ready:setVisible(true)
			self.menu_huanzhuo:setTag(1000)
			if self.game_over_layer then
				self.game_over_layer.gm_change_table_layer:setVisible(true)
			end
			print("----------------game.user_change_table return failure: " , data)
		end)
		cclog("MainSceneDelegate on change desk")
	end
end