require "FullMubanStyleLayer"
require "src.UIControllerPlugin"
require "src.DialogInterface"

GamingOption = class("GamingOption", function()
	print("new Gaming Option")
	return display.newLayer("GamingOption")	
end
)
local fns = {}
function createGamingOption(fn1,fn2,fn3)
	print("create Gaming Option")
	fns.on_option_exit = fn1
	fns.on_option_jipaiqi = fn2
	fns.on_option_rank = fn3
	local option = GamingOption.new()
	return option
end

function GamingOption:ctor()
	ccb.GamingOption = self
	self:init_funcs(fns.on_option_exit, fns.on_option_jipaiqi, fns.on_option_rank)
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("GamingOption.ccbi", ccbproxy, false, "")
	self.rootNode = node
	self:addChild(node)
	self:init()

	--gaming scene
	local scene = CCDirector:sharedDirector():getRunningScene()
	print("set option jipaiqi enabled=> ", scene:is_jipaiqi_enable())
	--self.option_jipaiqi:setEnabled(scene:is_jipaiqi_enable())
	scaleNode(node, GlobalSetting.content_scale_factor)
	
	AppStats.event(UM_TOOLS_SHOW)
end

function GamingOption:init()
	local menus = CCArray:create()
	menus:addObject(self.option_exit)
	menus:addObject(self.option_jipaiqi)
	menus:addObject(self.option_rank)
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	self:swallowOnKeypad()
end

function GamingOption:init_funcs(fn1, fn2, fn3) 
	self.on_option_exit = function() 
		fn1() 
		AppStats.event(UM_TOOLS_EXIT) 
	end
	self.on_option_jipaiqi = function() 
		fn2() 
		AppStats.event(UM_TOOLS_JIPAIQI) 
	end
	self.on_option_rank = function() 
		fn3() 
		AppStats.event(UM_TOOLS_RANK) 
	end
end

UIControllerPlugin.bind(GamingOption)
DialogInterface.bind(GamingOption)