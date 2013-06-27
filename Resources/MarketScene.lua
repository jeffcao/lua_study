require "src.MarketSceneUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

MarketScene = class("MarketScene", function()
	print("new market scene")
	return display.newScene("MarketScene")	
end
)

function createMarketScene(inactive_market_scene_fn)
	print("create market scene")
	return MarketScene.new(inactive_market_scene_fn)
end

function MarketScene:ctor(inactive_market_scene_fn)
	
	local ccbproxy = CCBProxy:create()
	
	self.inactive_market_scene_fn = inactive_market_scene_fn
	
	local layer = createFullMubanStyleLayer()
	self.rootNode = layer
	self:addChild(layer)
	layer.inactive_market_scene_fn = inactive_market_scene_fn
	layer:setTitle("biaoti06.png")
	
	self:init_product_list()
	
end

MarketSceneUPlugin.bind(MarketScene)
UIControllerPlugin.bind(MarketScene)
HallServerConnectionPlugin.bind(MarketScene)