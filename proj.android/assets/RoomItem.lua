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

--	self.rootNode:ignoreAnchorPointForPosition(false)
--	self.rootNode:setAnchorPoint(ccp(0,0.5))
--	self.rootNode:setPosition(ccp(0,240))

	print("room item self.rootNode ==> ", self.rootNode)
	
	local function onTouch(eventType, x, y)
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
		        	local seq = CCSequence:createWithTwoActions(sca, sca:reverse())
		        	seq:setTag(10)
		        	self.rootNode:runAction(seq)
	        	end
        	end
        	self.move = 0
        end
    end
    
    self.rootNode:setTouchEnabled(true)
	self.rootNode:registerScriptTouchHandler(onTouch)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function RoomItem:init_room_info(room_info)
	self.ante = room_info.ante
	self.fake_online_count = room_info.fake_online_count
	self.limit_online_count = room_info.limit_online_count
	self.max_qualification = room_info.max_qualification
	self.min_qualification = room_info.min_qualification
	self.name = room_info.name
	self.online_count = room_info.online_count
	self.room_id = room_info.room_id
	self.room_type = room_info.room_type
	self.status = room_info.status
	self.urls = room_info.urls
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.hall_plist)
	
	local zhunru_lb = tolua.cast(self.zhunru_lb, "CCLabelTTF")
	zhunru_lb:setString("准入资格"..self.min_qualification.."豆子")
	local dizhu_lb = tolua.cast(self.dizhu_lb, "CCLabelTTF")
	dizhu_lb:setString(self.ante)
	local level_sprite = tolua.cast(self.level_sprite, "CCSprite")
	if tonumber(self.room_type) == 1 then
		level_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("xinshou.png"))
	elseif tonumber(self.room_type) == 2 then
		level_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("zhongshou.png"))
	elseif tonumber(self.room_type) == 3 then
		level_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gaoshou.png"))
	elseif tonumber(self.room_type) == 4 then
		level_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dashi.png")) 
	end
	
end

