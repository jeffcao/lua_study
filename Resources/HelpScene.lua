require "src.HelpSceneUPlugin"
require "src.UIControllerPlugin"
require "src.Stats"
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
	
	layer:setTitle("biaoti05.png")
	
	local scroll_view = self:createScrollView()
	layer:setContent(scroll_view)
end
HelpSceneUPlugin.bind(HelpScene)
UIControllerPlugin.bind(HelpScene)