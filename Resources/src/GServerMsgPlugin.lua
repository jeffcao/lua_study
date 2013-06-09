GServerMsgPlugin = {}

--	游戏channel g_channel: game_info.channel_name
--	用户channel c_channel: "channel_" + self_user.user_id
--	聊天channel m_channel: game_info.channel_name + "chat"

function GServerMsgPlugin.bind(theClass)

	-- g_channel and c_channel
	function theClass:onServerStartGame(data)
		--dump(data, "[game_start] data -> ")
	
		--暂时注释掉，还不知道到底需不需要这个TODO
		--cclog("[game_start] user_id -> " .. data.user_id)
		
		if data.user_id ~= self.g_user_id then
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
		if data.next_user_id == self.next_user.user_id then
			self:updateLordValue(self.next_user_lord_value, 4)
			self:startNextUserAlarm(30, nil)
		elseif  data.next_user_id == self.prev_user.user_id then
			-- 是上家在叫地主
			self:updateLordValue(self.prev_user_lord_value, 4)
			self:startPrevUserAlarm(30, nil)
		end
		
		self:playDeliverCardsEffect()
		
		--_has_gaming_started = true
		cclog("onServerStartGame gaming to true")
		self:setHasGamingStarted(true)
	end
	
	-- g_channel and c_channel
	function theClass:onServerPlayerJoin(data)
		print("onServerPlayerJoin")
		if data.players then
			print("_has_gaming_started:" , self._has_gaming_started)
			if (self._has_gaming_started) then
				cclog("流局的join notify")
				self:stopUserAlarm()
				self:reset_all(data.players)
				self:startSelfUserAlarm(20, function()
					cclog("do not auto ready")
					self:exit()
				end)
				self.menu_ready:setVisible(true)
				self.menu_huanzhuo:setVisible(true)
			else
				cclog("一般的join notify")
				self:updatePlayers(data.players)
			end
		end
	
	end
	
	-- g_channel and c_channel
	function theClass:onServerLeave(data)
		--TODO_LUA_TEST
		print("onServerLeave")
		if (self.g_user_id == data.user_id) then
			cclog("被踢出房间")
			--TODO_LUA
			--cc.WebSocketBridge.sharedWebSocketBridge().notifyGameClose()
			local scene = createHallScene()
			CCDirector:sharedDirector():replaceScene(scene)
		else
			cclog("其他用户被踢出房间，刷新界面")
			if (data.players) then
				self:updatePlayers(data.players)
			end
		end
	end
	
	-- g_channel and c_channel
	function theClass:onServerGrabLordNotify(data)
		print("onServerGrabLordNotify")
		local log_prefix = "[onServerGrabLordNotify] "
	
		cclog("hide the get lord menu firstlynot ")
		self:hideGetLordMenu()
		-- 更新各玩家信息
		self:updatePlayers(data.players)
		-- 服务器通知自己已是地主？
		if data.lord_user_id == self.g_user_id then
			-- 从数据中提取出地主牌，加入到手上的牌里面
			local new_data = {}
			new_data.user_id = self.g_user_id
			local loard_ids = split(data.lord_cards, ",")
			table.combine(self._all_cards_ids, loard_ids)
			new_data.poke_cards = self._all_cards_ids
			new_data.grab_lord = 0
			new_data.players = data.players
			
			-- 开始牌局
			self:onServerStartGame(new_data)
			-- 显示出牌菜单
			self:showPlayCardMenu(true)
			self:showLordCards(data.lord_cards, data.lord_value)
	 	else 
			-- 自己不是地主，先更新各玩家的叫地主分数
			self:updateLordValue(self.self_user_lord_value, self.self_user.lord_value)
			self:updateLordValue(self.prev_user_lord_value, self.prev_user.lord_value)
			self:updateLordValue(self.next_user_lord_value, self.next_user.lord_value)
			
			local prev = data.prev_lord_user_id
			local value = 0
			if prev then
				if prev == self.prev_user.user_id then
					value = self.prev_user.lord_value
	 			elseif  prev == self.next_user.user_id then
					value = self.next_user.lord_value
	 			else 
					value = self.self_user.lord_value
				end
				cclog("grab_lord: value is " .. value)
				self:playGrabLordEffect(value, true)
			end
			
			
			-- 轮到自己叫地主?
			if data.next_user_id == self.g_user_id then
				-- 显示叫地主菜单
				local new_data = {}
				new_data.user_id = self.g_user_id
				new_data.players = data.players
				new_data.lord_value = data.lord_value
				self:showGrabLordMenu(new_data)
	 		elseif  data.lord_user_id > 0 then
				-- 已经有地主， 隐藏所有地主分数
				self:updateLordValue(self.self_user_lord_value, -1)
				self:updateLordValue(self.prev_user_lord_value, -1)
				self:updateLordValue(self.next_user_lord_value, -1)
				-- 开始地主的出牌计时提示
				if data.lord_user_id == self.next_user.user_id then
					self:startNextUserAlarm(30, nil)
				else
					self:startPrevUserAlarm(30, nil)
				end
				self:showLordCards(data.lord_cards, data.lord_value)
			 else 
				-- 还没有地主产生，也轮不到自己叫地主， 则标示出叫地主的玩家，并启动计时提示
				if data.next_user_id == self.next_user.user_id then
					self:updateLordValue(self.next_user_lord_value, 4)
					self:startNextUserAlarm(30, nil)
	 			elseif  data.next_user_id == self.prev_user.user_id then
					self:updateLordValue(self.prev_user_lord_value, 4)
					self:startPrevUserAlarm(30, nil)
				end
			end
		end
		self:setHasGamingStarted(true)
	end
	
	-- g_channel and c_channel
	function theClass:onServerPlayCard(data)
		print("onServerPlayCard")
	end
	
	-- g_channel and c_channel
	function theClass:onServerGameOver(data)
		print("onServerGameOver")
	end
	
	--c_channel
	function theClass:onServerChatMessage(data)
		print("onServerChatMessage")
	end
end