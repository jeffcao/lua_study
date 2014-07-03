
MarketItem = class("MarketItem", function() 
	print("new Market item")
	return display.newLayer("MarketItem")
	end
)

function createMarketItem()
	print("create Market item")
	return MarketItem.new()
end

function MarketItem:ctor()

	ccb.matket_item_scene = self
	self.on_ui_buy_btn_clicked = __bind(self.do_ui_buy_btn_clicked, self)

	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("MarketItem.ccbi", ccbproxy, false, "")
	self:addChild(node)

	self.rootNode:ignoreAnchorPointForPosition(false)
	self.rootNode:setAnchorPoint(ccp(0,0.5))

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.props_plist)
	
end

function MarketItem:init_item(product, show_buy_notify)

	print("[MarketItem:init_item]")
	
	self.show_buy_notify = show_buy_notify
	self.product = product
	local name_lb = tolua.cast(self.name_lb, "CCLabelTTF")
	name_lb:setString(product.name)
	
	local note_lb = tolua.cast(self.note_lb, "CCLabelTTF")
--	note_lb:setDimensions(CCSizeMake(350,42))
	note_lb:setString(product.note)

	local price_lb = tolua.cast(self.price_lb, "CCLabelTTF")
	price_lb:setString("价格 "..product.rmb.."元")

	local icon_sprite = tolua.cast(self.icon_sprite, "CCSprite")
	icon_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(product.icon))
	print("[MarketItem:init_item] name=> "..product.name.." icon=> "..product.icon)
	set_anniu_1_3_stroke(tolua.cast(self.lb_buy_btn, "CCLabelTTF"))
end

function MarketItem:do_ui_buy_btn_clicked(tag, sender)
	print("[MarketItem:do_ui_buy_btn_clicked]")
	self.show_buy_notify(self.product)
end

