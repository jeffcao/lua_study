DialogInterface = {}

function DialogInterface.bind(theClass)
	function theClass:isShowing()
		return self:isVisible()
	end
	
	function theClass:show()
		self.convertor:convert()
		print("set visible after convert")
		self:setVisible(true)
		if self.swallow_keypad then
			self.rootNode:setKeypadEnabled(true)
			self:getParent():setKeypadEnabled(false)
		end
	end
	
	function theClass:dismiss()
		self.convertor:unconvert()
		self:setVisible(false)
		if self.swallow_keypad then
			self.rootNode:setKeypadEnabled(false)
			self:getParent():setKeypadEnabled(true)
		end
	end
	
	function theClass:swallowOnTouch(menus)
		self.convertor = DialogLayerConvertor:create(menus)
    end
    
    function theClass:swallowOnKeypad()
    	self.swallow_keypad = true
    end
end