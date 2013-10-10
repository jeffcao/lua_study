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
	ccb.room_item_scene = self
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("RoomItem.ccbi", ccbproxy, false, "")
	self:addChild(node)

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
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.hall_plist)
	
	local zhunru_lb = tolua.cast(self.zhunru_lb, "CCLabelTTF")
	zhunru_lb:setString(self.room_info.min_qualification.."豆子")
	local dizhu_lb = tolua.cast(self.dizhu_lb, "CCLabelTTF")
	dizhu_lb:setString(self.room_info.ante)
	local level_sprite = tolua.cast(self.level_sprite, "CCSprite")
	local title = tolua.cast(self.title, "CCLabelTTF")
	dump(self.title, "room_title")
	local room_name = "农耕畜牧"
	--local room_leve_png = "xinshou.png"

	if tonumber(self.room_info.room_type) == 2 then
		room_name = "别具匠心"
	--	room_leve_png = "zhongshou.png"
	elseif tonumber(self.room_info.room_type) == 3 then
		room_name = "经营四方"
	--	room_leve_png = "gaoshou.png"
	elseif tonumber(self.room_info.room_type) == 4 then
		room_name = "锦绣仕途"
	--	room_leve_png = "dashi.png" 
	end
	--level_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(room_leve_png))
	title:setString(room_name)
	
	local bg_sprite = tolua.cast(self.bg_sprite, "CCSprite")
	local bg_sprite_png_index = (room_index % 6) > 0 and (room_index % 6) or 6
	local bg_sprite_png = "fangjian0"..bg_sprite_png_index..".png"
	bg_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bg_sprite_png))
	
end


