
PlayerProductItem = class("MarketItem", function() 
	print("new Market item")
	return display.newLayer("MarketItem")
	end
)

function createPlayerProductItem()
	print("create Market item")
	return MarketItem.new()
end

function PlayerProductItem:ctor()

	ccb.matket_item_scene = self
	self.on_ui_use_btn_clicked = __bind(self.do_ui_use_btn_clicked, self)

	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("PlayerProductItem.ccbi", ccbproxy, false, "")
	self:addChild(node)

	self.rootNode:ignoreAnchorPointForPosition(false)
	self.rootNode:setAnchorPoint(ccp(0,0.5))

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.props_plist)
		
end

function PlayerProductItem:init_item(product, show_use_notify)

	print("[PlayerProductItem:init_item]")
	
	self.show_use_notify = show_use_notify
	self.product = product
	local name_lb = tolua.cast(self.name_lb, "CCLabelTTF")
	name_lb:setString(product.name)
	
	local note_lb = tolua.cast(self.note_lb, "CCLabelTTF")
	note_lb:setString(product.note)

	local icon_sprite = tolua.cast(self.icon_sprite, "CCSprite")
	icon_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(product.icon))
	print("[PlayerProductItem:init_item] name=> "..product.name.." icon=> "..product.icon)
	
end

function PlayerProductItem:do_ui_use_btn_clicked(tag, sender)
	print("[PlayerProductItem:do_ui_buy_btn_clicked]")
	self.show_use_notify(self.product)
end

