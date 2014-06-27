
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()



ShouchonglibaoDonghua = class("ShouchonglibaoDonghua", function()
	return display.newSprite()
end)

ShouchonglibaoDonghua.sharedAnimation = function()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile(Res.s_shouchonglibao_plist)
	
	local animFrames = CCArray:create()
	local str = ""
	for index = 20, 80 do
		str = "100" .. index .. ".png"
		local frame = cache:spriteFrameByName(str)
		animFrames:addObject(frame)
	end
	local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.08)
	CCAnimationCache:sharedAnimationCache():addAnimation(animation, "ShouchonglibaoDonghua")
end

function ShouchonglibaoDonghua:ctor()

	local pFrame = cache:spriteFrameByName("10020.png")
	self:setDisplayFrame(pFrame)
	self:setScale(GlobalSetting.content_scale_factor)
	local animation = CCAnimationCache:sharedAnimationCache():animationByName("ShouchonglibaoDonghua")
	local anim = CCAnimate:create(animation)
	self:runAction(CCRepeatForever:create(anim))
end

function ShouchonglibaoDonghua.show(target, pos, z_order)
	print("ShouchonglibaoDonghua.show, pos.x= ", pos.x)
	print("ShouchonglibaoDonghua.show, pos.y= ", pos.y)
	z_order = z_order or 9001
	local donghua = ShouchonglibaoDonghua.new()
	target:addChild(donghua, z_order)
	donghua:setPosition(pos)
end









































