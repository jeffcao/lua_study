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
	self.room_info = room_info
	dump(room_info, 'room_info')
	self.start_time:setString(room_info.start_time)
	self.ante:setString(room_info.ante .. '豆子')
	local sprite_frame_name = nil
	if room_info.type == 'ten' then
		sprite_frame_name = 'wenzi_10yuansai.png'
	elseif room_info.type == 'thirty' then
		sprite_frame_name = 'wenzi_30yuansai.png'
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile('ccbResources/charge.plist')
	local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sprite_frame_name)
	self.head:setDisplayFrame(frame)
end

function ChargeRoomItem:on_click()
	local info = createChargeRoomInfo()
	info:init_room_info(self.room_info)
    info:show()
end