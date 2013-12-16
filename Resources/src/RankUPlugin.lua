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
	
	function theClass:rank_with_data(data, on_time_over)
		self.rank_data = data
		self.rank_data.on_time_over = on_time_over
		local view = self:rank()
		--self.player_rank:setString(data.position)
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
		set_rank_string_with_stroke(self.timer_time,self:getDeltaTime())
		--self.timer_time:set_rank_string_with_stroke(self:getDeltaTime())
		local fn = function() 
			if self and self:isShowing() then
				print('set time')
				local d = self:getDeltaTime()
			--	self.timer_time:setString(self:getDeltaTime())
			--  TODO 只在rank展示的时候才重新设置stroke
				set_rank_string_with_stroke(self.timer_time,self:getDeltaTime())
				if d == "00:00" then
					--更新排行榜
					--local fn = self.on_time_over
					--fn()
					self.rank_data.on_time_over()
				end
				return true
			else 
				print("cancel set rank time")
				return false
			end
		end
		print("add set rank time")
		Timer.add_repeat_timer(1, __bind(fn,self), "set_rank_time")
	end
	
	function theClass:rank()
		table.sort(self.rank_data.list, function(a, b) return tonumber(a.id) > tonumber(b.id) end)
		
		local avatar_png = self:get_player_avatar_png_name()

		print("[RankUPlugin:rank] avatar_png: "..avatar_png)
		self.rank_avatar:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
		set_rank_string_with_stroke(self.player_bean, GlobalSetting.current_user.score)
		--self.player_bean:setString(GlobalSetting.current_user.score)
		
		--self:setDeltaTime()
		
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
    	
			local rank = self:create_rank_list(self.rank_data.list)
			local menus = CCArray:create()
			menus:addObject(self.bg)
			menus:addObject(rank)
			menus:addObject(self.tab_btn_right_menu)
			menus:addObject(self.tab_btn_left_menu)
			menus:addObject(self.get_huafei_menu)
			self:swallowOnTouch(menus)
			self.rank_content:addChild(rank)
			self.rank_content.rank = rank
		else
			self.rank_content.rank:reloadData()
		end
		return self.rank_content.rank
	end
	
	function theClass:setNodeCheckStatus(tab_data)
		tab_data.tab_node:getChildByTag(1000):setEnabled(false)
		cclog("set %s checked", tab_data.name)
		if tab_data.name == 'douzi' then
		--	self:switch_to_douzi()
		else
		--	self:switch_to_huafei()
		end
	end
	
	function theClass:setNodeUncheckStatus(tab_data)
		cclog("set %s unchecked", tab_data.name)
		tab_data.tab_node:getChildByTag(1000):setEnabled(true)
	end
	
	function theClass:getTabNode(name)
		local s = self.tab_btn_right_menu
		if name == 'huafei' then s = self.tab_btn_left_menu end
		s:getChildByTag(1000):registerScriptTapHandler(function() self:set_tab(name) end)
		return s
	end
	
	function theClass:getTabView(name, call_back)
		if name == 'huafei' then
			self:getHuafeiTabView(call_back)
		else
			self:getDouziTabView(call_back)
		end
	end
	
	function theClass:regetDouziRank()
		
	end
	
	function theClass:getHuafeiTabView(callback)
		print('theClass:getHuafeiTabView(callback)')
		local view = CCLayer:create()
		callback(view)
	end
	
	function theClass:getDouziTabView(callback)
		local event_data = {user_id = GlobalSetting.current_user.user_id}
			GlobalSetting.g_WebSocket:trigger("g.user_score_list", event_data, function(data) 
				print("========g.user_score_list return succss: " , data)
				data.expire_time = os.time() + data.next_time
				local view = self:rank_with_data(data, function() end)
				callback(view)
				self:show()
			end, function(data) 
				print("----------------g.user_score_list return failure: " , data)
			end)
	end

end