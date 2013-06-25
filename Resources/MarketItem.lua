
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
end

function MarketItem:init_item(product)
	print("[MarketItem:init_item]")
	self.product = product
	local name_lb = tolua.cast(self.name_lb, "CCLabelTTF")
	name_lb:setString(product.name)
	
	local note_lb = tolua.cast(self.note_lb, "CCLabelTTF")
	note_lb:setString(product.note)
	
	local price_lb = tolua.cast(self.price_lb, "CCLabelTTF")
	price_lb:setString("价格 "..product.rmb.."元")

	
end

function MarketItem:do_ui_buy_btn_clicked(tag, sender)
	print("[MarketItem:do_ui_buy_btn_clicked]")
	
end

