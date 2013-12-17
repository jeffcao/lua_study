require "RankItem"
require "src.TabPlugin"
require "src.RankSwitcher"
require "src.ListViewPlugin"
RankUPlugin = {}

function RankUPlugin.bind(theClass)
	TabPlugin.bind(theClass)
	RankSwitcher.bind(theClass)
	function theClass:create_rank_list(rank_list)
		local t = ListViewPlugin.create_list_view(rank_list,
		createRankItem, 'init', CCSizeMake(348,30), CCSizeMake(348,180))
		return t
	end
	
	function theClass:create_huafei_rank_list(rank_list)
		local t = ListViewPlugin.create_list_view(rank_list,
		createHuafeiRankItem, 'init', CCSizeMake(348,30), CCSizeMake(348,180))
		return t
	end

	function theClass:rank_with_data(data, on_time_over)
		if self.rank_data then
			for k,_ in pairs(self.rank_data.list) do self.rank_data.list[k] = nil end
			for k,v in pairs(data) do
				if k ~= 'list' then 
					self.rank_data[k] = v 
				else
					for k2,v2 in pairs(data.list) do
						self.rank_data.list[k2] = v2
					end
				end
			end
		else
			self.rank_data = data
			self.rank_data.on_time_over = on_time_over
		end
		local view = self:rank()
		set_rank_string_with_stroke(self.player_rank,data.position)
		return view
	end

	function theClass:getDeltaTime()
		local data = self.rank_data
		cclog("os time " .. os.time())
		local delta = data.expire_time - os.time()
		local minutes = math.floor(delta / 60)
		local seconds = delta - minutes*60
		if minutes < 0 then
			return "00:00"
		end
		if minutes < 10 then
			minutes = "0" .. tostring(minutes)
		end
		if seconds < 10 then
			seconds = "0" .. tostring(seconds)
		end
		delta = minutes..":"..seconds
		return delta
	end

	function theClass:setDeltaTime()
		if self.set_rank_time_hdlr then Timer.cancel_timer(self.set_rank_time_hdlr) end
		set_rank_string_with_stroke(self.timer_time,self:getDeltaTime())
		local fn = function()
			if self and self:isShowing() and self.timer_time:isVisible() then
				print('set time')
				local d = self:getDeltaTime()
				set_rank_string_with_stroke(self.timer_time,self:getDeltaTime())
				if d == "00:00" then
					--更新排行榜
					self.rank_data.on_time_over()
				end
			end
			return true
		end
		print("add set rank time")
		self.set_rank_time_hdlr = Timer.add_repeat_timer(1, __bind(fn,self), "set_rank_time")
	end

	function theClass:rank()
		table.sort(self.rank_data.list, function(a, b) return tonumber(a.id) > tonumber(b.id) end)

		local avatar_png = self:get_player_avatar_png_name()

		print("[RankUPlugin:rank] avatar_png: "..avatar_png)
		self.rank_avatar:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
		set_rank_string_with_stroke(self.player_bean, GlobalSetting.current_user.score)
		--self.player_bean:setString(GlobalSetting.current_user.score)

		self:setDeltaTime()

		if not self.rank_content.rank then
			local ontouch = function(e,x,y)
				if not self:isVisible() then print("self is not visible") return false end
				print('event is', e)
				if not cccn(self.bg, x,y) then
					self:dismiss()
				else
					return false
				end
				return true
			end
			self.bg:registerScriptTouchHandler(ontouch, false, 200, true)
			self.bg:setTouchEnabled(true)

			self.rank_content.rank = self:create_rank_list(self.rank_data.list)
			local menus = self:get_touch_menus('douzi')
			self:swallowOnTouch(menus)
			self.rank_content:addChild(self.rank_content.rank)
		else
			self.rank_content.rank:reloadData()
		end
		return self.rank_content.rank
	end
	
	function theClass:get_touch_menus(name)
		local menus = CCArray:create()
		menus:addObject(self.bg)
		if self.huafei_rank_data and name == 'huafei' then
			menus:addObject(self.huafei_rank_data.rank)
		end
		if self.rank_content.rank and name == 'douzi' then
			menus:addObject(self.rank_content.rank)
		end
		menus:addObject(self.tab_btn_right_menu)
		menus:addObject(self.tab_btn_left_menu)
		menus:addObject(self.get_huafei_menu)
		return menus
	end

