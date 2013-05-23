require "src.MarketSceneUPlugin"
MarketScene = class("MarketScene", function()
	print("new market scene")
	return display.newScene("MarketScene")	
end
)

function createMarketScene()
	print("create market scene")
	return MarketScene.new()
end

function MarketScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local layer = createFullMubanStyleLayer()
	self.rootNode = layer
	self:addChild(layer)
	
	layer:setTitle("biaoti06.png")
	local list_view = self:createListView()
	layer:setContent(list_view)
end
MarketSceneUPlugin.bind(MarketScene)