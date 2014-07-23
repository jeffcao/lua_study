GAnimationPlugin = {}
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()

function GAnimationPlugin.sharedAnimation()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile(Res.s_anim_plist)
	Explosion.sharedExplosion()
	ButterFly.sharedButterFly()
	--Insects.sharedInsects()
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
	GAnimationPlugin.share({"hu die 001.png", "hu die 002.png"},"fly")
end


Insects = class("Insects", function()
	return display.newSprite()
end)

function createInsects()
	return Insects.new()
end

function Insects:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local pFrame = cache:spriteFrameByName("chong zi01.png")
	self:setDisplayFrame(pFrame)
	self:setScale(GlobalSetting.content_scale_factor)

	self.INSECT_DELAY = 120
	self.action_tag = 3000

	local contentSize = self:getContentSize()
	self.half_w = (contentSize.width / 2) * GlobalSetting.content_scale_factor

	self:setPosition(ccp(800 + self.half_w, 295))
	self:scheduleUpdateWithPriorityLua(__bind(self.creep, self), 1)
end

function Insects:creep()
	local actions = self:numberOfRunningActions()
	if (actions == 0) then
		local action = self:rightScreenAction()
		self:runAction(action)
	end
end

function Insects:rightScreenAction()
	local d_x = 720 + self.half_w
	local o_x = 800 + self.half_w
	local creepToDx = self:creepByX(d_x - o_x)
	local turnRight = self:addTurn(1)
	local creepToOx = self:creepByX(o_x - d_x)
	local delay = CCDelayTime:create(self.INSECT_DELAY)
	local reset = CCCallFunc:create(function()
		self:setPosition(ccp(800 + self.half_w,295))
	end)

	local anims = {creepToDx, turnRight, creepToOx, delay, reset}
	local action = CCSequence:create(GAnimationPlugin.tabletoarray(anims))
	return action
end

-- direction then1:creep left, -1:creep rightend
function Insects:creepByX(x)
	local direction = x / math.abs(x)
	local times = x / (direction * 5)
	cclog("times is" .. times)
	local creeps = {}
	for i = 1, times do
		table.insert(creeps, self:addCreep(direction))
	end

	local seq = CCSequence:create(GAnimationPlugin.tabletoarray(creeps))
	return seq
end

-- direction then1:creep left, -1:creep rightend
function Insects:addCreep(direction)
	local name = "creep_left"
	if (direction == 1) then
		name = "creep_right"
	else
		direction = -1
	end
	local animate = GAnimationPlugin.getAnimate(name)
	local delay = CCDelayTime:create(0.5)
	local move = CCMoveBy:create(0.5, ccp(5 * direction, 0))
	local seq = CCSequence:createWithTwoActions(delay, move)
	local action = CCSpawn:createWithTwoActions(animate, seq)
	action:setTag(self.action_tag)
	return action
end

-- direction then1:up left, -1:up rightend
function Insects:addUp(direction)
	local name = "up_left"
	if (direction == 1) then
		name = "up_right"
	end
	local animate = GAnimationPlugin.getAnimate(name)
	animate:setTag(self.action_tag)
	return animate
end

-- direction then1:left turn right, -1:right turn leftend
function Insects:addTurn(direction)
	local name = "turn_right"
	local animate = GAnimationPlugin.getAnimate(name)
	local anims = {CCDelayTime:create(2 * 0.5), CCMoveBy
		:create(0, ccp(20, 0)), CCDelayTime:create(0.5), CCMoveBy
		:create(0, ccp(10, 0)), CCDelayTime:create(2 * 0.5)}
	local seq = CCSequence:create(GAnimationPlugin.tabletoarray(anims))
	local action = CCSpawn:createWithTwoActions(animate, seq)
	if (direction == -1) then
		action = action:reverse()
	end
	action:setTag(self.action_tag)
	return action
end

Insects.sharedInsects = function()
	local turn_right_frames = { "chong zi04.png", "chong zi03.png",
		"chong zi06.png", "chong zi07.png", "chong zi08.png" }
	GAnimationPlugin.share(turn_right_frames, "turn_right")

	local creep_left_frames = { "chong zi01.png", "chong zi02.png" }
	GAnimationPlugin.share(creep_left_frames, "creep_left")

	local creep_right_frames = { "chong zi10.png", "chong zi11.png" }
	GAnimationPlugin.share(creep_right_frames, "creep_right")

	local up_left_frames = { "chong zi04.png", "chong zi03.png", "chong zi04.png" }
	GAnimationPlugin.share(up_left_frames, "up_left")

	local up_right_frames = { "chong zi08.png", "chong zi09.png",
		"chong zi08.png" }
	GAnimationPlugin.share(up_right_frames, "up_right")

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
