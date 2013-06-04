require "AboutScene"
require "HelpScene"
require "LoginScene"
require "SetDialog"
require "src.DialogInterface"

Menu = class("Menu", function() 
	print("new menu")
	return display.newLayer("Menu")	
end
)

function createMenu(container)
	print("create menu")
	local menu = Menu.new()
	menu.container = container
	menu.container:addChild(menu)
	return menu
end

function Menu:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("Menu.ccbi")
	assert(node, "fail to load menu")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	self:setVisible(false)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local function dismiss()
		if self then
			self:dismiss()
		end
	end
	
	local function about()
		dismiss()
		local scene = createAboutScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	local function help()
		dismiss()
		local scene = createHelpScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	local function switch()
		local scene = createLoginScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	local function set()
		if not self.set_dialog then
			self.set_dialog = createSetDialog()
			self.container:addChild(self.set_dialog)
		end
		self.set_dialog:show()
		dismiss()
	end
	self.about = self.ccbproxy:getNodeWithType("menu_about_item", "CCMenuItemImage")
	self.about:registerScriptTapHandler(about)
	
	self.help = self.ccbproxy:getNodeWithType("menu_help_item", "CCMenuItemImage")
	self.help:registerScriptTapHandler(help)
	
	self.switch = self.ccbproxy:getNodeWithType("menu_switch_item", "CCMenuItemImage")
	self.switch:registerScriptTapHandler(switch)
	
	self.set = self.ccbproxy:getNodeWithType("menu_set_item", "CCMenuItemImage")
	self.set:registerScriptTapHandler(set)

	local menus = CCArray:create()
	menus:addObject(self.set:getParent())
	menus:addObject(self.switch:getParent())
	menus:addObject(self.help:getParent())
	menus:addObject(self.about:getParent())
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()
	self:setOnKeypad(function()
		self:dismiss()
	end)
	
	
end

DialogInterface.bind(Menu)