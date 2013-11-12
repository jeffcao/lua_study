ServerNotifyPlugin = {}

function ServerNotifyPlugin.bind(theClass)
	function theClass:onServerNotify(data)
		if not data then return end
		dump(data, "onServerNotify=>")
		local funcs = {self.onLevel, self.onVIP, self.onProp, self.onActivity, self.onTimeBeans, self.onBankrupt, self.onMusic, self.onUserLocked}
		local func = funcs[tonumber(data.notify_type)+1]
		if not func then return end
		func(self,data)
	end
	
	function theClass:onUserLocked(data)
		if self.check_locked and type(self.check_locked) == "function" then
			self:check_locked(data)
			require "src/WebsocketRails/Timer"
			local function to_login()
				local scene = createLoginScene()
				if self.on_kill_this_scene then
					self:on_kill_this_scene()
				end
				CCDirector:sharedDirector():popToRootScene()
				CCDirector:sharedDirector():replaceScene(scene)
			end
			Timer.add_timer(2, to_login, "to_login")
		end
	end
	
	function theClass:onMusic(data)
		if data.chat == 1 and self.onServerChatMessage then
			self:onServerChatMessage(data)
		end
		--重发的音效不播放出来
		if data.__srv_resend and data.__srv_resend >= 1 and data.voice == "1.mp3" then return end
		self:play_vip_voice(data.voice)
	end
	
	--破产
	function theClass:onBankrupt(data)
		local beans = data.beans
		local score = data.score
		local scene = CCDirector:sharedDirector():getRunningScene()
		if beans and scene.rootNode and scene.show_server_notify then
			--local message = "您获得了破产补助："..beans.."个豆子"
			local message = string.gsub(strings.snp_bankrupt, "beans", beans)
			print("破产补助=>", message)
			scene:show_server_notify(msg)
		end
		if scene.scene_on_bankrupt then
			scene:scene_on_bankrupt(data)
		end
	end
	
	--等级升级
	function theClass:onLevel(data)
		--local level = data.level
		dump(data, "on level up=>")
		GlobalSetting.current_user.game_level = data.game_level
		local scene = CCDirector:sharedDirector():getRunningScene()
		if scene.scene_on_level_up then
			scene:scene_on_level_up(data)
		end
	end
	
	--VIP升级
	function theClass:onVIP(data)
		local o_vip = GlobalSetting.vip
		local cjson = require "cjson"
		local is_become_vip = ((not o_vip) or (o_vip == cjson.null))
		if data then
			GlobalSetting.vip = data
		end
		local scene = CCDirector:sharedDirector():getRunningScene()
		if scene.scene_on_become_vip and is_become_vip then
			scene:scene_on_become_vip()
		end
	end
	
	--道具过期
	function theClass:onProp(data)
		local id = data.user_id
		local prop_id = data.prop_id
		self:play_vip_voice("27.mp3")
		local scene = CCDirector:sharedDirector():getRunningScene()
		if scene.scene_on_prop then
			scene:scene_on_prop(data)
		end
		--对于记牌器在游戏界面过期要进行处理
		--对于在我的道具界面，要进行刷新处理
	end
	
	--新活动，在其他界面之用刷新活动的data，在大厅界面且活动打开的时候，刷新活动的界面
	function theClass:onActivity(data)
	--数据和大厅界面获取活动的数据一样
		GlobalSetting.time_task = data
		GlobalSetting.time_task.weekday = get_weekday(data.week)
		local scene = CCDirector:sharedDirector():getRunningScene()
		if scene.on_activity_update then
			scene:on_activity_update(data)
		end
	end
	
	function theClass:onTimeBeans(data)
		cclog("onTimeBeans")
		local scene = CCDirector:sharedDirector():getRunningScene()
		dump(scene, 'running scene')
		if scene.rootNode and scene.show_server_notify and data.user_id then
			cclog('the running scene has root node')
			local msg = string.gsub(strings.snp_zaixianyouli, "您已在线满minutes分钟", tostring(data.online_time))
			msg = string.gsub(msg, "beans", tostring(data.beans))
			--local msg = "在线有礼：您已在线满"..tostring(data.online_time).."分钟，获得了"..tostring(data.beans).."个豆子"
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