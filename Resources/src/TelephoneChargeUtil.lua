-- this file is use for activity of telephone charge for version 1.4.0

require 'consts'
require 'src.DialogPlugin'
require 'telephone-charge.ChargeRoomItem'

local time = 12
local positions = {}
positions[3] = {ccp(60, 100), ccp(300, 100), ccp(540, 100)}
positions[4] = {ccp(60, 130), ccp(300, 130), ccp(540, 130), ccp(300, 0)}
TelephoneChargeUtil = {}

TelephoneChargeUtil.is_telephone_charge_room = function(room_info)
	return room_info and tonumber(room_info.room_type) == ROOM_TYPE_TELEPHONE_CHARGE
end

TelephoneChargeUtil.on_telehone_charge_room_clicked = function()
	time = time + 1
	--if time > 4 then time = 1 end
	local layer = CCLayer:create()
	local winSize = CCDirector:sharedDirector():getWinSize()
	--layer:setContentSize(CCSizeMake(winSize.width, winSize.height * (2/3)))
	layer:setAnchorPoint(ccp(0,0.5))
	layer:setPosition(20, winSize.height/2)
	layer:ignoreAnchorPointForPosition(false)
	
	local margin = 20
	
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
		layer:setContentSize(CCSizeMake(winSize.width, winSize.height * (2/3)))
	else
		local y1 = 130
		local y2 = 0
		local single = toint(time/2)
		--local layer1 = createChargeRoomItem()
		--layer1:setVisible(false)
		--runningscene():addChild(layer1)
		local deltax = 200
		--print('deltax is', deltax)
		--runningscene():removeChild(layer1, true)
		local startx = 20
		
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
		local w = (single+1)*deltax
		print('set node to h='..h..'w='..w)
		layer:setContentSize(CCSizeMake((single+1)*deltax, winSize.height * (2/3)))
	end
	
	--[[
	local scroll_view = CCScrollView:create()
	scroll_view:setViewSize(CCSizeMake(660,300))
	scroll_view:setContainer(layer)
	scroll_view:setContentOffset(ccp(0,-100))
	scroll_view:setPosition(ccp(75,winSize.height/2))
	scroll_view:setDirection(kCCScrollViewDirectionHorizontal)
	scroll_view:setBounceable(true)
	--scroll_view:setContentSize(CCSizeMake(winSize.width, winSize.height * (2/3)))
	]]
	
	local function onTouchRoom(eventType, x, y)
		print("room item touch:" .. eventType)
		--[[
		if not layer:boundingBox():containsPoint(layer) then
			return
		end
		]]
        if eventType == "began" then
        	layer.startx = x
        	layer.lastx = x
            return true
        elseif eventType == "moved" then
        	local delta = x - layer.lastx
        	local px,py = layer:getPosition()
        	local max = margin
        	local min = CCDirector:sharedDirector():getWinSize().width + margin - layer:getContentSize().width
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
        	ToastPlugin.show_server_notify('haha')
        	end
        	layer.moved = nil
        end
    end
    
    --layer:setTouchEnabled(true)
	--layer:registerScriptTouchHandler(onTouchRoom)
	
	local dlg = layer
	dlg:setTag(1011)
	
	dumprect(dlg:boundingBox(), 'charge bouding box')
	dlg.on_touch_fn = onTouchRoom
	DialogPlugin.bind(dlg)
	dlg.bg = dlg
	dlg:init_dialog()
	dlg:setClickOutDismiss(false)
	dlg:attach_to_scene()
	dlg:show()
	
	print('scroll view pos:',dlg:getPosition())
end