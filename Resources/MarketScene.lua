require "src.MarketSceneUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "IntroduceDialog"

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
	self.tabs = {}
	self.tabnames_hanzi = {"优  惠", "豆  子", "礼  包", "服  务"}
	self.inactive_market_scene_fn = inactive_market_scene_fn
	self.ccbproxy = CCBProxy:create()
	self.on_close_clicked = __bind(self.on_close_click, self)
	ccb.market_scene = self
	local node = CCBReaderLoad("MarketScene.ccbi", self.ccbproxy, true, "market_scene")
	self:addChild(self.rootNode)
	self:init_tabs()
	Timer.add_timer(0.1, function() 
		self:get_prop_list("0")
	end)
	Timer.add_timer(0.5, function() 
		self:check_tech_msg("shop")
	end)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

MarketSceneUPlugin.bind(MarketScene)
UIControllerPlugin.bind(MarketScene)
HallServerConnectionPlugin.bind(MarketScene)