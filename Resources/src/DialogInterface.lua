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
	end
	
	function theClass:dismiss(need_remove_self)
		if not self:isShowing() then
			return
		end
		need_remove_self = need_remove_self or false
		
		
		self.convertor:unconvert()
		self:setVisible(false)
		local parent = self:getParent()
		
		print("dismiss before")
		if self.swallow_keypad then
			Timer.add_timer(0.7, function()
			self.rootNode:setKeypadEnabled(false)
			parent:setKeypadEnabled(true)
			print("exceute function")
			end)
			--self.rootNode:setKeypadEnabled(false)
			--self:getParent():setKeypadEnabled(true)
		end
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
    end
    
    function theClass:setOnKeypad(fn)
		self.rootNode:setKeypadEnabled(true)
		self.rootNode:registerScriptKeypadHandler(fn)
	end
	
	function theClass:isAlive()
		return true
	end
end