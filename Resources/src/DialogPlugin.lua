DialogPlugin = {}

function DialogPlugin.bind(theClass)

	function theClass:attach_to(parent, tag)
		tag = tag or -1
		parent:addChild(self, getMaxZOrder(parent) + 1, tag)
	end
		
	function theClass:init_dialog()
		self.back_dismiss = true
		self.dismiss_cleanup = true
		self.is_restricted = false
		self.sel_childs = getTouchChilds(self)
		
		self:setVisible(false)
		
		self:setTouchEnabled(true)
		self:registerScriptTouchHandler(__bind(self.on_touch, self), false, -200, true)
		
		self:setKeypadEnabled(true)
		self:registerScriptKeypadHandler(__bind(self.on_keypad, self))
	end
	
	function theClass:on_touch(e,x,y)
		if self:getZOrder() < getMaxZOrder(self:getParent()) then print("is not touch me") return false end
		if self.sel_childs then
			for k,v in pairs(self.sel_childs) do
				if cccn(v,x,y) then return false end
			end
		end
		if self.bg and (not cccn(self.bg, x,y)) and self.out_dismiss then
			self:removeFromParentAndCleanup(true)
		end
		return true 
	end
	
	function theClass:on_keypad(key)
		print("on keypad clicked: ", self:getZOrder())
		if self:getZOrder() < getMaxZOrder(self:getParent()) then print("is not keypad me") return end
		if key == "backClicked" then
			if self.on_back_fn then 
				self:on_back_fn()
			elseif self.back_dismiss then
				Timer.add_timer(0.1, __bind(self.dismiss, self), 'dismiss')
			end
		elseif key == "menuClicked" then
			if self.on_menu_fn then
				self:on_menu_fn()
			end
		end 
	end
	
	--显示
	function theClass:show()
		if self:isVisible() then return end
		if self.is_restricted then
			local delta = os.time - (GlobalSetting.last_restricted_show_time or 0)
			if delta < GlobalSetting.restrict_interval then
				print("delta is less than restricted", delta)
				return
			end
		end
		if self:getZOrder() < getMaxZOrder(self:getParent()) then
			self:getParent():reorderChild(self, getMaxZOrder(self:getParent()) + 1)
		end
		self:setVisible(true)
	end
	
	--消失
	function theClass:dismiss()
		self:setVisible(false)
		if self.dismiss_cleanup then self:removeFromParentAndCleanup(true) end
		if self.is_restricted then GlobalSetting.last_restricted_show_time = os.time() end
	end
	
	--设置点击返回按钮的响应，默认dismiss对话框
	function theClass:setOnBack(fn)
		self.on_back_fn = fn
	end
	
	--设置点击菜单按钮的响应
	function theClass:setOnMenu(fn)
		self.on_menu_fn = fn
	end
	
	--设置是否点击对话框外消失，默认开启
	function theClass:setClickOutDismiss(enable)
		self.out_dismiss = enable
	end
	
	--设置点击返回键时，是否自动dismiss，默认开启
	function theClass:setBackDismiss(enable)
		self.back_dismiss = enable
	end
	
	--dialog标志，供外界判断该对象是否为对话框
	function theClass:is_dialog()
		return true
	end
	
	--设置消失时，是否销毁对话框,默认销毁
	function theClass:set_dismiss_cleanup(cleanup)
		self.dismiss_cleanup = cleanup
	end
	
	--设置是否为限制框，默认不是
	function theClass:set_is_restricted(restricted)
		self.is_restricted = restricted
	end
	
end