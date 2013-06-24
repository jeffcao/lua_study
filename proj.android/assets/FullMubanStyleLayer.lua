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
	ccb.muban_scene = self
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("FullMubanStyleLayer.ccbi", ccbproxy, false, "")
	self:addChild(node)
 	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.title = tolua.cast(self.title_sprite, "CCSprite")
	self.close = tolua.cast(self.close_btn, "CCMenuItemImage")
	local to_hall = function()
		--local scene = createHallScene()
		--CCDirector:sharedDirector():replaceScene(scene)
		CCDirector:sharedDirector():popScene()
	end
	self:setOnClose(to_hall)
	self:setOnBackClicked(to_hall)
end

FullMubanStyleUPlugin.bind(FullMubanStyleLayer)
