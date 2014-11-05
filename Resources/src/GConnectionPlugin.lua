GConnectionPlugin = {}

function GConnectionPlugin.bind(theClass)
	-------------------------------------------------------------------------
	-- 初始化游戏频道事件
	-------------------------------------------------------------------------
	function theClass:init_channel(game_info) 
		local channel_name = game_info.channel_name
		cclog("[initChannel] channel_name => " .. channel_name)
		dump(self_user, "self_user ")
		cclog("self_user.user_id " .. self.self_user.user_id)
		local user_channel_name = "channel_" .. self.self_user.user_id
		self.g_WebSocket.channels[channel_name] = nil--先把原先的channel移除
		self.g_WebSocket.channels[user_channel_name] = nil
		self.g_channel = self.g_WebSocket:subscribe(channel_name)
		self.m_channel = self.g_WebSocket:subscribe(user_channel_name)
		self:bind_channel(self.g_channel)
		self:bind_channel(self.m_channel)
		--receive buy success message
		PurchasePlugin.bind_ui_buy_prop_event(self.m_channel)
		
		self:initSocket(self.g_WebSocket, "g.restore_connection", "g.ddz_socket_closed")
	end
	
	function theClass:bind_channel(channel) 
		channel:bind("g.player_join_notify", function(data) 
			self:onServerPlayerJoin(data)
		end)
		channel:bind("g.grab_lord_notify", function(data)
			self:onServerGrabLordNotify(data)
		end)
		channel:bind("g.play_card", function(data)
			self:onServerPlayCard(data)
		end)
		channel:bind("g.game_over", function(data)
			self:onServerGameOver(data)
		end)
		channel:bind("g.game_start", function(data)
			self:onServerStartGame(data)
		end)
		channel:bind("g.leave_game_notify", function(data)
			self:onServerLeave(data)
		end)
		channel:bind("ui.routine_notify", function(data)
			self:onServerNotify(data)
		end)
	end
	
	function theClass:close_game_websocket()
		print("[GConnectionPlugin:close_game_websocket()]")
		if GlobalSetting.g_WebSocket then
			GlobalSetting.g_WebSocket:close()
			GlobalSetting.g_WebSocket = nil
		end
	end

	--正在重连网络
	function theClass:onSocketReopening()
		cclog("game onSocketReopening")
		self:updateSocket("socket: reopening")
	end
	
	--网络已重新连接上
	function theClass:onSocketReopened()
		cclog("game onSocketReopened")
		--self:restoreConnection()
		--self:updateSocket("socket: reopened, restoring")
		
		self:restoreConnection()
		self:updateSocket("socket: reopened, restoring")
	end
	
	--网络重连失败
	function theClass:onSocketReopenFail()
		cclog("game onSocketReopenFail")
		notifyConnectFail()
		--self:exit()
	end

	--restore connection失败，退出游戏
	function theClass:onSocketRestoreFail()
		cclog("game onSocketRestoreFail")
		self:exit()
	end
	
	--restore connection成功
	function theClass:onSocketRestored(data)
		cclog("game onSocketRestored")
		self:updateSocket("socket: restored")
		local game_info = data.game_info
		self:init_channel(game_info)
		
		local game_channel = game_info.channel_name
		cclog("restore events length is " .. #data.events)
		for index = -#data.events, -1 do
			local event = data.events[-index]
			local msg = {}
			msg[1] = event.notify_name
			local attr = {}
			attr.channel = game_channel
			attr.data = event.notify_data
			msg[2] = attr
			dump(msg, "event_msg is ")
			self.g_WebSocket:new_message({msg})
		end
		self:updateTuoguan()
	end

	-- activity onPause
	function theClass:on_pause()
		cclog("theClass:on_pause")
		self:op_websocket(true)
	end
	
	-- activity onResume
	function theClass:on_resume()
		cclog("theClass:on_resume")
		Timer.add_timer(2.5, function() self:op_websocket(false) end)
	end
	
	function theClass:op_websocket(pause)
		cclog("op_websocket " .. tostring(pause))
		self.g_WebSocket:pause_event(pause)
	end

	--print("theClass.registerCleanup ==> ", theClass.registerCleanup)
	if theClass.registerCleanup then
		print("GConnectionPlugin register cleanup")
		theClass:registerCleanup("GConnectionPlugin.close_game_websocket", theClass.close_game_websocket)
	end
end