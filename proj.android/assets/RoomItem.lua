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
			return
		end
        if eventType == "began" then
        	self.move = 0
            return true
        elseif eventType == "moved" then
        	self.move = self.move + 1
        elseif eventType == "ended" then
        	if self.move < 3 then
	        	if not self.rootNode:getActionByTag(10) then
		            local sca = CCScaleBy:create(0.1, 1.2)
		            local sca2 = CCScaleTo:create(0.1, 1)
		        	local seq = CCSequence:createWithTwoActions(sca, sca2)
		        	seq:setTag(10)
		        	self.rootNode:runAction(seq)
	        	end
        	end
        	self.move = 0
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
	zhunru_lb:setString("准入资格"..self.room_info.min_qualification.."豆子")
	local dizhu_lb = tolua.cast(self.dizhu_lb, "CCLabelTTF")
	dizhu_lb:setString(self.room_info.ante)
	local level_sprite = tolua.cast(self.level_sprite, "CCSprite")
	local room_leve_png = "xinshou.png"

	if tonumber(self.room_info.room_type) == 2 then
		room_leve_png = "zhongshou.png"
	elseif tonumber(self.room_info.room_type) == 3 then
		room_leve_png = "gaoshou.png"
	elseif tonumber(self.room_info.room_type) == 4 then
		room_leve_png = "dashi.png" 
	end
	level_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(room_leve_png))
	
	local bg_sprite = tolua.cast(self.bg_sprite, "CCSprite")
	local bg_sprite_png_index = (room_index % 6) > 0 and (room_index % 6) or 6
	local bg_sprite_png = "fangjian0"..bg_sprite_png_index..".png"
	bg_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bg_sprite_png))
	
end


