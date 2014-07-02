require 'src.PromotionInfoScenePlugin'
require 'AwardRecordItem'

PromotionInfoScene = class("PromotionInfoScene", function()
	print("new promotion info scene")
	return display.newScene("PromotionInfoScene")	
end
)

function createPromotionInfoScene(promotion)
	print("create promotion info scene")
	local scene = PromotionInfoScene.new(promotion)
	return scene
end

function PromotionInfoScene:ctor(promotion)
	self.promotion = promotion
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
--	layer:setTitleLeft()
	layer:setContentBbSize(800, 380)
	layer:setMenuDown()
	layer:setTitle('wenzi_huodongxiangqing.png')
	self.layer = layer
	self.menu_layer = layer.menu_layer
	self.menu_layer:setPositionX(self.menu_layer:getPositionX() - 15)
	self.rootNode = self.layer
	self.record_layers = {}
	self:init_tabs()
	scaleNode(self.layer, GlobalSetting.content_scale_factor)
end

 function PromotionInfoScene:onEnter() 
 	Stats:on_start("promotion_info")
 end
 
 function PromotionInfoScene:onExit()
 	self.list_cache = nil
 	Stats:on_end("promotion_info")
 end
PromotionInfoScenePlugin.bind(PromotionInfoScene)
SceneEventPlugin.bind(PromotionInfoScene)