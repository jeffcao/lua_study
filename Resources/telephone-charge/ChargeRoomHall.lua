require 'CCBReaderLoad'
require 'src.DialogPlugin'
require 'consts'
require 'telephone-charge.ChargeRoomItem'
require 'telephone-charge.ChargeRoomInfo'
require 'telephone-charge.DataProxy'
require 'telephone-charge.ChargeHallMatchPlugin'

--ChargeRoomHall = class("ChargeRoomHall", function() 
--	return display.newLayer("ChargeRoomHall")
--	end
--)

ChargeRoomHall = class("ChargeRoomHall", CCLayerExtend)

function ChargeRoomHall.extend(target, ...)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, ChargeRoomHall)
    if target.ctor ~= nil then
    	target:ctor(...)
    end
    return target
end

function createChargeRoomHall()
	print("create charge room hall")
	--return ChargeRoomHall.new()
	return ChargeRoomHall.extend(CCLayer:create())
	--return ChargeRoomHall.new()
end

function ChargeRoomHall:ctor()
	print('ChargeRoomHall:ctor()')
	ccb.charge_room_hall = self

  self.on_close_clicked = function()
    self:dismiss()
  end
	
	local ccbproxy = CCBProxy:create()
 	--ccbproxy:retain()
  --CCBReaderLoad("ChargeRoomHall.ccbi", ccbproxy, true, "charge_room_hall")
 	CCBuilderReaderLoad("ChargeRoomHall.ccbi", ccbproxy, self)
	self:addChild(self.rootNode)

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
--	self.bg:setScaleX(GlobalSetting.content_scale_factor * (800/609))
--	self.bg:setScaleY(GlobalSetting.content_scale_factor * (340/359))
	
	self:init_rooms()
	
	self:init_dialog()
	self:setClickOutDismiss(false)
	self:setBackDismiss(false)
	self:attach_to(CCDirector:sharedDirector():getRunningScene().rootNode)
	
	-- self.close_btn.on_touch_fn = function()
	-- 	self:dismiss()
	-- end
	
	self:setNodeEventEnabled(true)
	self:onEnter()--because can't receive 'enter' event, so call it manually
end

function ChargeRoomHall:set_charge_room(charge_room)
	self.charge_room = charge_room
	
	self:set_matchs_matchtype()
end

function ChargeRoomHall:set_matchs_matchtype()
	if not self.charge_room then return end

	-- set match's match_type to charge room's room_type
	-- set match's room_id to charge room's room_id
	-- this value will be used in request join or enter match
	local matches = DataProxy.get_exist_instance('charge_matches'):get_data().match_list
	for _, match in pairs(matches) do
		match.match_type = self.charge_room.room_type
		match.room_id = self.charge_room.room_id
	end
end

function ChargeRoomHall:onEnter()
	print("ChargeRoomHall:onEnter()")
	--self.super.onEnter(self)
	
	--if time is near 24:00, set a timer to get charge room from server on 24:00:02
	local seconds_left = get_seconds_left_today()
	if seconds_left <= CHARGE_ROOM_24_DETECT_MIN then
		print('set 24:00 timer', seconds_left)
		local function timer_24_func()
			self:get_charge_room_from_server('timer_24_func')
		end
		self.timer_24 = Timer.add_timer(seconds_left + CHARGE_ROOM_24_DETECT_EXCEED, timer_24_func, '24_timer')
	end
	
	--listen global channel match event
	self:listen_match_event()
	
	--listen charge_matches data change, name is charge_room_hall
	DataProxy.get_exist_instance('charge_matches'):register('charge_room_hall', __bind(self.init_rooms, self))
	
	AppStats.event(UM_CHARGE_MATCH_HALL_SHOW)
end

