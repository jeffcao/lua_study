ServerNotifyPlugin = {}
require 'src.PromptPlugin'
require 'MatchResult'
function ServerNotifyPlugin.bind(theClass)
	function theClass:onServerNotify(data)
		if not data then return end
		dump(data, "onServerNotify=>")
		local funcs = {self.onLevel, self.onVIP, self.onProp, self.onActivity, 
					   self.onTimeBeans, self.onBankrupt, self.onMusic, self.onUserLocked, 
					   self.onGamesBeans, self.onWinsBeans, self.onContinueWinsBeans, self.onPropPrompt,
					   self.onContinueLoginsBeans, self.onInfoCompletedBeans}
		funcs[16] = self.onToastMessage
		funcs[26] = self.onDiploma
		funcs[27] = self.onMatchResult
		local func = funcs[tonumber(data.notify_type)+1]
				
		if not func then return end
		func(self,data)
	end
	
	function theClass:onToastMessage(data)
		dump(data, 'onToastMessage')
		ToastPlugin.show_server_notify(data.content)
	end
	
	--奖状
	function theClass:onDiploma(data)
		dump(data, 'diploma')
		set_user_balance(data.balance)
		local diploma = createDiploma()
		diploma:init(data)
		local scene = runningscene()
		diploma:attach_to(scene.rootNode)
		diploma:show()
	end
	
	--比赛结果
	function theClass:onMatchResult(data)
		dump(data, 'match result is')
		table.sort(data.match_rank, function(a,b)
			return tonumber(a.rank) > tonumber(b.rank)
		end
		)
		dump(data, 'sorted match result is')
		local result = createMatchResult()
		result:set_result(data)
		local scene = runningscene()
		scene.rootNode:addChild(result)
		result:show()
	end
	
	--用户当天游戏达到一定次数送豆子
	function theClass:onGamesBeans(data)
		self:onBeans(data)
	end
	
	--用户当天游戏赢够一定次数送豆子
	function theClass:onWinsBeans(data)
		self:onBeans(data)
	end
	
	--用户连续赢送豆子
	function theClass:onContinueWinsBeans(data)
		self:onBeans(data)
	end
	
	--完善资料送豆子
	function theClass:onInfoCompletedBeans(data)
		self:onBeans(data)
	end
	
	--连续登录送豆子
	function theClass:onContinueLoginsBeans(data)
		self:onBeans(data)
	end
	
	--推荐用户购买道具
	function theClass:onPropPrompt(data)
		--data.must_show = true代表这个道具推送不加入弹窗限制
		PromptPlugin.showPrompt(data)
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
			scene:show_server_notify(message)
			PurchasePlugin.suggest_buy('douzi')
		end
		if scene.scene_on_bankrupt then
			scene:scene_on_bankrupt(data)
		end
	end
	
	--等级升级
	function theClass:onLevel(data)
		--local level = data.level
		dump(data, "on level up=>")
		GlobalSetting.current_user.game_level = data.level
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
	--[[
		cclog("onTimeBeans")
		local scene = CCDirector:sharedDirector():getRunningScene()
		dump(scene, 'running scene')
		if scene.rootNode and scene.show_server_notify and data.user_id then
			cclog('the running scene has root node')
			local msg = string.gsub(strings.snp_zaixianyouli, "minutes", tostring(data.online_time))
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
	]]
		self:onBeans(data)
	end
	
	function theClass:onBeans(data)
		dump(data, 'on beans')
		local msg = self:getOnBeansNotifyMsg(data)
		print('on beans msg:', msg)
		ToastPlugin.show_server_notify(msg)
		
		local c_user = GlobalSetting.current_user
		if data.score then c_user.score = data.score end
		if data.game_level then c_user.game_level = data.game_level end
		
		local scene = runningscene()
		
		--for situation in playing card
		local s_users = scene.users
		if s_users and data.user_id then
			local usr_info = s_users[data.user_id]
			if usr_info then
				usr_info.score = c_user.score
				usr_info.game_level = c_user.game_level
			end
		end
		
		--for situation in hall
		if scene.online_time_beans_update then
			scene:online_time_beans_update()
		end
	end
	
	function theClass:getOnBeansNotifyMsg(data)
		local msg = ""
		--4.在线时长送豆子，8.游戏次数送豆子，9.赢次数送豆子，10.连续赢送豆子， 12.连续登录送豆子， 13.完善资料送豆子
		local strs = {a4=strings.snp_zaixianyouli, a8=strings.snp_plays, a9=strings.snp_wins, 
					  a10=strings.snp_continue_wins, a12=strings.snp_logins, a13=strings.snp_info_complete}
		local data_keys = {a4="online_time", a8="game_count", a9="win_count", a10="continue_win", a12="continue_login"}
		local str_keys = {a4 = "minutes"}
		local key = "a" .. tostring(data.notify_type)
		msg = strs[key]
		if data_keys[key] then
			local count = tostring(data[data_keys[key]])
			print("count is", count)
			msg = string.gsub(msg, (str_keys[key] or "count"), count)
		end
		msg = string.gsub(msg, "beans", tostring(data.beans))
		return msg
	end
end