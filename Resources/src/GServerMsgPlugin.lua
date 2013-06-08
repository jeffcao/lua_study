GServerMsgPlugin = {}

--	游戏channel g_channel: game_info.channel_name
--	用户channel c_channel: "channel_" + self_user.user_id
--	聊天channel m_channel: game_info.channel_name + "chat"

function GServerMsgPlugin.bind(theClass)

	-- g_channel and c_channel
	function theClass:onServerStartGame(data)
		dump(data, "[game_start] data -> ")
	
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
	end
	
	-- g_channel and c_channel
	function theClass:onServerLeave(data)
		print("onServerLeave")
	end
	
	-- g_channel and c_channel
	function theClass:onServerGrabLordNotify(data)
		print("onServerGrabLordNotify")
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