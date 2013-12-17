RankSwitcher = {}

function RankSwitcher.bind(theClass)
	function theClass:switch_to_huafei()
		print("switch_to_huafei start")
		self:reset_touches('huafei')
		self.item_name_lbl1:setPosition(ccp(0,0))
		self.item_name_lbl2:setPosition(ccp(100,0))
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
		
		set_rank_string_with_stroke(self.player_bean, GlobalSetting.current_user.score)
		set_rank_string_with_stroke(self.player_rank, self.rank_data.position)
		print("switch_to_huafei end")
	--	self.rank_content.rank:setScale(0.01)
	end
	
	function theClass:reset_touches(name)
		local menus = self:get_touch_menus(name)
		self:swallowOnTouch(menus)
		self:reconvert()
	end
	
	function theClass:switch_to_douzi()
		self:reset_touches('douzi')
			
		--if self.huafei_rank_data then
		--	menus:addObject(self.huafei_rank_data.rank)
		--end
		
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
		
		set_rank_string_with_stroke(self.timer_time, self:getDeltaTime())
		set_rank_string_with_stroke(self.player_bean, GlobalSetting.current_user.score)
		set_rank_string_with_stroke(self.player_rank, self.rank_data.position)
	end
end