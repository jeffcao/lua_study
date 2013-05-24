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
	
	function theClass:swallowOnTouch(menus)
		self.convertor = DialogLayerConvertor:create(menus)
    end
end