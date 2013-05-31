require "AboutScene"
require "HelpScene"
require "LoginScene"
require "SetDialog"

Menu = class("Menu", function() 
	print("new menu")
	return display.newLayer("Menu")	
end
)

function createMenu(container)
	print("create menu")
	local menu = Menu.new()
	menu.container = container
	return menu
end

function Menu:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("Menu.ccbi")
	assert(node, "fail to load menu")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local function dismiss()
		self:setVisible(false)
	end
	
	local function about()
		dismiss()
		local scene = createAboutScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	local function help()
		dismiss()
		local scene = createHelpScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	local function switch()
		dismiss()
		local scene = createLoginScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	local function set()
		if not self.set_dialog then
			self.set_dialog = createSetDialog()
			--self.rootNode:addChild(self.set_dialog)
			self.container:addChild(self.set_dialog)
		end
		if not self.set_dialog:isShowing() then
			self.set_dialog:show()
		end
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
end