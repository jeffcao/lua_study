require "UserCenterScene"
HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		if key == "menuClicked" then
			if self.pop_menu then
				self.pop_menu:setVisible(not self.pop_menu:isVisible())
			else
				 self.pop_menu = createMenu()
				 self.pop_menu:setVisible(true)
				 self.rootNode:addChild(self.pop_menu)
			end
		elseif key == "backClicked" then
			if self.pop_menu and self.pop_menu:isVisible() then
				self.pop_menu:setVisible(false)
			else
				CCDirector:sharedDirector():endToLua()
			end
		end
	end
	
	function theClass:onMenuClick()
		self:onKeypad("menuClicked")
	end
	
	function theClass:onInfoClick()
		self.doToInfo()
	end
	
	function theClass:onAvatarClick()
		self.doToInfo()
	end
	
	function theClass:doToInfo()
		local scene = createUserCenterScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
end