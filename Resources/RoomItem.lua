require 'CCBReaderLoad'
require 'src.MatchLogic'
RoomItem = class("RoomItem", function() 
	print("new room item")
	return display.newLayer("RoomItem")
	end
)

function createRoomItem()
	print("create room item")
	return RoomItem.new()
end

function RoomItem:ctor()
	ccb.room_item = self
	
	local ccbproxy = CCBProxy:create()
 	ccbproxy:retain()
 	CCBReaderLoad("RoomItem.ccbi", ccbproxy, true, "root_item")
	self:addChild(self.rootNode)

	local function onTouchRoom(eventType, x, y)
		print("room item touch:" .. eventType)
		if not self.rootNode:boundingBox():containsPoint(self:convertToNodeSpace(ccp(x, y))) then
			print("not in boundingbox")
			self.dianji:setVisible(false)
			return
		end
        if eventType == "began" then
        	self.dianji:setVisible(true)
            return true
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        	self.dianji:setVisible(false)
        	print("[RoomItem:onTouchRoom] ended")
        end
    end
    
    self.rootNode:setTouchEnabled(true)
	self.rootNode:registerScriptTouchHandler(onTouchRoom)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function RoomItem:init_room_info(room_info, room_index)
	self.room_info = room_info
	room_info.is_promotion = tonumber(room_info.type) == 2 or tonumber(room_info.type) == 3
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.hall_plist)
	
	self.promotion_layer:setVisible(room_info.is_promotion)
	self.normal_layer:setVisible(not room_info.is_promotion)
	if not room_info.is_promotion then
		self:init_normal_room(room_info, room_index)
	else
		self:init_promotion_room(room_info, room_index)
	end
	
end

function RoomItem:init_normal_room(room_info, room_index)
	self.zhunru_lb:setString(self.room_info.min_qualification.."豆子")
	self.dizhu_lb:setString(self.room_info.ante)
	dump(self.title, "room_title")
	local room_name = "农耕畜牧"

	if tonumber(self.room_info.room_type) == 2 then
		room_name = "别具匠心"
	elseif tonumber(self.room_info.room_type) == 3 then
		room_name = "经营四方"
	elseif tonumber(self.room_info.room_type) == 4 then
		room_name = "锦绣仕途"
	end
	room_name = self.room_info.name
	self.title:setString(room_name)
	
	local bg_sprite_png_index = (room_index % 6) > 0 and (room_index % 6) or 6
	local bg_sprite_png = "fangjian0"..bg_sprite_png_index..".png"
	self.bg_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bg_sprite_png))
end

function RoomItem:init_promotion_room(room_info, room_index)
	local status_text = MatchLogic.get_status_text(room_info)
	self.promotion_status_lbl:setString(status_text)
end


