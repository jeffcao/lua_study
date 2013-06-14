SceneDialog = {}

function SceneDialog.bind(theClass)
	function theClass:create(ccbi_name)
		
		local ccbproxy = CCBProxy:create()
 		local node = CCBReaderLoad(ccbi_name, ccbproxy, false, "")
		self:addChild(node)
		scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
		
		self.director = CCDirector:sharedDirector()
		return self
	end
	
	function theClass:isShowing()
		local runningScene = self.director:getRunningScene()
		return runningScene == self
	end
	
	function theClass:show()
		if (not self) or self:isShowing() then
			return
		end
		self.director:pushScene(self)
	end
	
	function theClass:dismiss()
		if (not self) or (not self:isShowing()) then
			return
		end
		self.director:popScene()
		self.is_released = true
	end
	
	function theClass:isAlive()
		return not self.is_released
	end
	
	function theClass:setOnKeypad(fn)
		self.rootNode:setKeypadEnabled(true)
		self.rootNode:registerScriptKeypadHandler(fn)
	end
end
