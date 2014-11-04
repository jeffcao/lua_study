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

	self.rootNode:setTouchEnabled(true)
	self.rootNode:setTouchSwallowEnabled(false)
	self.rootNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			return self:on_touch_event(event.name, event.x, event.y)
		end)

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
--	self.bg:setScaleX(GlobalSetting.content_scale_factor * 0.852)
--	self.bg:setScaleY(GlobalSetting.content_scale_factor * 0.644)
end

function ChargeRoomItem:on_touch_event(eventName, eventX, eventY)
	if eventName == "began" then
      return true
    elseif eventName == "moved" then
    	return true
   	elseif eventName == "ended" then
   		if not GlobalSetting.charge_hall_scroll_view_moving then
   			if cccn(self.rootNode, eventX, eventY) then
				dump(self.room_info, "ChargeRoomItem:on_touch_event, self.room_info=")
		    	self:on_click()
		    	print("[ChargeRoomItem:on_touch_event] ended")
			end
   		end
   		
   		return true
    end
end


function ChargeRoomItem:init_room_info(room_info)
	self.room_info = room_info
	dump(room_info, 'room_info')
	self.start_time:setString(room_info.begin_time)
	self.ante:setString(room_info.entry_fee .. '豆子')
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile('ccbResources/charge.plist')
	local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(room_info.png_name)
	self.head:setDisplayFrame(frame)
	
	local status_text = TelephoneChargeUtil.get_status_text(room_info)
	self.status_lbl:setString(status_text)
end

function ChargeRoomItem:on_click()
	local status = self.room_info.match_state
	local joined = self.room_info.p_is_joined
	if status == CHARGE_MATCH_STATUS.ended then
		ToastPlugin.show_message_box(strings.tc_match_ended)
		return
	end
	
	local info = createChargeRoomInfo()
	info:init_room_info(self.room_info)
    info:show()
    
    AppStats.event(UM_CHARGE_MATCH_HALL_CLICK_MATCH)
end