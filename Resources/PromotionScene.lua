require "src.Stats"
require "FullMubanStyleLayer"
require 'src.PromotionScenePlugin'
require 'PromotionItem'
require 'src.ToastPlugin'

PromotionScene = class("PromotionScene", function()
	print("new promotion scene")
	return display.newScene("PromotionScene")	
end
)

function createPromotionScene()
	print("create promotion scene")
	return PromotionScene.new()
end

function PromotionScene:ctor()

	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle('huobaohuodong.png')
	layer:showTitleBg()
	layer:setDecorationHuawen()
	self.layer = layer
	self.rootNode = self.layer
	scaleNode(self.layer, GlobalSetting.content_scale_factor)
	Timer.add_timer(0.1, function() 
		self:getPromotionList()
	end)
end

 function PromotionScene:onEnter() 
 	self:listen_match_event()
 	Stats:on_start("promotion_center")
 end
 
 function PromotionScene:onExit() 
 	self:unlisten_match_event()
 	self.list_cache = nil
 	Stats:on_end("promotion_center")
 end
PromotionScenePlugin.bind(PromotionScene)
SceneEventPlugin.bind(PromotionScene)