---------------------------------for TabPlugin functions start
	function theClass:setNodeCheckStatus(tab_data)
		tab_data.tab_node:getChildByTag(1000):setEnabled(false)
		cclog("set %s checked", tab_data.name)
		if tab_data.name == 'douzi' then
			self:switch_to_douzi()
		else
			self:switch_to_huafei()
		end
	end

	function theClass:setNodeUncheckStatus(tab_data)
		cclog("set %s unchecked", tab_data.name)
		tab_data.tab_node:getChildByTag(1000):setEnabled(true)
	end

	function theClass:getTabNode(name)
		local s = self.tab_btn_right_menu
		if name == 'huafei' then s = self.tab_btn_left_menu end
		s:getChildByTag(1000):registerScriptTapHandler(function() self:playButtonEffect() self:set_tab(name) end)
		return s
	end

	function theClass:getTabView(name, call_back)
		if name == 'huafei' then
			self:getHuafeiTabView(call_back)
		else
			self:getDouziTabView(call_back)
		end
	end
---------------------------------for TabPlugin functions end

	function theClass:getDouziRank(callback)
		local event_data = {user_id = GlobalSetting.current_user.user_id}
		GlobalSetting.g_WebSocket:trigger("g.user_score_list", event_data, function(data)
			print("========g.user_score_list return succss: " , data)
			data.expire_time = os.time() + data.next_time
			local view = self:rank_with_data(data, __bind(self.getDouziRank, self))
			if callback then
				callback(view)
				self:show()
				print('get douzi rank, init and show view')
			else
				print('get douzi rank, reload view')
			--	set_tab_view('douzi',view)
			end
		end, function(data)
			print("----------------g.user_score_list return failure: " , data)
		end)
	end
	
	function theClass:create_huafei_rank_view()
		table.sort(self.huafei_rank_data.list, function(a, b) return tonumber(a.id) > tonumber(b.id) end)

		local avatar_png = self:get_player_avatar_png_name()

		print("[RankUPlugin:rank] avatar_png: "..avatar_png)
		self.rank_avatar:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
		--set_rank_string_with_stroke(self.player_bean, GlobalSetting.current_user.score)
		set_rank_string_with_stroke(self.player_bean, self.huafei_rank_data.balance)
		--self.player_bean:setString(GlobalSetting.current_user.score)

		--self:setDeltaTime()

		if not self.huafei_rank_data.rank then
			--for k,v in pairs(self.huafei_rank_data.list) do
			--	v.score = v.total_balance
			--end
			self.huafei_rank_data.rank = self:create_huafei_rank_list(self.huafei_rank_data.list)
			local menus = self:get_touch_menus('huafei')
			self:swallowOnTouch(menus)
			self:reconvert()
			self.rank_content:addChild(self.huafei_rank_data.rank)
		else
			self.huafei_rank_data.rank:reloadData()
		end
		return self.huafei_rank_data.rank
	end
	
	function theClass:huafei_rank(data)
		if self.huafei_rank_data then
			for k,_ in pairs(self.huafei_rank_data.list) do self.huafei_rank_data.list[k] = nil end
			for k,v in pairs(data) do
				if k ~= 'list' then 
					self.huafei_rank_data[k] = v 
				else
					for k2,v2 in pairs(data.list) do
						self.huafei_rank_data.list[k2] = v2
					end
				end
			end
		else
			self.huafei_rank_data = data
		end
		local view = self:create_huafei_rank_view()
		set_rank_string_with_stroke(self.player_rank,data.position)
		self:setHuafeiTimer()
		return view
	end
	
	function theClass:setHuafeiTimer()
		if self.set_huafei_rank_time_hdlr then Timer.cancel_timer(self.set_huafei_rank_time_hdlr) end
		local fn = function()
			if self and self:isShowing() then
				print('refresh huafei rank')
				self:getHuafeiRank()
			end
			return true
		end
		print("add set rank time")
		self.set_huafei_rank_time_hdlr = Timer.add_timer(10, __bind(fn,self), "set_huafei_rank_time")
	end
	
	--data:list{data:id,nick_name,total_balance,balance},position,balance
	function theClass:getHuafeiRank(callback)
		local event_data = {user_id = GlobalSetting.current_user.user_id}
		GlobalSetting.g_WebSocket:trigger("g.user_score_list", event_data, function(data)
			data = {}
			data.position = math.random(100)
			data.balance = math.random(1000)
			data.list = {}
			for index=1,50 do
				local balance = math.random(1000)
				local waste = math.random(1000)
				local item = {id = index, nick_name = 'user'..tostring(math.random(1000)), total_balance=balance+waste, balance=balance}
				table.insert(data.list, item)
			end
			
			local view = self:huafei_rank(data)
			if callback then
				callback(view)
				self:show()
				print('get huafei rank, init and show view')
			else
				print('get huafei rank, reload view')
			end
		end, function(data)
			print("----------------getHuafeiRank return failure: " , data)
		end)
	end

	function theClass:getHuafeiTabView(callback)
		print('theClass:getHuafeiTabView(callback)')
		--local view = CCLayer:create()
		--callback(view)
		self:getHuafeiRank(callback)
	end

	function theClass:getDouziTabView(callback)
		self:getDouziRank(callback)
	end

end