RankSwitcher = {}

function RankSwitcher.bind(theClass)
	function theClass:switch_to_huafei()
		print("switch_to_huafei start")
		self:reset_touches('huafei')
		self:setHuafeiInfo(true)
		
		self.item_name_lbl1:setPosition(ccp(0,0))
		self.item_name_lbl2:setPosition(ccp(85,0))
		self.item_name_lbl3:setPosition(ccp(200,0))
		self.item_name_lbl4:setPosition(ccp(290,0))
		set_rank_string_with_stroke(self.item_name_lbl1, "名次")
		set_rank_string_with_stroke(self.item_name_lbl2, "名称")
		set_rank_string_with_stroke(self.item_name_lbl3, "话费")
		set_rank_string_with_stroke(self.item_name_lbl4, "已领")
		set_rank_string_with_stroke(self.info_attr_lbl1,"您获得的话费")
		set_rank_string_with_stroke(self.info_attr_lbl2,"您当前的排名")
		set_rank_stroke(self.get_huafei_lbl)
		
		self.item_name_lbl4:setVisible(true)
		self.huafei_layer:setVisible(true)
		
		self.bottom_layer:setVisible(false)
		print("switch_to_huafei end")
	end
	
	function theClass:setHuafeiInfo(man)
		--if GlobalSetting.run_env == 'test' then
		--	self.huafei_rank_data.balance = 20
		--end
		self.huafei_rank_data.balance = GlobalSetting.current_user.balance
		if self:current_tab() == 'huafei' or man then
			set_rank_string_with_stroke(self.player_bean, self.huafei_rank_data.balance)
			set_rank_string_with_stroke(self.player_rank, self.huafei_rank_data.position)
			self.get_huafei_btn:setEnabled(tonumber(self.huafei_rank_data.balance) >= 10)
		end
		if not self.on_set_balance then
			print('register notification observer')
			self.on_set_balance = __bind(self.setHuafeiInfo, self)
			NotificationProxy.registerScriptObserver(self.on_set_balance, "set_user_balance")
		else
			print('do not register notification observer again')
		end
		---if GlobalSetting.run_env == 'test' then
		---	Timer.add_timer(1, function() set_user_balance(1000) end, 'set balance')
		---end
		--self.on_get_charge_suc = function(data)
		--	self.huafei_rank_data.balance = data.left_charge
		--	self:setHuafeiInfo(true)
		--end
	end
	
	function theClass:setDouziInfo(man)
		if self:current_tab() == 'douzi' or man then
			set_rank_string_with_stroke(self.player_bean, GlobalSetting.current_user.score)
			set_rank_string_with_stroke(self.timer_time, self:getDeltaTime())
			set_rank_string_with_stroke(self.player_rank, self.rank_data.position)
		end
	end
	
	function theClass:reset_touches(name)
		local menus = self:get_touch_menus(name)
		self:swallowOnTouch(menus)
		self:reconvert()
	end
	
	function theClass:switch_to_douzi()
		self:reset_touches('douzi')
		self:setDouziInfo(true)
		
		self.item_name_lbl1:setPosition(ccp(16,0))
		self.item_name_lbl2:setPosition(ccp(100,0))
		self.item_name_lbl3:setPosition(ccp(250,0))
		set_rank_string_with_stroke(self.item_name_lbl1, "名次")
		set_rank_string_with_stroke(self.item_name_lbl2, "名称")
		set_rank_string_with_stroke(self.item_name_lbl3, "豆子")
		set_rank_string_with_stroke(self.info_attr_lbl1,"您拥有的豆子")
		set_rank_string_with_stroke(self.info_attr_lbl2,"您当前的排名")
		
		self.bottom_layer:setVisible(true)
		
		hide_label_with_stroke(self.item_name_lbl4)
		self.huafei_layer:setVisible(false)
	end
end