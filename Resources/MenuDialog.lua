require "src.SceneDialog"
MenuDialog = class("MenuDialog", function()
	return display.newScene("MenuDialog")
end)

function createMenuDialog()
	return MenuDialog.new()
end

function MenuDialog:ctor()

	ccb.menu_scene = self

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
	
	self.on_help_item_clicked = help
	self.on_about_item_clicked = about
	self.on_switch_item_clicked = switch
	self.on_set_item_clicked = set
	
	self:create("Menu.ccbi")
	self:setOnKeypad(function() self:dismiss() end)

end

SceneDialog.bind(MenuDialog)
