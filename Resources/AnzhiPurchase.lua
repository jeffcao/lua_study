require "src.UIControllerPlugin"
require "src.DialogPlugin"
require "src.resources"
require "src.SoundEffect"
AnzhiPurchase = class("AnzhiPurchase", function()
	print("new AnzhiPurchase")
	return display.newLayer("AnzhiPurchase")
end
)

function createAnzhiPurchase(confirm_func)
	print("create AnzhiPurchase")
	return AnzhiPurchase.new(confirm_func)
end

function AnzhiPurchase:ctor(confirm_func)
	ccb.AnzhiPurchase = self
	self.on_commit_clicked = function() self:playButtonEffect() self:dismiss() confirm_func() end
	self.on_cancel_clicked = function() self:playButtonEffect() self:dismiss() end
	local ccbproxy = CCBProxy:create()
 	CCBReaderLoad("AnzhiPurchase.ccbi", ccbproxy, true, "AnzhiPurchase")
	self:addChild(self.rootNode)
	self.confirm_func = confirm_func
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:init_dialog()
	self:setClickOutDismiss(false)
end

function AnzhiPurchase:init(item)
	dump(item, 'anzhi purchase init item')
	local icon_sprite = tolua.cast(self.icon_sprite, "CCSprite")
	dump(item, 'anzhi purchase init item--1')
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Res.props_plist)
	icon_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(item.icon))
	dump(item, 'anzhi purchase init item--2')
	set_rank_string_with_stroke(self.name_lbl, item.name)
	set_rank_string_with_stroke(self.price_lbl, item.rmb..'元')
	set_rank_stroke(self.commit_btn_lbl)
	set_rank_stroke(self.cancel_btn_lbl)
	set_rank_stroke(self.shoujia_lbl)
	self.note_lbl:setString(item.note)
	self:set_is_restricted(item.is_prompt and item.must_show)
	if not is_blank(item.title) then
		self.confirm_layer:setVisible(false)
		set_rank_string_with_stroke(self.prompt_lbl, item.title)
	else
		self.prompt_lbl:setVisible(false)
		set_rank_stroke(self.confirm_lbl1)
		set_rank_stroke(self.confirm_lbl2)
		set_rank_stroke(self.confirm_lbl3)
	end
	
end

UIControllerPlugin.bind(AnzhiPurchase)
SoundEffect.bind(AnzhiPurchase)
DialogPlugin.bind(AnzhiPurchase)