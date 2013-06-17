GAnimationPlugin = {}
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()

function GAnimationPlugin.sharedAnimation()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile(Res.s_anim_plist)
	Explosion.sharedExplosion()
	ButterFly.sharedButterFly()
end

Explosion = class("Explosion", function()
	return display.newSprite()
end)

function Explosion:ctor()
	
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

ButterFly = class("ButterFly", function()
	return display.newSprite()
end)

function createButterFly()
	return ButterFly.new()
end

function ButterFly:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local pFrame = cache:spriteFrameByName("hu die 001.png")
	self:setDisplayFrame(pFrame)
	self:setScale(GlobalSetting.content_scale_factor)
	
	self.action_tag = 3000
	self.back_action_tag = 4000
	self.BACK_TIME = 15
	
	local contentSize = self:getContentSize() 
	self.half_w = (contentSize.width / 2) * GlobalSetting.content_scale_factor
	self.half_h = (contentSize.height / 2) * GlobalSetting.content_scale_factor
	
	self:setPosition(ccp(800 + self.half_w, 295))
	local flyAnimation = CCAnimationCache:sharedAnimationCache():animationByName("fly")
	local flyAnimate = CCAnimate:create(flyAnimation)
	local fly = CCRepeatForever:create(flyAnimate)
	self:runAction(fly)
	self:setPosition(self:randomPosition())
	self:scheduleUpdateWithPriorityLua(__bind(self.fly, self), 1)
end

function ButterFly:fly()
	local x = self:getPositionX()
	local y = self:getPositionY()
	
	local actions = self:numberOfRunningActions()
	if (x < 0 - self.half_w or x > 800 + self.half_w or y <= 0 - self.half_h or y > 480 + self.half_h) then
		self:stopActionByTag(self.action_tag)
		actions = self:numberOfRunningActions()
		if (actions == 1) then
			local b_x = math.random(800)
			local delay = CCDelayTime:create(self.BACK_TIME)
			local b_action = CCSequence:createWithTwoActions(delay, CCCallFunc:create(
					function() 
						self:setPosition(ccp(b_x, 2 - self.half_h))
					end))
			cclog("执行飞回动作，时间:" .. self.BACK_TIME .. "x,y:(" .. b_x .. ",0)")
			b_action:setTag(self.back_action_tag)
			self:runAction(b_action)
		end
	else
		if (actions == 1) then
			local x = math.random(200)
			local y = math.random(100)
			local xdirection = -1
			if math.random(10) > 5 then xdirection = 1 end
			local action = CCMoveBy:create(5, ccp(x * xdirection, y))
			action:setTag(self.action_tag)
			self:runAction(action)
		end
	end
end

function ButterFly:randomPosition()
	return ccp(math.random(800), math.random(480))
end

function ButterFly.sharedButterFly()
	ButterFly.share({"hu die 001.png", "hu die 002.png"},"fly")
end

function ButterFly.share(frames, name)
	local animFrames = CCArray:create()
	for _, _v in pairs(frames) do
		local frame = cache:spriteFrameByName(_v)
		animFrames:addObject(frame)
	end
	local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.5)
	CCAnimationCache:sharedAnimationCache():addAnimation(animation, name)
end












































