DialogPlugin = {}
require "src.Scale9Funcs"
function DialogPlugin.bind(theClass)

	function theClass:attach_to_scene(tag)
		self:attach_to(CCDirector:sharedDirector():getRunningScene(),tag)
	end

	function theClass:attach_to(parent, tag)
		tag = tag or -1
		parent:addChild(self, getMaxZOrder(parent) + 1, tag)
	end
	
	function theClass:init_dialog()
		self.dialogplugin_dismiss_cleanup = true
		self.dialogplugin_is_restricted = false
		self.dialogplugin_back_dismiss = true
		self.dialogplugin_auto_dimiss_time = -1
		self.dialogplugin_out_dismiss = true
		self.dialogplugin_sel_childs = getTouchChilds(self)
		
		self:setVisible(false)
		
		self:setTouchEnabled(true)
		self:registerScriptTouchHandler(__bind(self.on_touch, self), false, -200, true)
		
		self:setKeypadEnabled(true)
		self:registerScriptKeypadHandler(__bind(self.on_keypad, self))
		
		check_dialog_scale9_bg(self)
	end
	
	function theClass:recreate_sel_childs()
		self.dialogplugin_sel_childs = getTouchChilds(self)
	end
	
	function theClass:on_touch(e,x,y)
		if self:getZOrder() < getMaxZOrderVisible(self:getParent()) then print("is not touch me") return false end
		if not self:isVisible() then print("self is not visible") return false end
		print('dialog plugin event is', e)
		if self.dialogplugin_sel_childs then
			dump(self.dialogplugin_sel_childs, 'self.dialogplugin_sel_childs')
			for k,v in pairs(self.dialogplugin_sel_childs) do
				if cccn(v,x,y) then 
					local is_btn = v:getTag() == 1011
					if v.on_touch_fn then v.on_touch_fn(e,x,y) end
					return not is_btn
				else
					dumprect(v:boundingBox(), 'dialog plugin not me:x='..x..'y='..y)
				end
			end
		end
--		dump(self.bg, "DialogPlugin.on_touch, self.bg=> ")
--		dump(cccn(self.bg, x,y), "DialogPlugin.on_touch, cccn(self.bg, x,y)=> ")
--		dump(self.dialogplugin_out_dismiss, "DialogPlugin.on_touch, self.dialogplugin_out_dismiss=> ")
		if self.bg and (not cccn(self.bg, x,y)) then
			if self.dialogplugin_on_out_fn then
				self.dialogplugin_on_out_fn()
			elseif self.dialogplugin_out_dismiss then
				self:removeFromParentAndCleanup(true)
			end
		end
		return true 
	end
	
	function theClass:on_keypad(key)
		print("on keypad clicked: ", self:getZOrder(), key)
		if self:getZOrder() < getMaxZOrderVisible(self:getParent()) then print("is not keypad me") return end
		if key == "back" then
			if self.dialogplugin_on_back_fn then 
				self:dialogplugin_on_back_fn()
			elseif self.dialogplugin_back_dismiss then
				Timer.add_timer(0.1, __bind(self.dismiss, self), 'dismiss')
			end
		elseif key == "menu" then
			if self.dialogplugin_on_menu_fn then
				self:dialogplugin_on_menu_fn()
			end
		end 
	end
	
	function theClass:delayShow(time)
		time = time or 0.1
		Timer.add_timer(time, __bind(self.show, self), 'delay_show')
	end
	
	--显示
	function theClass:show()
		if not self:canShow() then print("error, try to show an dialog been destroyed") return end
		if self.dialogplugin_is_restricted then
			local delta = os.time() - (GlobalSetting.last_restricted_show_time or 0)
			if delta < GlobalSetting.restrict_interval then
				print("delta is less than restricted", delta)
				return
			end
		end
		if self:getZOrder() < getMaxZOrder(self:getParent()) then
			self:getParent():reorderChild(self, getMaxZOrder(self:getParent()) + 1)
		end
		self:setVisible(true)
		if self.dialogplugin_is_restricted then GlobalSetting.last_restricted_show_time = os.time() end
	end
	
	--消失
	function theClass:dismiss()
		if not self:canDismiss() then return end
		self:setVisible(false)
		if self.dialogplugin_dismiss_cleanup then 
			self:removeFromParentAndCleanup(true) 
			self.dialogplugin_destoryed = true
		end
	end
	
	function theClass:canShow()
		if self.dialogplugin_destoryed then return false end
		return not self:isVisible()
	end
	
	function theClass:canDismiss()
		if self.dialogplugin_destoryed then return false end
		return self:isVisible()
	end
	
	--是否正在显示
	function theClass:isShowing()
		if self.dialogplugin_destoryed then return false end
		return self:isVisible()
	end
	
	--设置点击对话框之外的响应
	function theClass:setOnOut(fn)
		self.dialogplugin_on_out_fn = fn
	end
	
	--设置点击返回按钮的响应，默认dismiss对话框
	function theClass:setOnBack(fn)
		self.dialogplugin_on_back_fn = fn
	end
	
	--设置点击菜单按钮的响应
	function theClass:setOnMenu(fn)
		self.dialogplugin_on_menu_fn = fn
	end
	
	--设置是否点击对话框外消失，默认开启
	function theClass:setClickOutDismiss(enable)
		self.dialogplugin_out_dismiss = enable
	end
	
	--设置点击返回键时，是否自动dismiss，默认开启
	function theClass:setBackDismiss(enable)
		self.dialogplugin_back_dismiss = enable
	end
	
	--dialog标志，供外界判断该对象是否为对话框
	function theClass:is_dialog()
		return true
	end
	
	--设置消失时，是否销毁对话框,默认销毁
	function theClass:set_dismiss_cleanup(cleanup)
		self.dialogplugin_dismiss_cleanup = cleanup
	end
	
	--设置是否为限制框，默认不是
	function theClass:set_is_restricted(restricted)
		self.dialogplugin_is_restricted = restricted
	end
	
	--设置是否在一定时间之后自动消失，time为消失时间
	function theClass:set_auto_dismiss(time)
		self.dialogplugin_auto_dimiss_time = time
		self.dialogplugin_auto_dismiss_fn = Timer.add_timer(self.dialogplugin_auto_dimiss_time, __bind(self.dismiss, self), 'auto_dismiss')
	end
	
	--重置自动消失
	function theClass:reset_auto_dimiss()
		if not self:is_auto_dismiss() then return end
		if self.dialogplugin_auto_dismiss_fn then Timer.cancel_timer(self.dialogplugin_auto_dismiss_fn) end
		self.dialogplugin_auto_dismiss_fn = Timer.add_timer(self.dialogplugin_auto_dimiss_time, __bind(self.dismiss, self), 'auto_dismiss')
	end
	
	--获取是否为自动消失
	function theClass:is_auto_dismiss()
		return self.dialogplugin_auto_dimiss_time and self.dialogplugin_auto_dimiss_time > 0
	end
	
end