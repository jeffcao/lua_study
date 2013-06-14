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
	
	function theClass:create_progress_animation(layer, sprite)
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		if frameCache == nil then
			print("frame cache is null")
		end
		
		local animationCache = CCAnimationCache:sharedAnimationCache()
		--frameCache:addSpriteFramesWithFile("ccbResources/landing.plist")
		local frames = CCArray:create()
		for i=1, 10 do
			local image_file = string.format("load%02d.png", i)
			print(image_file)
			local frame = frameCache:spriteFrameByName(image_file)
			if frame == nil then
				print("frame should not be nil")
			end
			frames:addObject(frame)		
		end
		
		local anim = CCAnimation:createWithSpriteFrames(frames, 0.05);
		animationCache:addAnimation(anim, "progress")
		
		local animate = CCAnimate:create(anim)
		sprite:runAction( CCRepeatForever:create(animate) )
		
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
		local msg_layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
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
		
		msg_layer:addChild(msg_sprite, 0, 1000)
		msg_sprite:setAnchorPoint(ccp(0.5, 0.5))
		msg_sprite:setPosition(ccp(win_size.width/2, win_size.height/2))
		
		self.rootNode:addChild(msg_layer, 0, 901)
		scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
		Timer.add_timer(3, function()
			local msg_layer = self.rootNode:getChildByTag(901)
			self.rootNode:removeChild(msg_layer, true)
			msg_layer = nil
		end)
		
		
	end
	
	function theClass:show_progress_message_box(message)
	
		local function on_msg_layer_touched(eventType, x, y)
			print("[UIControllerPlugin:msg_layer_on_touch]")
			return true
		end
		
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.dialog_plist)
		
		win_size = self.rootNode:getContentSize()
		local msg_layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
		msg_layer:setOpacity(100)
		msg_layer:setTouchEnabled(true)
--		msg_layer:setKeypadEnabled(false)

		msg_layer:registerScriptTouchHandler(on_msg_layer_touched, false, -1024, true)
		
		local msg_sprite = CCScale9Sprite:createWithSpriteFrameName("cue_a.png")
		msg_sprite:setPreferredSize(CCSizeMake(380, 80))
		local msg_lb = CCLabelTTF:create(message, "default",16)
		
		msg_lb:setColor(ccc3(255, 255, 255))
		msg_layer:addChild(msg_lb, 999)
		msg_lb:setAnchorPoint(ccp(0.5, 0.5))
		msg_lb:setPosition(ccp(win_size.width/2, win_size.height/2))
		
		local progress_sprite = CCSprite:create()
--		progress_sprite:setScale(0.75)
		msg_layer:addChild(progress_sprite, 999, 1)
		progress_sprite:setAnchorPoint(ccp(0.5, 0.5))
		progress_sprite:setPosition(ccp(win_size.width/2-120, win_size.height/2))
		
		msg_layer:addChild(msg_sprite, 0, 1000)
		msg_sprite:setAnchorPoint(ccp(0.5, 0.5))
		msg_sprite:setPosition(ccp(win_size.width/2, win_size.height/2))
		
		self.rootNode:addChild(msg_layer, 0, 902)
		scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
		self:create_progress_animation(msg_layer, progress_sprite)		
		
	end
	
	function theClass:hide_progress_message_box()
		local msg_layer = self.rootNode:getChildByTag(902)
		self.rootNode:removeChild(msg_layer, true)
		msg_layer = nil
	end

end
