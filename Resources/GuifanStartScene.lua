require "CCBReaderLoad"
require "src.Stats"

local ANIM_INTERVAL = 0.17

GuifanStartScene = class("GuifanStartScene", function()
	return display.newScene("GuifanStartScene")
end)

function createGuifanStartScene()
	return GuifanStartScene.new()
end

function GuifanStartScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	self.onOpenEffectClicked = __bind(self.onOpenEffectClicked, self)
	self.onCloseEffectClicked = __bind(self.onCloseEffectClicked, self)
	ccb.GuifanStart = self
	local node = CCBReaderLoad("GuifanStartScene.ccbi", self.ccbproxy, true, "GuifanStart")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function GuifanStartScene:onEnter()
	--Stats:on_start("guifan_start")
	Stats:on_start("app_total")
end

function GuifanStartScene:onExit()
	--Stats:on_end("guifan_start")
end

function GuifanStartScene:onOpenEffectClicked()
	self:doEffect(true)
end

function GuifanStartScene:onCloseEffectClicked()
	self:doEffect(false)
end

function GuifanStartScene:doEffect(open)
	CCUserDefault:sharedUserDefault():setBoolForKey("bg_music", open)
	CCUserDefault:sharedUserDefault():setBoolForKey("effect_music", open)
	self.layer_volume:setVisible(false)
	self.layer_anim:setVisible(true)
	Timer.add_timer(0.5, function() self:playAnim(1) end)
end

function GuifanStartScene:playAnim(what)
	if what == 1 then
		self.layer_anim_begin:setVisible(false)
		self.layer_anim_run:setVisible(true)
		self.mid_anim:setVisible(true)
		self:translate( self.mid_anim, 3)
		Timer.add_timer(2 * ANIM_INTERVAL, function() self:playAnim(2) end)
		Timer.add_timer(3 * ANIM_INTERVAL, function() self:playAnim(self.anim_end_cmcc) end)
	elseif what == 2 then
		self.left_anim:setVisible(true)
		self.right_anim:setVisible(true)
		Timer.add_timer(ANIM_INTERVAL, function() self:playAnim(3) end)
	elseif what == 3 then
		self:translate(self.left_anim, 2)
		self:translate(self.right_anim, 3)
		Timer.add_timer(2 * ANIM_INTERVAL, function() self:playAnim(self.xzn_ttf) end)
		Timer.add_timer(4 * ANIM_INTERVAL, function() self:playAnim(self.anim_end_chongzi) end)
		Timer.add_timer(5 * ANIM_INTERVAL, function() self:playAnim(4) end)
	elseif what == 4 then
		local ls = createLandingScene()
		CCDirector:sharedDirector():replaceScene(ls)
	else
		what:setVisible(true)
	end
end

function GuifanStartScene:translate(view, count)
	local fade_back = CCFadeTo:create(0,255)
	local fade_to = CCFadeTo:create(ANIM_INTERVAL, 0)
	
	local fade_anim = CCSequence:createWithTwoActions(fade_back, fade_to)
	local repeat_anim = CCRepeat:create(fade_anim, count)
	view:runAction(repeat_anim)
end