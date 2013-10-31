YesNoDialogUPlugin = {}

function YesNoDialogUPlugin.bind(theClass)
	function theClass:setTitle(title)
		self.title:setString(title)
	end
	
	function theClass:setMessage(message)
		self.msg:setString(message)
	end
	
	function theClass:setMessageSize(size)
		self.msg:setFontSize(size)
	end
	
	function theClass:setYesButton(fn)
		self.confirm:registerScriptTapHandler(fn)
	end
	
	function theClass:setNoButton(fn)
		self.reject:registerScriptTapHandler(fn)
	end
	
	function theClass:setYesButtonFrameNormal(frame)
		self.confirm:setNormalSpriteFrame(frame)
	end
	
	function theClass:setNoButtonFrameNormal(frame)
		self.reject:setNormalSpriteFrame(frame)
	end
	
	function theClass:setYesButtonFrameSelected(frame)
		self.confirm:setSelectedSpriteFrame(frame)
	end
	
	function theClass:setNoButtonFrameSelected(frame)
		self.reject:setSelectedSpriteFrame(frame)
	end
	

end