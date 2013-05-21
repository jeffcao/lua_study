require "AboutScene"
require "HelpScene"

Menu = class("Menu", function() 
	print("new menu")
	return display.newLayer("Menu")	
end
)

function createMenu()
	print("create menu")
	return Menu.new()
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
		self.setVisible(false)
	end
	local function about()
		local scene = createAboutScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	local function help()
		local scene = createHelpScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	self.about = self.ccbproxy:getNodeWithType("menu_about_item", "CCMenuItemImage")
	self.about:registerScriptTapHandler(about)
	
	self.help = self.ccbproxy:getNodeWithType("menu_help_item", "CCMenuItemImage")
	self.help:registerScriptTapHandler(help)
	
end