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
	self.ccbproxy = CCBProxy:create()
 	self.ccbproxy:retain()
 	
 	local node = self.ccbproxy:readCCBFromFile("RoomItem.ccbi")
	assert(node, "failed to load hall scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	self.rootNode:ignoreAnchorPointForPosition(false)
	self.rootNode:setAnchorPoint(ccp(0,0.5))
	self.rootNode:setPosition(ccp(0,240))
	local bg = self.ccbproxy:getNodeWithType("bg", "CCSprite")
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
            local sca = CCScaleBy:create(0.1, 1.5)
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
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end