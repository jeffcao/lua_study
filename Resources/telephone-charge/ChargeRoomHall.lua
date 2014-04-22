require 'CCBReaderLoad'
require 'src.DialogPlugin'
require 'telephone-charge.ChargeRoomItem'
require 'telephone-charge.ChargeRoomInfo'

ChargeRoomHall = class("ChargeRoomHall", function() 
	return display.newLayer("ChargeRoomHall")
	end
)

function createChargeRoomHall()
	print("create charge room hall")
	return ChargeRoomHall.new()
end

function ChargeRoomHall:ctor()
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
end
local time = 0
local positions = {}
positions[3] = {ccp(25, 120), ccp(270, 120), ccp(515, 120)}
positions[4] = {ccp(25, 170), ccp(270, 170), ccp(515, 170), ccp(270, 55)}
function ChargeRoomHall:init_rooms()
	time = time + 1
	local layer = CCLayer:create()
	local winSize = CCDirector:sharedDirector():getWinSize()
	layer:setAnchorPoint(ccp(0,0.5))
	layer:setPosition(0, winSize.height/2)
	layer:ignoreAnchorPointForPosition(false)
	
	local margin = 25
	local deltax = 225
	
	if time <= 4 then
		local poses = nil
		if time <= 3 then
			poses = positions[3]
		else
			poses = positions[4]
		end
		
		for index=1, time do
			local layer1 = createChargeRoomItem()
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
		local single = toint(time/2)
		
		local startx = margin
		
		for index=1, single do
			local layer2 = createChargeRoomItem()
			layer2:setPosition(ccp(startx + (index-1)*deltax, y1))
			layer:addChild(layer2)
		end
		for index=single+1, time do
			local layer2 = createChargeRoomItem()
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
        	layer.moved = true
        elseif eventType == "ended" then
        	layer.startx = nil
        	layer.lastx = nil
        	if not layer.moved then
        		local children = layer:getChildren()
        		for index=1, children:count() do
        			local child = children:objectAtIndex(index - 1)
        			if cccn(child.rootNode, x, y) then
        			--	ToastPlugin.show_message_box_suc('click at' .. index, {dismiss_time=0.5})
        				local info = createChargeRoomInfo()
        				info:show()
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
	self.rootNode:addChild(dlg)
end

DialogPlugin.bind(ChargeRoomHall)