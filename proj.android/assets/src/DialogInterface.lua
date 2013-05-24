DialogInterface = {}

function DialogInterface.bind(theClass)
	function theClass:isShowing()
		return self:isVisible()
	end
	
	function theClass:show()
		self.convertor:convert()
		self:setVisible(true)
	end
	
	function theClass:dismiss()
		self.convertor:unconvert()
		self:setVisible(false)
	end
	
	function theClass:swallowOnTouch()
		local menus = CCArray:create()
		self.reject_menu = self.ccbproxy:getNodeWithType("reject_menu", "CCMenu")
		self.confirm_menu = self.ccbproxy:getNodeWithType("confirm_menu", "CCMenu")
		menus:addObject(self.reject_menu)
		menus:addObject(self.confirm_menu)
		self.convertor = DialogLayerConvertor:create(menus)
    end
end