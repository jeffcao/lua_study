require 'src.DialogPlugin'
ToastPlugin = {}

function ToastPlugin.bind(theClass)
	function theClass:show_progress_message_box(message, msg_width, msg_height)
		print("show_progress_message_box, class name=> "..self.__cname)
		if self:check_is_toast_exist(message) then return end
		msg_width = msg_width or 350
		msg_height = msg_height or 73
		
		--step 1.生成提示框的布局
		local progress_sprite = self:createProgressSprite(msg_height)
		local msg_layer = self:create_message_layer(message, {type='progress',msg_width=msg_width, msg_height=msg_height})
		msg_layer.content_layer:addChild(progress_sprite)
		msg_layer.msg_lb:setPosition(ccp(msg_width/2 + 20, msg_height/2))
		print("show_progress_message_box, msg_layer=> ", msg_layer)
		scaleNode(msg_layer, GlobalSetting.content_scale_factor)
	
		--step 2.进度框要加一个进度动画
		self:create_progress_animation(progress_sprite)
		
		--step 3.设置对话框的相关选项
		self:initDialog(msg_layer)
	end

----------------------------------------------------------this functions is private use
  --------------------------------------------------------initDialog
	function theClass:initDialog(msg_layer)
		DialogPlugin.bind(msg_layer)
		msg_layer:init_dialog()
		msg_layer:attach_to_scene()
		msg_layer:set_dismiss_cleanup(false)
		msg_layer:show()
		runningscene().toastplugin_progress = msg_layer
	end
  --------------------------------------------------------createProgressSprite
	function theClass:createProgressSprite(msg_height)
		local progress_sprite = CCSprite:create()
		progress_sprite:setAnchorPoint(ccp(0, 0.5))
		progress_sprite:setPosition(ccp(20, msg_height/2))
		progress_sprite:setTag(1000)
		return progress_sprite
	end

  --------------------------------------------------------check_is_toast_exist	
	function theClass:check_is_toast_exist(message)
		--检查提示框是否已存在，若已存在只是改变其文字，然后调用show方法
		local running_scene = runningscene()
		if running_scene.toastplugin_progress then
			running_scene.toastplugin_progress.msg_lb:setString(message)
			running_scene.toastplugin_progress:show()
			return true
		else
			return false
		end
	end

  --------------------------------------------------------create_message_layer
	function theClass:create_message_layer(message, params)
		params = params or {}
		local msg_width = params.msg_width
		local msg_height = params.msg_height
		local type = params.type
		local running_scene = runningscene()
		
		cclog("msg_width: " .. msg_width .. ", msg_height: " .. msg_height)
		self:addRes()

		local msg_layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
		msg_layer:setOpacity(100)

		local content_layer = self:createContentLayer(message, type, msg_width, msg_height)
		msg_layer:addChild(content_layer)
		msg_layer.msg_lb = content_layer.msg_lb
		msg_layer.content_layer = content_layer
		return msg_layer
	end
	
	function theClass:addRes()
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.dialog_plist)
		cache:addSpriteFramesWithFile(Res.common3_plist)
	end
	
	function theClass:createContentLayer(message, type, msg_width, msg_height)
		local win_size = runningscene():getContentSize()
		local content_layer = CCLayer:create()
		content_layer:setContentSize(CCSizeMake(msg_width, msg_height))
		content_layer:ignoreAnchorPointForPosition(false)
		content_layer:setAnchorPoint(ccp(0.5, 0.5))
		content_layer:setPosition(ccp(win_size.width/2, win_size.height/2))
		
		local msg_sprite = self:createBgSprite(type, msg_width, msg_height)
		local msg_lb = self:createLabel(message, type, msg_width, msg_height)
		content_layer:addChild(msg_sprite)
		content_layer:addChild(msg_lb)
		
		content_layer.msg_lb = msg_lb
		return content_layer
	end
	
	function theClass:createBgSprite(type, msg_width, msg_height)
		--进度框使用不一样的背景
		local sprite_frame_name = 'tanchukuang.png'
		if type == 'progress' then sprite_frame_name = 'cue_a.png' end
		local msg_sprite = CCScale9Sprite:createWithSpriteFrameName(sprite_frame_name)
		msg_sprite:setPreferredSize(CCSizeMake(msg_width, msg_height))
		msg_sprite:setAnchorPoint(ccp(0, 0.5))
		msg_sprite:setPosition(ccp(0, msg_height / 2.0 ))
		return msg_sprite
	end
	
	function theClass:createLabel(message, type, msg_width, msg_height)
		--进度框，成功框，警告框使用不一样的字体颜色
		local msg_lb = CCLabelTTF:create(message, "default", 20)
		local lb_color = ccc3(67,31,24)
		if type == 'progress' then lb_color = ccc3(255,255,255)
		elseif type == 'warning' then lb_color = ccc3(255,0,0) end
		msg_lb:setColor(lb_color)
		msg_lb:setAnchorPoint(ccp(0.5, 0.5))
		msg_lb:setPosition(ccp(msg_width/2, msg_height/2))
		return msg_lb
	end
	
  --------------------------------------------------------create_progress_animation
	--在sprite上面跑进度动画
	function theClass:create_progress_animation(sprite)
		local anim = CCAnimationCache:sharedAnimationCache():animationByName("progress")
		if not anim then anim = self:addProgressAnimationToCache() end
		local animate = CCAnimate:create(anim)
		sprite:runAction( CCRepeatForever:create(animate) )
	end
	
	--没有进度动画，生成进度动画，添加进cache并返回进度动画
	function theClass:addProgressAnimationToCache()
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		local frames = CCArray:create()
		for i=1, 10 do
			local frame = frameCache:spriteFrameByName(string.format("load%02d.png", i))
			frames:addObject(frame)		
		end
		local ainim = CCAnimation:createWithSpriteFrames(frames, 0.05);
		CCAnimationCache:sharedAnimationCache():addAnimation(anim, "progress")
		return anim
	end
end