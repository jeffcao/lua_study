require "UserCenterScene"
require "YesNoDialog"
HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		print("hall scene on key pad")
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
				self:doShowExitDialog()
			end
		end
	end
	
	function theClass:doShowExitDialog()
		if not self.exit_dialog then
			self.exit_dialog = createYesNoDialog()
			self.exit_dialog:setYesButton(function()
				CCDirector:sharedDirector():endToLua()
			end)
			self.rootNode:addChild(self.exit_dialog)
		else
			self.exit_dialog:setVisible(not self.exit_dialog:isVisible())
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