GConnectionPlugin = {}

function GConnectionPlugin.bind(theClass)
	-------------------------------------------------------------------------
	-- 初始化游戏频道事件
	-------------------------------------------------------------------------
	function theClass:init_channel(game_info) 
		local channel_name = game_info.channel_name
		cclog("[initChannel] channel_name => " .. channel_name)
		dump(self_user, "self_user ")
		cclog("self_user.user_id " .. self_user.user_id)
		local user_channel_name = "channel_" .. self_user.user_id
		g_WebSocket.channels[channel_name] = nil--先把原先的channel移除
		g_WebSocket.channels[user_channel_name] = nil
		self.g_channel = g_WebSocket:subscribe(channel_name)
		self.m_channel = g_WebSocket:subscribe(user_channel_name)
		self.c_channel = g_WebSocket:subscribe(channel_name .. "_chat")
		self.c_channel:bind("g:on_message", function(data) 
			self:onServerChatMessage(data)
		end)
		self:bind_channel(self.g_channel)
		self:bind_channel(self.m_channel)
	end
	
	function theClass:bind_channel(channel) 
		channel:bind("g:player_join_notify", function(data) 
			self.onServerPlayerJoin(data)
		end)
		channel:bind("g:grab_lord_notify", function(data)
			self.onServerGrabLordNotify(data)
		end)
		channel:bind("g:play_card", function(data)
			self.onServerPlayCard(data)
		end)
		channel:bind("g:game_over", function(data)
			self.onServerGameOver(data)
		end)
		channel:bind("g:game_start", function(data)
			self.onServerStartGame(data)
		end)
		channel:bind("g.leave_game_notify", function(data)
			self:onServerLeave(data)
		end)
	end
end