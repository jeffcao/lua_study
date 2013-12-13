require 'src.PromotionInfoScenePlugin'
require 'AwardRecordItem'

PromotionInfoScene = class("PromotionInfoScene", function()
	print("new promotion info scene")
	return display.newScene("PromotionInfoScene")	
end
)

function createPromotionInfoScene(promotion)
	print("create promotion info scene")
	local scene = PromotionInfoScene.new()
	scene.promotion = promotion
	return scene
end

function PromotionInfoScene:ctor()
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitleLeft()
	self.layer = layer
	self.menu_layer = layer.menu_layer
	self.rootNode = self.layer
	self.record_layers = {}
	self:init_tabs()
	scaleNode(self.layer, GlobalSetting.content_scale_factor)
end

 function PromotionInfoScene:onEnter() 
 	Stats:on_start("promotion_info")
 end
 
 function PromotionInfoScene:onExit()
 	self.record_layers = nil 
 	Stats:on_end("promotion_info")
 end
PromotionInfoScenePlugin.bind(PromotionInfoScene)