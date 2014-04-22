require 'CCBReaderLoad'
require 'src.MatchLogic'

ChargeRoomItem = class("ChargeRoomItem", function() 
	return display.newLayer("ChargeRoomItem")
	end
)

function createChargeRoomItem()
	print("create charge room item")
	return ChargeRoomItem.new()
end

function ChargeRoomItem:ctor()
	ccb.ChargeRoomItem = self
	
	local ccbproxy = CCBProxy:create()
 	ccbproxy:retain()
 	CCBReaderLoad("ChargeRoomItem.ccbi", ccbproxy, true, "ChargeRoomItem")
	self:addChild(self.rootNode)

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self.bg:setScaleX(GlobalSetting.content_scale_factor * 0.852)
	self.bg:setScaleY(GlobalSetting.content_scale_factor * 0.644)
end

function ChargeRoomItem:init_room_info(room_info)
end

function ChargeRoomItem:on_click()
end