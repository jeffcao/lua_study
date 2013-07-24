
PlayerProductItem = class("PlayerProductItem", function() 
	print("new PlayerProductItem")
	return display.newLayer("PlayerProductItem")
	end
)

function createPlayerProductItem()
	print("create PlayerProductItem")
	return PlayerProductItem.new()
end

function PlayerProductItem:ctor()

	ccb.product_item_scene = self
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

function PlayerProductItem:use_product_callback(count)
	print("[PlayerProductItem:init_item]")
	print("[PlayerProductItem:init_item] parameter count =>"..count)
	if tostring(count) == "0" then
		self:getParent():removeChild(self, true)
	else
		local count_lb = tolua.cast(self.count_lb, "CCLabelTTF")
		count_lb:setString("x"..count)
		local use_btn = tolua.cast(self.use_btn, "CCMenuItemImage")
		print("[PlayerProductItem:init_item] setEnabled(false) ")
		use_btn:setEnabled(false)
	end
	
end

function PlayerProductItem:init_item(product, show_use_notify, small)
	small = small or false
	
	print("[PlayerProductItem:init_item]")
	
	self.show_use_notify = show_use_notify
	self.product = product
	local name_lb = tolua.cast(self.name_lb, "CCLabelTTF")
	name_lb:setString(product.prop_name)
	
	local note_lb = tolua.cast(self.note_lb, "CCLabelTTF")
	if small then
		note_lb:setDimensions(CCSizeMake(270,45))
	end
	note_lb:setString(product.prop_note)
	
	
	local count_lb = tolua.cast(self.count_lb, "CCLabelTTF")
	count_lb:setString("x"..product.prop_count)
	
	local icon_sprite = tolua.cast(self.icon_sprite, "CCSprite")
	icon_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(product.prop_icon))
	print("[PlayerProductItem:init_item] name=> "..product.prop_name.." icon=> "..product.prop_icon)
	
	print("[PlayerProductItem:init_item] using_me=> "..tostring(product.using_me))
	local use_btn = tolua.cast(self.use_btn, "CCMenuItemImage")
	if product.using_me then
		use_btn:setEnabled(false)
	else
		use_btn:setEnabled(true)
	end
	 
	if small then
		self.use_menu:setPosition(CCPointMake(420,34))
	end
	
end

function PlayerProductItem:do_ui_use_btn_clicked(tag, sender)
	print("[PlayerProductItem:do_ui_buy_btn_clicked]")
	self.show_use_notify(self.product, __bind(self.use_product_callback, self))
end

