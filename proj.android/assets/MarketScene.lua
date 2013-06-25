require "src.MarketSceneUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

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
	
	local ccbproxy = CCBProxy:create()
	
	local layer = createFullMubanStyleLayer()
	self.rootNode = layer
	self:addChild(layer)
	
	layer:setTitle("biaoti06.png")
	
	self:init_product_list()
	
end

MarketSceneUPlugin.bind(MarketScene)
UIControllerPlugin.bind(MarketScene)
HallServerConnectionPlugin.bind(MarketScene)