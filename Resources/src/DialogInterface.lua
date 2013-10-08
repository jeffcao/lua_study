require "src.WebsocketRails.Timer"
DialogInterface = {}

function DialogInterface.bind(theClass)
	function theClass:isShowing()
		return self:isVisible()
	end
	
	function theClass:show()
		if self:isShowing() then
			return
		end
		self.convertor:convert()
		print("set visible after convert")
		self:setVisible(true)
		if self.swallow_keypad then
			self.rootNode:setKeypadEnabled(true)
			self:getParent():setKeypadEnabled(false)
		end
		self:touchOutsideDismiss()
	end
	
	function theClass:dismiss(need_remove_self)
		if not self:isShowing() then
			return
		end
		need_remove_self = need_remove_self or false
		
		
		self.convertor:unconvert()
		self:setVisible(false)
		local parent = self:getParent()
		
		--[[
		print("dismiss before")
		if self.swallow_keypad then
			Timer.add_timer(0.3, function()
			self.rootNode:setKeypadEnabled(false)
			parent:setKeypadEnabled(true)
			print("exceute function")
			end)
			--self.rootNode:setKeypadEnabled(false)
			--self:getParent():setKeypadEnabled(true)
		end
		]]
		
		self.rootNode:setKeypadEnabled(false)
		parent:setKeypadEnabled(true)
		if need_remove_self then
			parent:removeChild(self, true)
		end
		print("dismiss after")
	end
	
	function theClass:swallowOnTouch(menus)
		self.convertor = DialogLayerConvertor:create(menus)
    end
    
    function theClass:swallowOnKeypad()
    	self.swallow_keypad = true
    	self:setOnKeypad(function(key)
			if key == "backClicked" then
				print("dialog on key pad")
				if self:isShowing()  then
					self:dismiss(true)
				end
			end
		end)
    end
    
    function theClass:touchOutsideDismiss()
    	if not self.bg or not self.rootNode then return end
    	local ontouch = function(eventType, x, y)
    		cclog("touch event Share:%s,x:%d,y:%d", eventType, x, y)
			if eventType == "began" then
				do return true end
			elseif eventType == "moved" then
				do return end
			else
				if not self.bg:boundingBox():containsPoint(ccp(x,y)) then
					self:dismiss()
				end
				do return end
			end
    	end
    	self.rootNode:registerScriptTouchHandler(ontouch)
    	self.rootNode:setTouchEnabled(true)
    end
    
    function theClass:setOnKeypad(fn)
		self.rootNode:setKeypadEnabled(true)
		self.rootNode:registerScriptKeypadHandler(fn)
	end
	
	function theClass:isAlive()
		return true
	end
end