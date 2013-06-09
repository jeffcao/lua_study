require "UserCenterScene"
require "YesNoDialog2"
require "YesNoDialog"
require "MarketScene"
require "MenuDialog"

HallSceneUPlugin = {}

function HallSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		print("hall scene on key pad")
		if key == "menuClicked" then
			if self.pop_menu and self.pop_menu:isAlive() then
				self.pop_menu:show()
			else
				 --self.pop_menu = createMenu(self.rootNode)
				 self.pop_menu = createMenuDialog()
				 self.pop_menu:show()
			end
		elseif key == "backClicked" then
			if self.pop_menu and self.pop_menu:isShowing() then
				self.pop_menu:dismiss()
			else
				self:doShowExitDialog()
			end
		end
	end
	
	function theClass:doShowExitDialog()
		if self.exit_dialog and self.exit_dialog:isAlive() then
			if self.exit_dialog:isShowing() then
				self.exit_dialog:dismiss()
			else
				self.exit_dialog:show()
			end
		else
		--	self.exit_dialog = createYesNoDialog(self.rootNode)
			self.exit_dialog = createYesNoDialog2()
			self.exit_dialog:setTitle("退出")
			self.exit_dialog:setMessage("您是否退出游戏?")
			self.exit_dialog:setYesButton(function()
				CCDirector:sharedDirector():endToLua()
			end)
			self.exit_dialog:show()
		end
	end
	
	function theClass:onMenuClick(tag, sender)
		self:onKeypad("menuClicked")
	end
	
	function theClass:onInfoClick(tag, sender)
		self.doToInfo()
	end
	
	function theClass:onAvatarClick(tag, sender)
		self.doToInfo()
	end
	
	function theClass:onMarketClick(tag, sender)
		self.doToMarket()
	end
	
	function theClass:doToMarket()
		local scene = createMarketScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	function theClass:doToInfo()
		local scene = createUserCenterScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
end