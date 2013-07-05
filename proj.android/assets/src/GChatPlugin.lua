GChatPlugin = {}

function GChatPlugin.bind(theClass)
	theClass.chat_layer = nil
	
	function theClass:initChat() 
		local nxlt = self.next_liaotian:getChildByTag(1002)
		nxlt = tolua.cast(nxlt, "CCSprite")
		nxlt:setFlipX(true)
		self:reorderChat(self.next_liaotian)
		self:reorderChat(self.prev_liaotian)
		self:reorderChat(self.self_liaotian)
	end
	
	function theClass:reorderChat(chat) 
		chat:getParent():reorderChild(chat, self.MSG_LAYER_ORDER)
	end
	
	function theClass:onChatTouch(eventType, x, y)
		if not self.chat_layer:isVisible() then return false end
		cclog("onChatTouch touch event:%s,x:%d,y:%d", eventType, x, y)
		if eventType == "began" then
			return self:onChatToucheBegan(ccp(x, y))
		elseif eventType == "moved" then
			return self:onChatToucheMoved(ccp(x, y))
		else
			return self:onChatToucheEnded(ccp(x, y))
		end
    end
	
	function theClass:showChatBoard() 
		if not self.chat_layer then
			self.chat_layer = createGChat()
			self.chat_layer:registerScriptTouchHandler(__bind(self.onChatTouch, self))
        	self.chat_layer:setTouchEnabled(true)
			self.rootNode:addChild(self.chat_layer, self.CHAT_LAYER_ORDER)
		end
		self.chat_layer:setVisible(true)
	end
	
	function theClass:onChatToucheBegan(loc) 
		return true
	end
	
	function theClass:onChatToucheMoved(loc) 
		if not (self.chat_layer and self.chat_layer:isVisible()) then
			return
		end
		local childrens = self.chat_layer.text_layer:getChildren()
		for index = 1, childrens:count() do
			local label = childrens:objectAtIndex(index-1)
			label = tolua.cast(label, "CCLabelTTF")
			if label:boundingBox():containsPoint(loc) then
				if label:getTag() ~= 1 then
					label:setTag(1)
					label:setColor(ccc3(0,255,255))
				end
			 elseif  label:getTag() == 1 then
				label:setTag(0)
				label:setColor(ccc3(255,255,255))
			end
		end
	end
	
	--点击用户资料对话框
	function theClass:onChatToucheEnded(loc) 
		if not self.chat_layer or not self.chat_layer:isVisible() then
			return
		end
		local childrens = self.chat_layer.text_layer:getChildren()
		local need_break = false
		for index = 1, childrens:count() do
			local label = childrens:objectAtIndex(index-1)
			label = tolua.cast(label, "CCLabelTTF")
			if label:getTag() == 1 then
				label:setTag(0)
				label:setColor(ccc3(255,255,255))
			end
			if label:boundingBox():containsPoint(loc) then
				self:doSendChatMessage(self.CHAT_MSGS[index])
				self.chat_layer:setVisible(false)
				need_break = true
			end
		end
		if need_break then
			return
		end
		if self.chat_layer.text_container:boundingBox():containsPoint(loc) then
			return
		end
		self.chat_layer:setVisible(false)
	end
	
	function theClass:displayChatMessage(message, layer, uid) 
		local bg = layer:getChildByTag(1002)
		local text = layer:getChildByTag(3)
		text = tolua.cast(text, "CCLabelTTF")
		text:setString(message)
		if not layer:isVisible() then
			layer:setVisible(true)
		end
		local delayTime = CCDelayTime:create(5)
		local callFunc = CCCallFunc:create(function() layer:setVisible(false) end)
		local seq = CCSequence:createWithTwoActions(delayTime, callFunc)
		seq:setTag(uid * 43)
		self.rootNode:stopActionByTag(uid * 43)
		self.rootNode:runAction(seq)	
	end
end