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

	local function onTouchRoom(eventType, x, y)
		print("room item touch:" .. eventType)
		if not self.rootNode:boundingBox():containsPoint(self:convertToNodeSpace(ccp(x, y))) then
			print("not in boundingbox")
			return
		end
        if eventType == "began" then
        	self.dianji:setVisible(true)
            return true
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        	print("[ChargeRoomItem:onTouchRoom] ended")
        end
    end
    
    --self.rootNode:setTouchEnabled(true)
	--self.rootNode:registerScriptTouchHandler(onTouchRoom)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function ChargeRoomItem:init_room_info()
end