function ChargeRoomHall:onExit()
	print("ChargeRoomHall:onExit()")
	self.super.onExit(self)
	
	--if has set 24:00 timer, cancel this
	if self.timer_24 then
		Timer.cancel_timer(self.timer_24)
	end
	
	--unlisten global channel match event
	self:unlisten_match_event()
	
	--unlisten charge_matches data change, name is charge_room_hall
	DataProxy.get_exist_instance('charge_matches'):unregister('charge_room_hall')
end


function ChargeRoomHall:init_rooms()
	local matches = DataProxy.get_exist_instance('charge_matches'):get_data().match_list
	print("[ChargeRoomHall:refresh_room_scrollview]")
		if not self.croom_layer_scrollview then
			self.scrollTop = 270
			self.scrollHeight = 270
			self.scrollWidth = 700
			self.cellHeight = 130
			self.cellWidth = 230
			self.cellNums = #(matches)/2 + #(matches)%2

			self.ScrollContainer = display.newLayer()
			self.ScrollContainer:setContentSize(CCSizeMake(self.cellWidth*self.cellNums, self.cellHeight*2))
		    self.ScrollContainer:setTouchEnabled(true)
		    self.ScrollContainer:setPosition(ccp(1, 0))
		    self.ScrollContainer:setTouchSwallowEnabled(false)
		    self.ScrollContainer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		    	print("ChargeRoomHall:refresh_room_scrollview, ScrollContainer.ontouched")
		        return self:onScrollCellCallback(event.name, event.x, event.y)
		    end)
			
	
			self.croom_layer_scrollview = CCScrollView:create()
			self.croom_layer_scrollview:setContentSize(CCSizeMake(0, 0))
			self.croom_layer_scrollview:setViewSize(CCSizeMake(700, 270))
			self.croom_layer_scrollview:setContainer(self.ScrollContainer)
			self.croom_layer_scrollview:setDirection(kCCScrollViewDirectionHorizontal)
			self.croom_layer_scrollview:setClippingToBounds(true)
			self.croom_layer_scrollview:setBounceable(true)
			self.croom_layer_scrollview:setDelegate(this)

			self.preOffy = self.ScrollContainer:getPositionX()

			local function scrollView2DidScroll()
				print("ChargeRoomHall:refresh_room_scrollview, scrollView2DidScroll")
			
			end
			self.croom_layer_scrollview:registerScriptHandler(scrollView2DidScroll, CCScrollView.kScrollViewScroll)

			-- self.room_layer_scrollview:onScroll(handler(self, self.scrollListener))
			self.croom_layer_scrollview:setPosition(CCPointMake(0,0))
			self.r_content:addChild(self.croom_layer_scrollview)
			self.room_datas = matches
			local k=0
			for i=1, #(matches) do
				local i_room = createChargeRoomItem()
				print("[ChargeRoomHall:refresh_room_scrollview] idx: " .. i, i_room)
				i_room:init_room_info(matches[i])

				i_room:setPosition(ccp(k*225+5, (i%2)*130+20))
				self.ScrollContainer:addChild(i_room)
				if (i%2) == 0 then k=k+1 end

			end

		end

end

function ChargeRoomHall:onScrollCellCallback(event, x, y)
    if event == "began" then
    	self.bolTouchEnd = false
    	self.scroll_view_moved_x_s = x
    	GlobalSetting.charge_hall_scroll_view_moving = false
    	print("ChargeRoomHall:onScrollCellCallback, began")
    elseif event == "moved" then
    	local x_distance = math.abs(x - self.scroll_view_moved_x_s)
    	print("ChargeRoomHall:onScrollCellCallback, moved, x_distance=", x_distance)
    	if x_distance > 10 then
    		GlobalSetting.charge_hall_scroll_view_moving = true
    	end
    elseif event == "ended" then
    	self.bolTouchEnd = true
    	print("ChargeRoomHall:onScrollCellCallback,  ended")
    end
    return true

end


DialogPlugin.bind(ChargeRoomHall)
ChargeHallMatchPlugin.bind(ChargeRoomHall)