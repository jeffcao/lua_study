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
	
	local ccbproxy = CCBProxy:create()
 	ccbproxy:retain()
 	CCBReaderLoad("ChargeRoomHall.ccbi", ccbproxy, true, "charge_room_hall")
	self:addChild(self.rootNode)

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self.bg:setScaleX(GlobalSetting.content_scale_factor * (800/609))
	self.bg:setScaleY(GlobalSetting.content_scale_factor * (340/359))
	
	self:init_rooms()
	
	self:init_dialog()
	self:setClickOutDismiss(false)
	self:setBackDismiss(false)
	self:attach_to(CCDirector:sharedDirector():getRunningScene().rootNode)
	
	self.close_btn.on_touch_fn = function()
		self:dismiss()
	end
	
	self:registerNodeEvent()
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
	self.super.onEnter(self)
	
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

local positions = {}
positions[3] = {ccp(25, 120), ccp(270, 120), ccp(515, 120)}
positions[4] = {ccp(25, 170), ccp(270, 170), ccp(515, 170), ccp(270, 55)}
function ChargeRoomHall:init_rooms()
	local matches = DataProxy.get_exist_instance('charge_matches'):get_data().match_list
	--TODO remove match after index 4 for test
	--for index=1, #matches do
	--	if index > 4 then matches[index] = nil end
	--end
	
	--dump(matches, 'matches')
	local count = #matches
	
	local layer = CCLayer:create()
	local winSize = CCDirector:sharedDirector():getWinSize()
	layer:setAnchorPoint(ccp(0,0.5))
	layer:setPosition(0, winSize.height/2)
	layer:ignoreAnchorPointForPosition(false)
	
	local margin = 25
	local deltax = 225
	
	if count <= 4 then
		local poses = nil
		if count <= 3 then
			poses = positions[3]
		else
			poses = positions[4]
		end
		
		for index=1, count do
			local layer1 = createChargeRoomItem()
			layer1:init_room_info(matches[index])
			layer1:setPosition(poses[index])
			layer:addChild(layer1)
		end
		local h = winSize.height * (2/3)
		local w = winSize.width
		layer:setContentSize(CCSizeMake(w, h))
	else
		margin = 50
		local y1 = 170
		local y2 = 55
		local single = toint(count/2)
		
		local startx = margin
		
		for index=1, single do
			local layer2 = createChargeRoomItem()
			layer2:init_room_info(matches[index])
			layer2:setPosition(ccp(startx + (index-1)*deltax, y1))
			layer:addChild(layer2)
		end
		for index=single+1, count do
			local layer2 = createChargeRoomItem()
			layer2:init_room_info(matches[index])
			layer2:setPosition(ccp(startx + (index-single-1)*deltax, y2))
			layer:addChild(layer2)
		end
		local h = winSize.height * (2/3)
		local w = (single)*deltax
		print('set node to h='..h..'w='..w)
		layer:setContentSize(CCSizeMake(w, h))
	end
	
	local function onTouchRoom(eventType, x, y)
		print("room item touch:" .. eventType)
		local layer_width = layer:getContentSize().width
        if eventType == "began" then
        	layer.startx = x
        	layer.lastx = x
        	layer.moved = 0
            return true
        elseif eventType == "moved" then
        	if layer_width <= winSize.width then return end
        	local delta = x - layer.lastx
        	local px,py = layer:getPosition()
        	local max = 0
        	local min = CCDirector:sharedDirector():getWinSize().width - 2 * margin - layer_width
        	if px + delta >= max then
        		layer:setPosition(ccp(max, py))
        	elseif px + delta <= min then
        		layer:setPosition(ccp(min, py))
        	else
        		layer:setPosition(ccp(px+delta, py))
        	end
        	layer.lastx = x
        	layer.moved = layer.moved + 1
        elseif eventType == "ended" then
        	layer.startx = nil
        	layer.lastx = nil
        	if layer.moved <= MOVE_TEST_LIMIT then
        		local children = layer:getChildren()
        		for index=1, children:count() do
        			local child = children:objectAtIndex(index - 1)
        			if cccn(child.rootNode, x, y) then
        				child:on_click()
        				break
        			end
        		end
        	end
        	layer.moved = nil
        end
        return true
    end
	
	local dlg = layer
	dlg:setTag(1111)
	
	dumprect(dlg:boundingBox(), 'charge bouding box')
	dlg.on_touch_fn = onTouchRoom
	self.rootNode:removeChildByTag(1111, true) -- temp remove match list, should update match list, need time to do this function
	self.rootNode:addChild(dlg)
	self:recreate_sel_childs()
	self:set_matchs_matchtype()
end

DialogPlugin.bind(ChargeRoomHall)
ChargeHallMatchPlugin.bind(ChargeRoomHall)