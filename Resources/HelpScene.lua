require "src.HelpSceneUPlugin"
require "src.UIControllerPlugin"
require "src.Stats"
require "src/WebsocketRails/Timer"
HelpScene = class("HelpScene", function()
	print("new help scene")
	return display.newScene("HelpScene")	
end
)

function createHelpScene()
	print("create help scene")
	return HelpScene.new()
end

function HelpScene:onEnter()
	Stats:on_start("help")
	local fn = function()
		local scroll_view = self:createScrollView()
		self.rootNode:setContent(scroll_view)
	end
	Timer.add_timer(0.1, fn, "help_scene")
end

function HelpScene:onExit()
	Stats:on_end("help")
end

function HelpScene:ctor()
	ccb.about_scene = self
	
	local ccbproxy = CCBProxy:create()
	
	local layer = createFullMubanStyleLayer()
	
	self.rootNode = layer
	
	self:addChild(layer)
	
	layer:setTitle("wenzi_youxijianjie.png")
end
HelpSceneUPlugin.bind(HelpScene)
UIControllerPlugin.bind(HelpScene)
 SceneEventPlugin.bind(HelpScene)