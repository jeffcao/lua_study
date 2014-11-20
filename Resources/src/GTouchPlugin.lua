GTouchPlugin = {}

function GTouchPlugin.bind(theClass)

	theClass.begin = -1
	theClass.last_check = -1
	
	function theClass:onTouch(eventType, x, y)
		cclog("GTouchPlugin touch event:%s,x:%d,y:%d", eventType, x, y)
		if eventType == "began" then
			return self:onTouchBegan(ccp(x, y))
		elseif eventType == "moved" then
			return self:onTouchMoved(ccp(x, y))
		else
			return self:onTouchEnded(ccp(x, y))
		end
    end
	
	function theClass:getCardIndex(loc) 
		local result = -1
		if not self._all_cards then return result end
		for index = -#self._all_cards, -1 do
			local poke_card = self._all_cards[-index]
			if poke_card.card_sprite:boundingBox():containsPoint(loc) then
				cclog("in rect")
				result = -index
				break
			else
				cclog("not in rect")
			end
		end
		return result
	end

	function theClass:getCheckedCards() 
		local result = {}
		local checked_cards = {}
		--dump(self._all_cards, "all cards in get checked cards")
		for _, poke_card in pairs(self._all_cards) do
			if poke_card.card_sprite:getTag() == 1003 then
				table.insert(checked_cards, poke_card)
			end
		end
		local is_self_play = self.play_card_menu:isVisible()
		local is_last_card_self = self.lastPlayer and self.lastPlayer.user_id == self.g_user_id
		result = CardUtility.slide_card(lastPlayCard, checked_cards, is_self_play, is_last_card_self)
		--dump(result, "result")
		return result
	end
	
	function theClass:onTouchBegan(loc)
		self.begin = self:getCardIndex(loc)
		return true
	end
	
	--当触屏按下并移动事件被响应时的处理。
	function theClass:onTouchMoved(loc)
		if not self._all_cards then return end
		local cur_check = self:getCardIndex(loc)
		cclog("begin:%d, cur_check:%d", self.begin, cur_check)
		if cur_check == -1 or cur_check == self.last_check then
			return
		end
		if self.begin == -1 then
			self.begin = cur_check
		end
		self:move_check(self.begin, cur_check)
		self.last_check = cur_check
	end

	function theClass:move_check(start, end_p) 
		if start == end_p then
			return
		end
		
		local s = end_p
		if start < end_p then s = start end
		local e = start
		if start < end_p then e = end_p end
		local white = ccc3(255,255,255)
		local red = ccc3(187,187,187)
		for index = -#self._all_cards, -1 do
			local poke_card = self._all_cards[-index]
			if -index > e or -index < s then
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



	------------------------------------------------------------------
	 -- 点击牌，产生效果选取或取消的效果
	 -----------------------------------------------------------------
	function theClass:onTouchEnded(loc)
		if not self._all_cards then return end
		local checked_cards = self:getCheckedCards()
		if #checked_cards > 0 then
			for _, poke_card in pairs(self._all_cards) do
				if poke_card.picked then
					self:unpickPokeCard(poke_card)
				end
			end
			for _, poke_card in pairs(checked_cards) do
				if not poke_card.picked then
					self:pickPokeCard(poke_card)
				end
			end
			self.menu_item_reselect:setEnabled(true)
			self:playDealCardEffect()
	 	else 
			for index = -#self._all_cards, -1 do
				local poke_card = self._all_cards[-index]
				
				if  poke_card.card_sprite:boundingBox():containsPoint(loc) then
					if not poke_card.picked then
						self:pickPokeCard(poke_card)
		 			else 
						self:unpickPokeCard(poke_card)
					end
					
					self:playDealCardEffect()
					self.menu_item_reselect:setEnabled( #self:getPickedPokeCards() > 0 )
					break
				end
			end
		end
		for _, poke_card in pairs(self._all_cards) do
			if poke_card.card_sprite:getTag() ~= 1000 then
				poke_card.card_sprite:setColor(ccc3(255,255,255))
				poke_card.card_sprite:setTag(1000)
			end
		end
		begin = -1
		last_check = -1
	end

	function theClass:getPickedPokeCards () 
		local poke_cards = {}
		-- 选取所有选中的牌
		for _, poke_card in pairs(self._all_cards) do
			if poke_card.picked then
				table.insert(poke_cards, poke_card)
			end
		end
		
		return poke_cards
	end

	function theClass:pickPokeCard(poke_card) 
		if not poke_card.picked then
			cclog("[pickPokeCard] pick " .. poke_card.index)
			poke_card.card_sprite:runAction(CCMoveBy:create(0.08, ccp(0, 30 * self.y_ratio)))
			poke_card.picked = true
			--dump(self._all_cards, "all cards after pickPokeCard")
		end 
	end

	function theClass:unpickPokeCard(poke_card) 
		if poke_card.picked then
			cclog("[unpickPokeCard] unpick " .. poke_card.index)
			poke_card.card_sprite:runAction( CCMoveBy:create( 0.08, ccp(0, -30 * self.y_ratio)) )
			poke_card.picked = false
		end 
	end

	function theClass:unpickPokeCards(poke_cards) 
		for _, poke_card in pairs(poke_cards) do
			self:unpickPokeCard(poke_card)
		end
	end
	
	function theClass:pickPokeCards(poke_cards) 
		for _, poke_card in pairs(poke_cards) do
			self:pickPokeCard(poke_card)
		end
	end
end