require "src.SceneDialog"
MenuDialog = class("MenuDialog", function()
	return display.newScene("MenuDialog")
end)

function createMenuDialog()
	return MenuDialog.new()
end

function MenuDialog:ctor()
	self:create("Menu.ccbi")
	self:setOnKeypad(function() self:dismiss() end)
	local function about()
		self:dismiss()
		local scene = createAboutScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	local function help()
		self:dismiss()
		local scene = createHelpScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	local function switch()
		local scene = createLoginScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	local function set()
		
	end
	self.about = self.ccbproxy:getNodeWithType("menu_about_item", "CCMenuItemImage")
	self.about:registerScriptTapHandler(about)
	
	self.help = self.ccbproxy:getNodeWithType("menu_help_item", "CCMenuItemImage")
	self.help:registerScriptTapHandler(help)
	
	self.switch = self.ccbproxy:getNodeWithType("menu_switch_item", "CCMenuItemImage")
	self.switch:registerScriptTapHandler(switch)
	
	self.set = self.ccbproxy:getNodeWithType("menu_set_item", "CCMenuItemImage")
	self.set:registerScriptTapHandler(set)
end

SceneDialog.bind(MenuDialog)
