require "src.WebsocketRails.Timer"

UIControllerPlugin = {}

function UIControllerPlugin.bind(theClass)

	function theClass:createEditbox(width, height, is_password)
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.common2_plist)
		
		local scale9_2 = CCScale9Sprite:createWithSpriteFrameName(self.input_png)
		local editbox2 = CCEditBox:create(CCSizeMake(width,height), scale9_2)
		editbox2:setPosition(ccp(0,0))
		editbox2:setAnchorPoint(ccp(0,0))
		editbox2:setPlaceholderFont("default",16)
		editbox2:setFont("default",16)
		editbox2:setFontColor(ccc3(0, 0, 0))
		if is_password then
			editbox2:setInputFlag(kEditBoxInputFlagPassword)
		end
		return editbox2
	end
	
	function theClass:addEditbox(layer, width, height, is_password, tag)
		layer.editbox = self:createEditbox(width, height, is_password)
		layer:addChild(layer.editbox, 0, tag)
	end
	
	function theClass:on_msg_layer_touched(eventType, x, y)
		print("[UIControllerPlugin:msg_layer_on_touch]")
		return true
	end

	function theClass:show_message_box(message)
	
		local function on_msg_layer_touched(eventType, x, y)
			print("[UIControllerPlugin:msg_layer_on_touch]")
			return true
		end
		
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.dialog_plist)
		
		win_size = self.rootNode:getContentSize()
		local msg_layer = CCLayerColor:create(ccc4(255, 255, 255, 255))
		msg_layer:setOpacity(100)
		msg_layer:setTouchEnabled(true)
--		msg_layer:setKeypadEnabled(false)

		msg_layer:registerScriptTouchHandler(on_msg_layer_touched, false, -1024, true)
		
		local msg_sprite = CCScale9Sprite:createWithSpriteFrameName("cue_a.png")
		local msg_lb = CCLabelTTF:create(message, "default",16)
		
		msg_lb:setColor(ccc3(255, 255, 255))
		msg_layer:addChild(msg_lb, 999)
		msg_lb:setAnchorPoint(ccp(0.5, 0.5))
		msg_lb:setPosition(ccp(win_size.width/2, win_size.height/2))
		
		msg_layer:addChild(msg_sprite, 0)
		msg_sprite:setAnchorPoint(ccp(0.5, 0.5))
		msg_sprite:setPosition(ccp(win_size.width/2, win_size.height/2))
		
		self.rootNode:addChild(msg_layer, 0, 901)

		Timer.add_timer(3, function()
			local msg_layer = self.rootNode:getChildByTag(901)
			self.rootNode:removeChild(msg_layer, true)
		end)
		
		
	end

end
