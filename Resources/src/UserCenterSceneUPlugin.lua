
UserCenterSceneUPlugin = {}

function UserCenterSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		if key == "backClicked" then
			self:doToHall()
		end
	end
	
	function theClass:doToHall()
		local scene = createHallScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	function theClass:onCloseClick()
		self:doToHall()
	end
end