require 'PromotionInfoScene'
require 'src.AppStats'

PromotionItem = class("PromotionItem", function() 
	print("new promotion item")
	return display.newLayer("PromotionItem")
	end
)

function createPromotionItem()
	print("create promotion item")
	return PromotionItem.new()
end

function PromotionItem:ctor()
	ccb.promotion_item = self
	self.on_speci_clicked = __bind(self.do_on_speci_clicked, self)
	local ccbproxy = CCBProxy:create()
	ccbproxy:retain()
	CCBReaderLoad("PromotionItem.ccbi", ccbproxy, true, "promotion_item")
	
	self:addChild(self.rootNode)
	self.rootNode:ignoreAnchorPointForPosition(false)
	self.rootNode:setAnchorPoint(ccp(0,0.5))

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

--[{:name=>"test", :short_desc:nil,:match_type=>nil, :description=>nil, :rule_desc=>nil, :begin_date=>nil, :end_date=>nil, :image_id=>nil}]
function PromotionItem:init_item(item)
	dump(item, 'init promotion item')
	self.item = item
	self.name_lbl:setString(item.name)
	self.note_lbl:setString(item.short_desc)
	local process_time = function(t) return string.gsub(string.sub(t,0,string.find(t,'T')-1),'-','.') end
	local duration = string.gsub(strings.pi_duration, 'begin', process_time(item.begin_date))
	duration = string.gsub(duration, 'end', process_time(item.end_date))
	self.time_lbl:setString(duration)
	
	item.image_id = "nongminsongli.png"
	if tonumber(item.match_type) == 3 then
		item.image_id = "dizhusongli.png"
	end
	local sprite_frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(item.image_id)
	self.icon_sprite:setDisplayFrame(sprite_frame)
end

function PromotionItem:do_on_speci_clicked()
	print("[PromotionItem:do_on_speci_clicked]")
	AppStats.event(UM_MATCH_DETAIL_SHOW)
	local scene = createPromotionInfoScene(self.item)
	CCDirector:sharedDirector():pushScene(scene)
end

