ServerNotifyPlugin = {}

function ServerNotifyPlugin.bind(theClass)
	function theClass:onServerNotify(data)
		if not data then return end
		dump(data, "onServerNotify=>")
		local funcs = {self.onLevel, self.onVIP, self.onProp, self.onActivity, self.onTimeBeans, self.onBankrupt, self.onMusic}
		local func = funcs[tonumber(data.notify_type)+1]
		if not func then return end
		func(self,data)
	end
	
	function theClass:onMusic(data)
		self:play_vip_voice(data.voice)
		if data.chat == 1 and self.onServerChatMessage then
			self:onServerChatMessage(data)
		end
	end
	
	function theClass:onBankrupt(data)
	end
	
	function theClass:onLevel(data)
	end
	
	function theClass:onVIP(data)
	end
	
	function theClass:onProp(data)
	end
	
	function theClass:onActivity(data)
	end
	
	function theClass:onTimeBeans(data)
		cclog("onTimeBeans")
		local scene = CCDirector:sharedDirector():getRunningScene()
		dump(scene, 'running scene')
		if scene.rootNode and scene.show_server_notify and data.user_id then
			cclog('the running scene has root node')
			local msg = "在线有礼：您已在线满"..tostring(data.online_time).."分钟，获得了"..tostring(data.beans).."个豆子"
			scene:show_server_notify(msg)
			GlobalSetting.current_user.score = data.score
			GlobalSetting.current_user.game_level = data.game_level
			if scene.users then
				local usr_info = scene.users[data.user_id]
				if usr_info then
					usr_info.score = data.score
					usr_info.game_level = data.game_level
				end
			end
		end
	end
end