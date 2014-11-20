GAnimationPlugin = {}
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()

function GAnimationPlugin.sharedAnimation()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile(Res.s_anim_plist)
	Explosion.sharedExplosion()

end

function GAnimationPlugin.share(frames, name)
	local animFrames = CCArray:create()
	for _, _v in pairs(frames) do
		local frame = cache:spriteFrameByName(_v)
		animFrames:addObject(frame)
	end
	local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.5)
	CCAnimationCache:sharedAnimationCache():addAnimation(animation, name)
end

function GAnimationPlugin.getAnimate(name)
	local animation = CCAnimationCache:sharedAnimationCache():animationByName(name)
	return CCAnimate:create(animation)
end

function GAnimationPlugin.tabletoarray(table)
	local array = CCArray:create()
	if not table then return array end
	for _, _v in pairs(table) do
		array:addObject(_v)
	end
	return array
end

Explosion = class("Explosion", function()
	return display.newSprite()
end)

function Explosion:ctor()

	local pFrame = cache:spriteFrameByName("baoza_1.png")
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
	for index = 1, 7 do
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
	explosion:setPosition(ccp(400,240))
	target:addChild(explosion, z_order)
end



DDZPlane = class("DDZPlane", function()
	return display.newSprite()
end)

function createDDZPlane()
	return DDZPlane.new()
end

function DDZPlane:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local psys = CCParticleSystemQuad:create(Res.s_ddz_plane_plist)
	
	local feiji_img = cache:spriteFrameByName("feiji.png")
	local feiji_spt = CCSprite:create()
	
	feiji_spt:setDisplayFrame(feiji_img)
	self:addChild(feiji_spt)
	feiji_spt:setPosition(ccp(30,220))
	self:addChild(psys)
	self:setVisible(false)
end

function DDZPlane.fly(target, z_order)
	z_order = z_order or 9001
	if not target.ddz_plane then
		local ddz_plane = DDZPlane.new()
		target:addChild(ddz_plane, z_order)
		target.ddz_plane = ddz_plane
	end

	target.ddz_plane:setPosition(ccp(490,40))
	target.ddz_plane:setVisible(true)
	local move_a = CCMoveTo:create(1, ccp(-90, 40))
	function destory_me()
		cclog("DDZPlane.destory_me")
		target.ddz_plane:setVisible(false)
--		target:removeChild(ddz_rocket)
	end
	target.ddz_plane:runAction(CCSequence:createWithTwoActions(move_a, CCCallFuncN:create(destory_me)))
		
end

DDZRocket = class("DDZRocket", function()
	return display.newSprite()
end)

function createDDZRocket()
	return DDZRocket.new()
end

function DDZRocket:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local psys = CCParticleSystemQuad:create(Res.s_ddz_rocket_plist)
	
	local feiji_img = cache:spriteFrameByName("huojian.png")
	local feiji_spt = CCSprite:create()
	
	feiji_spt:setDisplayFrame(feiji_img)
	self:addChild(feiji_spt)
	feiji_spt:setPosition(ccp(150,320))
	self:addChild(psys)
	self:setVisible(false)
end

function DDZRocket.fly(target, z_order)
	z_order = z_order or 9001
	if not target.ddz_rocket then
		local ddz_rocket = DDZRocket.new()
		target:addChild(ddz_rocket, z_order)
		target.ddz_rocket = ddz_rocket
	end

	target.ddz_rocket:setPosition(ccp(240,-90))
	target.ddz_rocket:setVisible(true)
	local move_a = CCMoveTo:create(1, ccp(240, 490))
	function destory_me()
		cclog("DDZRocket.destory_me")
		target.ddz_rocket:setVisible(false)
--		target:removeChild(ddz_rocket)
	end
	target.ddz_rocket:runAction(CCSequence:createWithTwoActions(move_a, CCCallFuncN:create(destory_me)))
	
end

DDZSpring = class("DDZSpring", function()
	return display.newSprite()
end)

function createDDZSpring()
	return DDZSpring.new()
end

function DDZSpring:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	
	local s_char = cache:spriteFrameByName("spring_char.png")
	local s_char_spt = CCSprite:create()
	s_char_spt:setDisplayFrame(s_char)
	
	local s_f_1 = cache:spriteFrameByName("spring_fire_1.png")
	local s_f_1_spt = CCSprite:create()
	s_f_1_spt:setDisplayFrame(s_f_1)
	
	local s_f_2 = cache:spriteFrameByName("spring_fire_2.png")
	local s_f_2_spt = CCSprite:create()
	s_f_2_spt:setDisplayFrame(s_f_2)
	
	
	self:addChild(s_char_spt, 999)
	s_char_spt:setPosition(ccp(150,320))
	self.char_obj = s_char_spt
	
	self:addChild(s_f_1_spt)
	s_f_1_spt:setPosition(ccp(80,330))
	self.f_obj_a = s_f_1_spt
	
	self:addChild(s_f_2_spt)
	s_f_2_spt:setPosition(ccp(220,310))
	self.f_obj_b = s_f_2_spt

	self:setVisible(false)
end

function DDZSpring.open(target, z_order)
	cclog("DDZSpring.open")
	z_order = z_order or 9001
	if not target.ddz_spring then
		local ddz_spring = DDZSpring.new()
		target:addChild(ddz_spring, z_order)
		target.ddz_spring = ddz_spring
	end
	target.ddz_spring.char_obj:setScale(0.05)
	target.ddz_spring.f_obj_a:setScale(0.05)
	target.ddz_spring.f_obj_b:setScale(0.05)
	
	target.ddz_spring.char_obj:setPosition(ccp(150,320))
	target.ddz_spring.f_obj_a:setPosition(ccp(80,330))
	target.ddz_spring.f_obj_b:setPosition(ccp(220,310))
	
	target.ddz_spring:setPosition(ccp(240,-90))
	target.ddz_spring:setVisible(true)

	function destory_me()
		cclog("DDZSpring.destory_me")
		target.ddz_spring:setVisible(false)
--		target:removeChild(ddz_rocket)
	end
	
	char_action = CCCallFuncN:create(function() 
		cclog("DDZSpring.char_action")
		target.ddz_spring.char_obj:runAction(CCScaleTo:create(1.0, 1.0, 1.0))
	end)
	f_a_action = CCCallFuncN:create(function() 
		cclog("DDZSpring.f_a_action")
		target.ddz_spring.f_obj_a:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.0, 1.0), 
		 CCSpawn:createWithTwoActions(CCRotateBy:create( 0.8, 45), CCMoveBy:create(0.8,ccp(-10, 25)))))
	end)
	f_b_action = CCCallFuncN:create(function() 
		cclog("DDZSpring.f_b_action")
		target.ddz_spring.f_obj_b:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.0, 1.0), 
		CCSpawn:createWithTwoActions(CCRotateBy:create( 0.8, 45), CCMoveBy:create(0.5,ccp(10, -25)))))
	end)
	local array = CCArray:create()
	array:addObject(char_action)
	array:addObject(CCDelayTime:create(1))
	array:addObject(f_a_action)
	array:addObject(f_b_action)
	array:addObject(CCDelayTime:create(2.0))
	array:addObject(CCCallFuncN:create(destory_me))
	target.ddz_spring:runAction(CCSequence:create(array))
	
end
