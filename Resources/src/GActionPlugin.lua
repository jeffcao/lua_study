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
			--TODO_LUA
			local event_data = {player_id=self.g_user_id, poke_cards=""}
			g_WebSocket:trigger("g:play_card", event_data, function(data) 
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
	
	function theClass:doTuoguan(isNotServerAuto) 
		self.menu_tuoguan:setVisible(true)
		self._playing_timeout = 2
		if not isNotServerAuto then
			--TODO_LUA
			--TODO 通知服务器托管
			local event_data = {user_id=self.g_user_id}
			g_WebSocket:trigger("g:on_tuo_guan", event_data, function(data) 
				print("========game.on_tuo_guan return suCCss: " , data)
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
	
		print("card.card_type => " , card.card_type .. " , max_poke_value => " , card.max_poke_value , ", card_length => " , card.card_length)
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
			self.lastPlayCard = self.card
			
			-- 产生出牌效果
			local poke_size = card.poke_cards[0].card_sprite:getContentSize().width / 2
			local center_point = ccp(winSize.width/2, 200)
			local step = 35 * 0.7
			local start_x = center_point.x - (step * (#(card.poke_cards))/2 + poke_size) * 0.7
			
			for index = -#(card.poke_cards), -1 do
				local poke_card = card.poke_cards[-index].card_sprite
				local moveAnim = CCMoveTo:create(0.2, ccp(start_x, center_point.y) )
				local scaleAnim = CCScaleTo:create(0.1, 0.7 * contentScaleFactor)
				local sequence = CCSequence:create(moveAnim, scaleAnim)
				poke_card:runAction( moveAnim )
				poke_card:runAction( scaleAnim )
				start_x = start_x + 35 * 0.7
		
				poke_card:getParent():reorderChild(poke_card, 19 + index)
			end
			
			if card.card_type == CardType.BOMB or card.card_type == CardType.ROCKET then
				cclog("炸弹效果")
				Explosion:explode(self.rootNode) --TODO bomb
			end
			
			-- 记住本次出牌
			self.lastCard = self.card
		
			local contains = function(value)
				for _,v in pairs(card.poke_cards) do
					if value == v then
						return true
					end
				end
				return false
			end
			-- 从手上的牌里面去除所出的牌
			self._all_cards = table.filter(self._all_cards, contains)
			
			-- 对已出牌取消选取标志
			for _, poke_card in pairs(card.poke_cards) do 
				poke_card.picked = false
			end
			
			-- 重新排列现有的牌
			self:align_cards()
		end
		
		-- 如果不是服务器自动帮助出牌，发送出牌命令
		if not isServerAutoPlay then
			--TODO_LUA
			-- 通知服务器，出牌
			local event_data = {player_id=g_user_id, poke_cards = card:getPokeIds():join(",")}
			g_WebSocket:trigger("g:play_card", event_data, function(data) 
				print("========game.play return suCCss: " , data)
			end, function(data) 
				print("----------------game.play return failure: " , data)
			end)
		end
		
		-- 隐藏出牌菜单
		self:showPlayCardMenu(false)
		if isServerAutoPlay then
			card.owner = self_user
			self:playCardEffect(card)
		end
	end
	
	function theClass:doGetLord(lord_value) 
		cclog("[onGetLord] lord_value => " .. lord_value)
		
		-- 通知服务器叫地主的分数
		local get_lord_event = {user_id=self.g_user_id, lord_value=lord_value}
		--TODO
		g_WebSocket:trigger("g.grab_lord", get_lord_event)
		-- 隐藏叫地主菜单，并显示叫的分数
		self:hideGetLordMenu()
		self:updateLordValue(self.self_user_lord_value, lord_value)
	end
end