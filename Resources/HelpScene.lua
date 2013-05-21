require "src.HelpSceneUPlugin"
HelpScene = class("HelpScene", function()
	print("new help scene")
	return display.newScene("HelpScene")	
end
)

function createHelpScene()
	print("create help scene")
	return HelpScene.new()
end

function HelpScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local layer = createFullMubanStyleLayer()
	self.rootNode = layer
	self:addChild(layer)
	
	layer:setTitle("biaoti05.png")
	local scroll_view = self:createScrollView()
	layer:setContent(scroll_view)
end
HelpSceneUPlugin.bind(HelpScene)