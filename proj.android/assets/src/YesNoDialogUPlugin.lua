YesNoDialogUPlugin = {}

function YesNoDialogUPlugin.bind(theClass)
	function theClass:setTitle(title)
		self.title:setString(title)
	end
	
	function theClass:setMessage(message)
		self.msg:setString(message)
	end
	
	function theClass:setYesButton(fn)
		self.confirm:registerScriptTapHandler(fn)
	end
	
	function theClass:setNoButton(fn)
		self.reject:registerScriptTapHandler(fn)
	end
	
	function theClass:setOnKeypad(fn)
		self.rootNode:setKeypadEnabled(true)
		self.rootNode:registerScriptKeypadHandler(fn)
	end

end