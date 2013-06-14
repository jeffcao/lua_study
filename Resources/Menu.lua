require "AboutScene"
require "HelpScene"
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

	ccb.menu_scene = self
	
	local function dismiss()
		if self then
			self:dismiss()
		end
	end
	
	local function about(tag, sender)
		dismiss()
		local scene = createAboutScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	local function help(tag, sender)
		dismiss()
		local scene = createHelpScene()
		CCDirector:sharedDirector():pushScene(scene)
	end
	
	local function switch(tag, sender)
		local scene = createLoginScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	
	local function set(tag, sender)
		if not self.set_dialog then
			self.set_dialog = createSetDialog()
			self.container:addChild(self.set_dialog)
		end
		self.set_dialog:show()
		dismiss()
	end
	
	self.on_help_item_clicked = help
	self.on_about_item_clicked = about
	self.on_switch_item_clicked = switch
	self.on_set_item_clicked = set

	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("Menu.ccbi", ccbproxy, false, "")
	self:addChild(node)
	
	self:setVisible(false)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
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