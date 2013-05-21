require "src.FullMubanStyleUPlugin"
FullMubanStyleLayer = class("FullMubanStyleLayer", function() 
	print("new full muban style layer")
	return display.newLayer("FullMubanStyleLayer")
	end
)

function createFullMubanStyleLayer()
	print("create full muban style layer")
	return FullMubanStyleLayer.new()
end

function FullMubanStyleLayer:ctor()
	self.ccbproxy = CCBProxy:create()
 	self.ccbproxy:retain()
 	
 	local node = self.ccbproxy:readCCBFromFile("FullMubanStyleLayer.ccbi")
	assert(node, "failed to load full muban style layer")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.title = self.ccbproxy:getNodeWithType("title", "CCSprite")
	self.close = self.ccbproxy:getNodeWithType("close_menu_item", "CCMenuItemImage")
	local to_hall = function()
		local scene = createHallScene()
		CCDirector:sharedDirector():replaceScene(scene)
	end
	self:setOnClose(to_hall)
	self:setOnBackClicked(to_hall)
end

FullMubanStyleUPlugin.bind(FullMubanStyleLayer)
