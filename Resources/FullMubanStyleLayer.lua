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
		if type(self.inactive_market_scene_fn) == "function" then
			print("[FullMubanStyleLayer] call inactive_market_scene_fn")
			self.inactive_market_scene_fn()
		end 
		CCDirector:sharedDirector():popScene()
	end
	self:setOnClose(to_hall)
	self:setOnBackClicked(to_hall)
	self:repeat_bg()
end

function FullMubanStyleLayer:repeat_bg()
	local rect = CCRectMake(0,0,750,386)
	--local sprite = CCSprite:createWithSpriteFrameName("kuang01_tianchong.png")
	local sprite = CCSprite:create("ccbResources/kuang01_tianchong.png")
	dump(sprite, "repeat bg")
	sprite:setTextureRect(rect)
	local params = ccTexParams:new()
	params.minFilter = GL_LINEAR
	params.magFilter = GL_LINEAR
	params.wrapS = GL_REPEAT
	params.wrapT = GL_REPEAT
	--{GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT}
	sprite:getTexture():setTexParameters(params)
	sprite:setAnchorPoint(ccp(0.5,0.5))
	sprite:setPosition(ccp(402,219))
	sprite:setTag(23)
	self.rootNode:addChild(sprite)
end

FullMubanStyleUPlugin.bind(FullMubanStyleLayer)
