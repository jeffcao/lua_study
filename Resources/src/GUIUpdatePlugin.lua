
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
		
		local players = nil
		if data and data.players then players = data.players end
		-- 更新玩家信息
		self:updatePlayers(players)
	
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
			for _, poke_id in pairs(poke_card_ids) do
				table.insert(poke_cards, PokeCard.getCardById(poke_id))
			end
			table.sort(poke_cards, function(a, b) return b.index < a.index end)
			
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
		cclog("updateLordCard")
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		--cache:addSpriteFramesWithFile(plist_name)
		--lord_card_ui = tolua.cast(lord_card_ui,"CCSprite")
		if lord_poke_card then
			cclog("updateLordCard2:"..lord_poke_card.image_filename)
			local frame = cache:spriteFrameByName(lord_poke_card.image_filename)
			lord_card_ui:setDisplayFrame(frame)
			local scale = 0.4 * GlobalSetting.content_scale_factor
			lord_card_ui:setScale(scale)
		else
			local frame = cache:spriteFrameByName("poke_bg_small.png")
			lord_card_ui:setDisplayFrame(frame)
			local scale = 1.0 * GlobalSetting.content_scale_factor
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
		buchu_ui:setDisplayFrame(frameCache:spriteFrameByName("info_buchu.png"))
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
			card_id = trim_blank(card_id)
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
		
		lord_value = lord_value + 1
		print("updateLordValue lord_value:", lord_value)
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
	
	---------------------------------------------------------------------------------------------
	-- 显示出牌菜单
	--------------------------------------------------------------------------------------------
	function theClass:showPlayCardMenu(bShow) 
		self.play_card_menu:setVisible(bShow)
		if bShow then
			local buchuCallback = function() 
				self._playing_timeout = self._playing_timeout + 1
				self:doBuchu()
				if self._playing_timeout > 1 then
					self:doTuoguan()
				end
			end
			local chupaiCallback = function() 
				self._playing_timeout = self._playing_timeout + 1
				self:playMinSingleCard()
				if self._playing_timeout > 1 then
					self:doTuoguan()
				end
			end
			
			dump(self.lastPlayCard, "[showPlayCardMenu] lastPlayCard => ")
			local last_id = nil
			if self.lastPlayer then
				last_id = self.lastPlayer.user_id
			end
			print("[showPlayCardMenu] lastPlayer.user_id => " , last_id )
			print("[showPlayCardMenu] g_user_id => " , self.g_user_id )
			local bSelfFirst = false
			-- 自己是第一个出牌的人?
			if self.lastPlayCard == nil or self.lastPlayer.user_id == self.g_user_id then
				bSelfFirst = true
			end
			
			self.menu_item_buchu:setEnabled(not bSelfFirst)
			local res_enable = false
			for index,_ in pairs(self._all_cards) do
				if self._all_cards[index].picked then
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
		else
			self:stopUserAlarm()
		end
	end
	
	----------------------------------------------------------------------------
	-- 显示叫地主菜单
	----------------------------------------------------------------------------
	function theClass:showGrabLordMenu(data, needDelay) 
		if needDelay then
			cclog("grab lord delay 0.5s")
			-- 延时0.5秒后显示叫地主菜单
			local delayTime = CCDelayTime:create(0.5)
			-- self.rootNode.ws_data = data
			local callFunc = CCCallFunc:create(function()
				self:onGrabLordNotice(data)
			end)
			local seq = CCSequence:createWithTwoActions(delayTime, callFunc)
			self.rootNode:runAction(seq)	
	 	else 
			cclog("grab lord do not delay")
			self:onGrabLordNotice(data)
		end
	end
	
	function theClass:onGrabLordNotice(data) 
		if data.user_id == self.g_user_id  then
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
	
	--------------------------------------------------------------------------------
	-- 隐藏叫地主菜单
	--------------------------------------------------------------------------------
	function theClass:hideGetLordMenu() 
		self.menu_get_lord:setVisible(false)
	end
	
	function theClass:reset_card(card) 
		for _, poke_card in pairs(card.poke_cards) do 
			poke_card:reset()
		end
	end
	
	function theClass:onReturn()
		self:closeGameOver()
		self:playButtonEffect()	
	end
	
	function theClass:closeGameOver() 
		cclog("closeGameOver()")
		self.menu_tuoguan:setVisible(false)
		self.alarm:setPosition(ccp(400,230))
		if self.game_over_layer and self.game_over_layer:isShowing() then
			self.game_over_layer:dismiss()
			cclog("on closeGameOver music")
			self:playBackgroundMusic()
		end
		self:reset_all()
		self.menu_ready:setVisible(true)
		
		
		local tag = self.menu_huanzhuo:getTag()
		if tag ~= self.CHANGE_DESK_TAG then
			cclog("tag is 1000 set huanzhuo true")
			self.menu_huanzhuo:setVisible(true)
			self.menu_ready:setVisible(true)
	 	else 
			cclog("tag is 1001 set huanzhuo false")
			self.menu_huanzhuo:setVisible(false)
			self.menu_ready:setVisible(false)
		end
		
		self:startSelfUserAlarm( 20, function() 
			self.game_over_layer:dismiss()
			self:reset_all()
			self:exit()
		end)
		self.rootNode:stopActionByTag(self.GAME_OVER_HIDE_ACTION_TAG)
	end
	
	function theClass:onCloseClicked() 
		if self._has_gaming_started then
			self:showExit()
	 	else 
			self:exit()
		end
	end
	
	function theClass:showGameOver(data)
		self.menu_tuoguan:setVisible(false)
		if self.game_over_layer == nil  then
			self.game_over_layer = createGameOver()
			local change = __bind(self.onChangeDeskClicked, self)
			local close = __bind(self.closeGameOver, self)
			local tohall = __bind(self.exit, self)
			self.game_over_layer:initCallback(tohall, change, close)
			self.rootNode:addChild(self.game_over_layer, self.GAME_OVER_ORDER)
		end
		self:retrievePlayers(data.players)
		self.game_over_layer:initWith(self, data)
		
		-- 延时3秒后显示game over layer
		local delayTime = CCDelayTime:create(2)
		local show = function()
			print("_has_gaming_started " ,  self._has_gaming_started)
			
			if self._has_gaming_started then
				return
			end
			
			cclog("show game_over_layer")
			self.game_over_layer:show()
	
			self:showPlayCardMenu(false)
			self:hideGetLordMenu()
		end
		local callFunc = CCCallFunc:create(__bind(show, self))
		local seq = CCSequence:createWithTwoActions(delayTime, callFunc)
		self.rootNode:runAction(seq)
		local close_seq = CCSequence:createWithTwoActions(CCDelayTime:create(27),CCCallFunc:create(function() 
			self:closeGameOver()
		end))
		close_seq:setTag(self.GAME_OVER_HIDE_ACTION_TAG)
		self.rootNode:runAction(close_seq)
	end
	
	function theClass:onBgMusicClicked() 
		self:showChatBoard()
	end
	
	function theClass:onEffectMusicClicked()
		if not self.set_dialog then
			self.set_dialog = createSetDialog()
			self.rootNode:addChild(self.set_dialog, self.SET_LAYER_ORDER)
		end
		self.set_dialog:updateVolume()
		self.set_dialog:show()
		
	end
	
	function theClass:onPrevUserClicked()
		cclog("onPrevUserClicked")
		if self.prev_user then
			self:showUserInfo(self.prev_user.user_id)
		end
	end
	
	function theClass:onNextUserClicked()
		cclog("onNextUserClicked")
		if self.next_user then
			self:showUserInfo(self.next_user.user_id)
		end
	end
	
	function theClass:onSelfUserClicked()
		self:showUserInfo(self.self_user.user_id)
	end
	
	function theClass:showUserInfo(user_id) 
		if not user_id then
			return
		end
		cclog("call show user info ")
		if self.user_info_layer == nil  then
			self.user_info_layer = createPlayerInfo()
			self.user_info_layer:setVisible(false)
			self.rootNode:addChild(self.user_info_layer, self.INFO_ORDER)
		end
		
		local info = self.users[tostring(user_id)]
		if info then
			self.user_info_layer:initWithInfo(self, info)
			self.user_info_layer:setVisible(true)
		end
		--self.user_info_layer:setVisible(true)
	end
	
	function theClass:onCloseClicked() 
		if self._has_gaming_started then
			self:showExit()
	 	else 
			self:exit()
		end
	end
	
	
	-- 弹出强退对话框
	function theClass:showExit() 
		if not self._has_gaming_started then
			return
		end
		cclog("call exit ")
		if not self.exit_layer then
			self.exit_layer = createYesNoDialog(self.rootNode)
			self.exit_layer:setTitle("强制退出")
			self.exit_layer:setMessage("您正在游戏中，此时强退系统将最大输赢扣除您的豆子。")
			local yes_fn = function()
				self.exit_layer:dismiss()
				self:exit()
			end
			self.exit_layer:setYesButton(yes_fn)
			self.rootNode:reorderChild(self.exit_layer, self.NOTIFY_ORDER)
		end
		if self.exit_layer:isShowing() then
			return
		end
		self.exit_layer:show()
	end
	
	function theClass:exit()
		local event_data = {user_id = self.g_user_id}
		local exit_gaming_scene = function()
			local running_scene = CCDirector:sharedDirector():getRunningScene()
			if running_scene == self then 
				SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
				local scene = createHallScene()
				DialogLayerConvertor:purgeTouchDispatcher()
				CCDirector:sharedDirector():replaceScene(scene)
			else
				print("running scene is not self")
			end
		end
		Timer.add_timer(1, exit_gaming_scene)
		self.g_WebSocket:trigger("g.leave_game", event_data, exit_gaming_scene, exit_gaming_scene)
	end
	
	function theClass:onEnterRoomSuccess(data) 
		self.g_WebSocket:clear_notify_id()
		dump(data, "[onEnterRoomSuccess] data => ")
		local game_info = data.game_info
		self:refreshProps(data)
		self:updatePlayers(data.players)
		self:init_channel(game_info)
		self.menu_ready:setVisible(true)
		self.menu_huanzhuo:setVisible(true)
		
		cclog("[onEnterRoomSuCCss] update room base...")
		local room_base = "底注: " .. data.game_info.room_base
		
		self.dizhu:setString(room_base)
		
		cclog("[onEnterRoomSuCCss] start tick count...")
		self:startSelfUserAlarm(20, function()
			cclog("do not auto ready")
			self:exit()
		end)
		
		cclog("[onEnterRoomSuCCss] exit...")
	end
	
	function theClass:onEnterRoomFailure(data)
		dump(data, "enter room failure")
	end
	
	function theClass:onStartReadyClicked() 
		self:playButtonEffect()	
		self:doStartReady()
	end
	
	---------------------------------------------------------------------------------------------------
	-- 响应抢地主菜单事件 参数： sender - 被点击的菜单项 选择的分数 ＝ sender.tag - 1000 0 - 不叫 1 - 叫1分 2 -
	-- 叫2分 3 - 叫3分
	---------------------------------------------------------------------------------------------------
	function theClass:onGetLordClicked(tag, sender)
		-- 取叫的分数
		local lord_value = tag - 1000
		cclog("[onGetLord] lord_value => " .. lord_value)
	
		self:doGetLord(lord_value)
		self:playButtonEffect()	
	end
	
	function theClass:onBuchuClicked() 
		-- 如果自己是一个出牌的人，或者其他两人都选择不出，则自己必须出牌
		if  self.lastPlayCard == nil or self.lastPlayer.user_id == self.g_user_id  then
			return
		end
		self._playing_timeout = 0
		
		self:doBuchu()
	end
	
	function theClass:onReselectClicked() 
		local poke_cards = self:getPickedPokeCards()
		self:unpickPokeCards(poke_cards)
		self.menu_item_reselect:setEnabled(false)
		self:playButtonEffect()	
	end
	
	-------------------------------------------------------------------------
	-- 出牌
	-------------------------------------------------------------------------
	function theClass:onChupaiClicked()
		-- cclog("chu pai")
		local poke_cards = {}
		
		-- 选取所有选中的牌
		for index = -#self._all_cards, -1 do
			local card = self._all_cards[-index]
			if card.picked then
				table.insert(poke_cards, card)
			end
		end
		
		self:playButtonEffect()	
	
		-- 获取牌型
		local card = CardUtility.getCard(poke_cards)
		
		print("card.card_type => " , card.card_type , " , max_poke_value => " , card.max_poke_value .. ", card_length => " , card.card_length)
		-- 无效牌型？ 返回
		if card.card_type == CardType.NONE then
			return
		end
		
		self._playing_timeout = 0
		
		self:doChupai(card)
	end
	
	function theClass:onCardTipClicked() 
		local is_self_last_player = self.lastPlayer and self.lastPlayer.user_id == self.g_user_id
		local last_play_card = self.lastPlayCard
		local source_card = nil
		if self._all_cards then source_card = clone_table(self._all_cards) end
		local cards = CardUtility.tip_card(last_play_card, source_card, is_self_last_player)
		self:playButtonEffect()
		if #cards == 0 then
			cclog("tip is nil")
		--	self:onBuchuClicked()
			return
		end
		self:unpickPokeCards(self._all_cards)
		self:pickPokeCards(cards)
		self.menu_item_reselect:setEnabled(true)
		self:playDealCardEffect()
	end
	
	function theClass:onCancelTuoguanClicked()
		self:docancelTuoguan()
		self:playButtonEffect()
	end
	
	function theClass:onTuoguanClicked() 
		if self:isTuoguan() or not self._is_playing then
			return
		end
		
		self:doTuoguan()
		self:playButtonEffect()
	end
	
	function theClass:onChangeDeskClicked()
		self:doChangeDesk()
	end
	
	function theClass:updateSocket(status)
		cclog("update socket status to " .. status)
		--self.socket_label:setString(status)
	end
	
	function theClass:updateReady()
		if self._is_playing then
			self.menu_ready:setVisible(false)
			self.menu_huanzhuo:setVisible(false)
		end
	end
	
end