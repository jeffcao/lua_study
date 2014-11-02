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
	
	--[[
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
    ]]
	
	function theClass:showChatBoard() 
		print("showChatBoard, voice_props.num= ", #self.voice_props)
		if not self.voice_props and (#self.voice_props > 0)then
			return
		end
		--[[
		if not self.chat_layer or (not self.chat_layer:getParent()) then
			self.chat_layer = createGChat()
			self.chat_layer:init(self.voice_props, __bind(self.doSendChatMessage, self))
			--self.chat_layer:registerScriptTouchHandler(__bind(self.onChatTouch, self))
        	--self.chat_layer:setTouchEnabled(true)
			self.rootNode:addChild(self.chat_layer, self.CHAT_LAYER_ORDER)
		end
		self.chat_layer:setVisible(true)
		]]
		local chat_layer = createGChat()
		chat_layer:init(self.voice_props, __bind(self.doSendChatMessage, self))
		self.rootNode:addChild(chat_layer, self.CHAT_LAYER_ORDER)
		chat_layer:setVisible(true)
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