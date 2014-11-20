require "src.UIControllerPlugin"
require "src.DialogPlugin"
require "src.resources"
require "src.SoundEffect"
DDZPurchase = class("DDZPurchase", function()
	print("new DDZPurchase")
	return display.newLayer("DDZPurchase")
end
)

function createDDZPurchase(confirm_func, cancel_func)
	print("create DDZPurchase")
	return DDZPurchase.new(confirm_func, cancel_func)
end

function DDZPurchase:ctor(confirm_func, cancel_func)
	ccb.DDZPurchase = self
	self.on_commit_clicked = function() self:playButtonEffect() self:dismiss() confirm_func() end
	self.on_cancel_clicked = function()
		if not self.first_click_tag then 
			self.first_click_tag = true
			if math.random() < 0.33 then
				print('do not response to click cancel')
				return 
			else
				print('do response to click cancel')
			end
		end
		self:playButtonEffect() 
		self:dismiss()
		if cancel_func then cancel_func() end
	end
	local ccbproxy = CCBProxy:create()
 	CCBReaderLoad("DDZPurchase.ccbi", ccbproxy, true, "DDZPurchase")
	self:addChild(self.rootNode)
	self.confirm_func = confirm_func
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:init_dialog()
	self:setClickOutDismiss(false)
end

function DDZPurchase:init(item)
	dump(item, 'ddz purchase init item')
	local icon_sprite = tolua.cast(self.icon_sprite, "CCSprite")
	dump(item, 'ddz purchase init item--1')
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Res.props_plist)

	icon_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(item.icon))
	dump(item, 'ddz purchase init item--2')
	set_rank_string_with_stroke(self.name_lbl, item.name)
	set_rank_string_with_stroke(self.price_lbl, item.rmb..'元')
	set_anniu_1_3_stroke(self.commit_btn_lbl)
	set_rank_stroke(self.cancel_btn_lbl)
	set_rank_stroke(self.shoujia_lbl)
	self.note_lbl:setString(item.note)
	self:set_is_restricted(item.is_prompt and item.must_show)
	if not is_blank(item.title) then
		self.confirm_layer:setVisible(false)
		set_rank_string_with_stroke(self.prompt_lbl, item.title)
	else
		self.prompt_lbl:setVisible(false)
		set_anniu_1_3_stroke(self.confirm_lbl1)
		set_anniu_1_3_stroke(self.confirm_lbl2)
		set_anniu_1_3_stroke(self.confirm_lbl3)

	end
	
end

UIControllerPlugin.bind(DDZPurchase)
SoundEffect.bind(DDZPurchase)
DialogPlugin.bind(DDZPurchase)