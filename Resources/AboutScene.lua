require "FullMubanStyleLayer"
AboutScene = class("AboutScene", function()
	print("new about scene")
	return display.newScene("AboutScene")	
end
)

function createAboutScene()
	print("create about scene")
	return AboutScene.new()
end

function AboutScene:ctor()
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	self.rootNode = layer
	layer:setTitle("biaoti07.png")
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("About.ccbi")
	layer:setContent(node)
end

