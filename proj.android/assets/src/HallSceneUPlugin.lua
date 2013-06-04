require "UserCenterScene"
require "MenuScene"
require "YesNoDialog"
require "MarketScene"

HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		print("hall scene on key pad")
		if key == "menuClicked" then
			if self.pop_menu then
				self.pop_menu:show()
			else
				 self.pop_menu = createMenu(self.rootNode)
				 self.rootNode:addChild(self.pop_menu)
				 self.pop_menu:show()
			end
			--[[
			local scene = createMenuScene()
			CCDirector:sharedDirector():pushScene(scene)
			]]
		elseif key == "backClicked" then
			if self.pop_menu and self.pop_menu:isShowing() then
				self.pop_menu:dismiss()
			else
				self:doShowExitDialog()
			end
		end
	end
	
	function theClass:doShowExitDialog()
		if not self.exit_dialog then
			self.exit_dialog = createYesNoDialog()
			self.exit_dialog:setTitle("退出")
			self.exit_dialog:setMessage("您是否退出游戏?")
			self.exit_dialog:setYesButton(function()
				CCDirector:sharedDirector():endToLua()
			end)
			self.rootNode:addChild(self.exit_dialog)
			self.exit_dialog:show()
		else
			if self.exit_dialog:isShowing() then
				self.exit_dialog:dismiss()
			else
				self.exit_dialog:show()
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
	
	function theClass:onMarketClick()
		self.doToMarket()
	end
	
	function theClass:doToMarket()
		local scene = createMarketScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	function theClass:doToInfo()
		local scene = createUserCenterScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
end