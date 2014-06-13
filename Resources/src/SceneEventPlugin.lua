require 'src.AppStats'
SceneEventPlugin = {}

function SceneEventPlugin.bind(theClass)
	local oldOnEnter = theClass.onEnter
	local oldonExit = theClass.onExit
	function theClass:onEnter()
		if oldOnEnter then oldOnEnter(self) end
	--	if not self.SceneEventPlugin_onEnter then 
			AppStats.beginScene()
	--		self.SceneEventPlugin_onEnter = true
	--	end
	end
	function theClass:onExit()
		if oldonExit then oldonExit(self) end
		AppStats.endScene()
	end
end