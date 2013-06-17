
Explosion = class("Explosion", function()
	return display.newSprite()
end)

function Explosion:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local pFrame = cache:spriteFrameByName("baoza_0.png")
	self:setDisplayFrame(pFrame)
	self:setScale(GlobalSetting.content_scale_factor)
	local animation = CCAnimationCache:sharedAnimationCache():animationByName("baozha")
	local anim = CCAnimate:create(animation)
	local cb = CCCallFunc:create(function() self:removeFromParentAndCleanup(true) end)
	local seq = CCSequence:createWithTwoActions(anim, cb)
	self:runAction(seq)
end

function Explosion.sharedExplosion()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile(Res.s_anim_plist)
	local animFrames = CCArray:create()
	local str = ""
	for index = 0, 6 do
		str = "baoza_" .. index .. ".png"
		local frame = cache:spriteFrameByName(str)
		animFrames:addObject(frame)
	end
	local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
	CCAnimationCache:sharedAnimationCache():addAnimation(animation, "baozha")
end

function Explosion.explode(target, z_order)
	z_order = z_order or 9001
	local explosion = Explosion.new()
	explosion:setPosition(ccp(400,200))
	target:addChild(explosion, z_order)
end