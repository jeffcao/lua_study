require "AboutScene"
require "HelpScene"
require "SetDialog"
require "src.DialogInterface"
require "src.HallServerConnectionPlugin"

Menu = class("Menu", function() 
	print("new menu")
	return display.newLayer("Menu")	
end
)

function createMenu(menu_dismiss_callback, show_set_fn)
	print("create menu")
	local menu = Menu.new(menu_dismiss_callback, show_set_fn)
	return menu
end

function Menu:ctor(menu_dismiss_callback, show_set_fn)

	ccb.menu_scene = self
	
	local function dismiss()
		if self:isShowing() then
			self:dismiss()
			self.menu_dismiss_callback()
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
		dismiss()
		local scene = createLoginScene()
		CCDirector:sharedDirector():replaceScene(scene)
		self:close_hall_websocket()
		if GlobalSetting.online_time_get_beans_handle then
			cclog('cancel previous online_time_get_beans while switch')
			Timer.cancel_timer(GlobalSetting.online_time_get_beans_handle)
			GlobalSetting.online_time_get_beans_handle = nil
		end
	end
	
	local function set(tag, sender)
		dismiss()
		self.show_set_fn()
	end
	
	local function game_center()
		dismiss()
		local jni = DDZJniHelper:create()
		--jni:messageJava("on_open_url_intent_g.10086.cn")
		jni:messageJava("do_cmcc_more_game")
	end
	
	self.show_set_fn = show_set_fn
	self.menu_dismiss_callback = menu_dismiss_callback
	self.on_help_item_clicked = help
	self.on_about_item_clicked = about
	self.on_switch_item_clicked = switch
	self.on_set_item_clicked = set
	self.on_more_item_clicked = game_center

	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("Menu.ccbi", ccbproxy, false, "")
	self:addChild(node)
	
	self:setVisible(false)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local menus = CCArray:create()
	menus:addObject(tolua.cast(self.set, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.switch, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.help, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.about, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.more, "CCLayerRGBA"))
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()
	self:setOnKeypad(function()
		self:dismiss()
	end)
	
	
end

DialogInterface.bind(Menu)
HallServerConnectionPlugin.bind(Menu)