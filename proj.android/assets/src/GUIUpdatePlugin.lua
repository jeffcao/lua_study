
GUIUpdatePlugin = {}

function GUIUpdatePlugin.bind(theClass)
	GPlayerUpdatePlugin.bind(theClass)
	--复位全部状态与显示
	function theClass:reset_all(data)
		-- 隐藏叫地主菜单
		self:hideGetLordMenu()
		self.play_card_menu:setVisible(false)
		self:showLordCards(nil, 0)
		self.menu_tuoguan:setVisible(false)
		
		self._playing_timeout = 0
		self._is_playing = false
		print("reset_all gaming to false")
		self:setHasGamingStarted(false)
	
		-- 复位全部牌的状态为初始状态
		self:reset_all_cards()
		
		-- 清除本用户上手牌
		self.lastCard = nil
		-- 清除上次出牌玩家
		self.lastPlayer = nil
		-- 清除上手出牌
		self.lastPlayCard = nil
		self.nextUserLastCard = nil
		self.prevUserLastCard = nil
		
		-- 更新玩家信息
		self:updatePlayers(data)
	
		-- 隐藏不出提示
		self:updatePlayerBuchu(self.self_user_lord_value, false)
		self:updatePlayerBuchu(self.prev_user_lord_value, false)
		self:updatePlayerBuchu(self.next_user_lord_value, false)
	end
	
	function theClass:hideGetLordMenu()
		self.menu_get_lord:setVisible(false)
	end
	
	function theClass:showLordCards(lord_card_ids, lord_value) 
		--提取出扑克牌
		local poke_card_ids = {}
		if lord_card_ids ~= nil and #lord_card_ids ~=0 then
			local tmp_ids = split(lord_card_ids,",")
			for _, tmp_id in pairs(tmp_ids) do
				if #tmp_id > 0 then
					table.insert(poke_card_ids, tmp_id)
				end
			end
		end

		if #poke_card_ids == 3  then
			self._is_playing = true
			
			local poke_cards = {}
			for i = 1, 3 do
				table.insert(poke_cards, PokeCard.getCardById(poke_id))
			end
			table.sort(poke_cards, function(a, b) return b.index > a.index end)
			
			self:updateLordCard(self.lord_poke_card_1, poke_cards[1])
			self:updateLordCard(self.lord_poke_card_2, poke_cards[2])
			self:updateLordCard(self.lord_poke_card_3, poke_cards[3])
			self.beishu:setString("倍数: " .. lord_value .. " 倍")
		 else 
			self:updateLordCard(self.lord_poke_card_1, nil)
			self:updateLordCard(self.lord_poke_card_2, nil)
			self:updateLordCard(self.lord_poke_card_3, nil)
		end
	end
	
	function theClass:updateLordCard(lord_card_ui, lord_poke_card)
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		--cache:addSpriteFramesWithFile(plist_name)
		lord_card_ui = tolua.cast(lord_card_ui,"CCSprite")
		if lord_poke_card then
			local frame = cache:spriteFrameByName(lord_poke_card.image_filename)
			lord_card_ui:setDisplayFrame(frame)
			local scale = 0.4 * GlobalSetting.content_scale_factor
			lord_card_ui:setScale(scale)
		else
			local frame = cache:spriteFrameByName("poke_bg_small.png")
			lord_card_ui:setDisplayFrame(frame)
			local scale = 2.0 * GlobalSetting.content_scale_factor
			lord_card_ui:setScale(scale)
		end
	end
	
	function theClass:setHasGamingStarted(value)
		if self._has_gaming_started == value then
			return
		end
		print("set _has_gaming_started to ", value)
		self._has_gaming_started = value
   end
   
   function theClass:reset_all_cards()
	   PokeCard.resetAll(self.rootNode)
	   self._all_cards = {}
   end
   
   function theClass:updatePlayerBuchu(buchu_ui, bBuchu)
		if not bBuchu then
			buchu_ui:setVisible(false)
			return
		end
		
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		buchu_ui:initWithSpriteFrame(frameCache:getSpriteFrame("info_buchu.png"))
		buchu_ui:setVisible(true)
  end
  
	 --------------------------------------------------------------------
	 -- 发牌
	 -----------------------------------------------------------------------
	function theClass:drawPokeCards(data) 
		-- self:resetself._all_cards()
		-- 根据服务器发的牌编号(a03, b03...)提取相应的扑克牌
		self._all_cards = {}
		local card_ids = {}
		self._all_cards_ids = data.poke_cards
		cclog("typeof data.poke_cards => " .. type(data.poke_cards))
		if type(data.poke_cards) == "string" then
			card_ids = split(data.poke_cards, ",")
		else
			card_ids = data.poke_cards
		end
		for _, card_id in pairs(card_ids) do
			card_id = trim(card_id)
			table.insert(self._all_cards, PokeCard.getCardById(card_id))
		end
		
		-- 从左到右，按牌面由大到小排序
		table.sort(self._all_cards, function(a,b) return a.index > b.index end)
		
		self:show_cards()		
	end
	
	--------------------------------------------------------------
	-- 显示牌:
	-------------------------------------------------------------
	function theClass:show_cards() 
		local p = ccp(20, (self.winSize.height - self.cardContentSize.height)/2)
		p.y = 0
		
		for index, _ in pairs(self._all_cards) do
			local card = self._all_cards[index].card_sprite
			local cardValue = self._all_cards[index].index
	
			print("cardValue: " , cardValue , ", card: " , card)
			card:setTag(0)
			card:setPosition( ccp((self.winSize.width - self.cardContentSize.width)/2, p.y) )
			card:setScale(GlobalSetting.content_scale_factor)
			card:setVisible(true)
	
		end
		self:align_cards()
	end
	
	---------------------------------------------------
	 -- 根据牌的数量重新排列展示
	 ------------------------------------------------------
	function theClass:align_cards() 
		
		self.self_user_poke_count:setString(#self._all_cards .. "")
		
		-- 无牌？返回
		if #self._all_cards < 1 then
			return
		end
		
		local p = ccp(0, 0)	
		local cardWidth = self.cardContentSize.width * GlobalSetting.content_scale_factor
		print("cardWidth", cardWidth)
		-- 计算牌之间的覆盖位置，最少遮盖30% 即显示面积最多为70%
		local step = (self.winSize.width) / (#self._all_cards + 1)
		if step > cardWidth * 0.7 then
			step = cardWidth * 0.7
		end
	
		-- 计算中心点
		local poke_size = cardWidth / 2
		local center_point = ccp(self.winSize.width/2, 0)
		
		-- 第一张牌的起始位置，必须大于等于0
		local start_x = center_point.x - (step * #self._all_cards/2 + poke_size / 2)
		if start_x < 0 then
			start_x = 0
		end
		
		print("start_x:",start_x, ",step:", step, ", ")
		p.x = start_x
		
		-- 排列并产生移动效果
		for index, _ in pairs(self._all_cards) do 
			local card = self._all_cards[index]
			if card.card_sprite:getParent() then
				card.card_sprite:getParent():reorderChild(card.card_sprite, index)
			end
			card.picked = false
			card.card_sprite:runAction( CCMoveTo:create(0.3, ccp(p.x, p.y) ) )
			p.x = p.x + step
		end		
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
	
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		local info_bujiao_frame = frameCache:spriteFrameByName("info_bujiao.png")
		local info_1fen_frame = frameCache:spriteFrameByName("1fen.png")
		local info_2fen_frame = frameCache:spriteFrameByName("2fen.png")
		local info_3fen_frame = frameCache:spriteFrameByName("3fen.png")
		local info_getting_lord_frame = frameCache:spriteFrameByName("be_lord.png")
		
		local value_frames = {}
		table.insert(value_frames, info_bujiao_frame)
		table.insert(value_frames, info_1fen_frame)
		table.insert(value_frames, info_2fen_frame)
		table.insert(value_frames, info_3fen_frame)
		table.insert(value_frames, info_getting_lord_frame)
		
		lord_value_ui:setDisplayFrame(value_frames[lord_value])
		lord_value_ui:setVisible(true)
	end
	
end