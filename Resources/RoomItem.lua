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
 	CCBuilderReaderLoad("RoomItem.ccbi", ccbproxy, self)
	self:addChild(self.rootNode)

	-- local function onTouchRoom(eventType, x, y)
	-- 	print("room item touch:" .. eventType , '(', x, ', ', y , ')')
	-- 	local rect = self.rootNode:getBoundingBox()
	-- 	print('[RoomItem..onTouchRoom] rect: ', rect:getMinX(), ', ', rect:getMinY(), ', ', rect:getMaxX() , ', ', rect:getMaxY())
	-- 	if not self.rootNode:boundingBox():containsPoint(self:convertToNodeSpace(ccp(x, y))) then
	-- 		print("not in boundingbox")
	-- 		self.dianji:setVisible(false)
	-- 		return 
	-- 	end
    
 --    if eventType == "began" then
 --    	self.dianji:setVisible(true)
 --      return true
 --    elseif eventType == "moved" then
 --   	elseif eventType == "ended" then
 --    	self.dianji:setVisible(false)
 --    	print("[RoomItem:onTouchRoom] ended")
 --    end
 --  end
    
 --  self.rootNode:setTouchEnabled(true)
	-- self.rootNode:registerScriptTouchHandler(onTouchRoom)
	self.rootNode:setTouchEnabled(true)
	self.rootNode:setTouchSwallowEnabled(true)
	self.rootNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			return self:on_touch_event(event.name, event.x, event.y)
		end)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function RoomItem:on_touch_event(eventName, eventX, eventY)
	if eventName == "began" then
      return true
    elseif eventName == "moved" then
   	elseif eventName == "ended" then
   		dump(self.room_info, "RoomItem:on_touch_event, self.room_info=")
    	self.on_touch_callback(self.room_info)
    	print("[RoomItem:on_touch_event] ended")
    end
end

function RoomItem:init_room_info(room_info, room_index)
	self.room_info = room_info
	room_info.is_promotion = is_match_room(room_info)
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.hall_plist)
	cache:addSpriteFramesWithFile(Res.dating_plist)
	
	self.promotion_layer:setVisible(room_info.is_promotion)
	self.normal_layer:setVisible(not room_info.is_promotion)
	self:init_normal_room(room_info, room_index)
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
	local room_name = self.room_info.name
	self.title:setString(room_name)
	
	if room_index > 2 then room_index = room_index - 2 end
	local bg_sprite_png_index = (room_index % 6) > 0 and (room_index % 6) or 6
	if bg_sprite_png_index == 4 then bg_sprite_png_index = 6 end
	local bg_sprite_png_index =  room_index
	local bg_sprite_png = "dt-fangjian"..bg_sprite_png_index..".png"
	print("[RoomItem:init_normal_room], bg_sprite_png= ", bg_sprite_png)
	self.bg_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bg_sprite_png))
	local sp_room_type_desc_png = "dt-putongchang.png"
	self.sp_room_type_desc:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sp_room_type_desc_png))
end

function RoomItem:init_promotion_room(room_info, room_index)
	local status_text = MatchLogic.get_status_text(room_info)
	self.promotion_status_lbl:setString(status_text)
	local bg_sprite_png = 'dt-fangjian1.png'
	local sp_room_type_desc_png = "dt-xiaosongdoufang.png"
	if tonumber(room_info.room_type) == 3 then 
		bg_sprite_png = 'songhuafei.png' 
		sp_room_type_desc_png = "wenzi_songhuafei.png"
	end
	self.promotion_bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bg_sprite_png))
	self.sp_room_type_desc:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sp_room_type_desc_png))
	--for telephone charge match room, show next match start time
	--and hide the status_text
	if tonumber(room_info.room_type) == 3 then
		if not is_blank(room_info.next_match_s_time) then
			local process_time = function(t) return string.sub(t,string.find(t,'T')+1, string.find(t,'T')+5) end
			self.promotion_time_lbl:setString(process_time(room_info.next_match_s_time))
		else
			self.promotion_time_lbl:setString('敬请期待')
		end
		self.promotion_time_layer:setVisible(true)
		self.promotion_status_lbl:setVisible(false)
	else
		self.promotion_time_layer:setVisible(false)
		self.promotion_status_lbl:setVisible(true)	
	end
end


