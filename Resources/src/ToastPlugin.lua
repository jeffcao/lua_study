require 'src.DialogPlugin'
ToastPlugin = {}

----------------------------------------------------------this functions is private use
  --------------------------------------------------------initDialog
	function initDialog(msg_layer, type)
		DialogPlugin.bind(msg_layer)
		msg_layer:init_dialog()
		msg_layer:attach_to_scene()
		msg_layer:set_dismiss_cleanup(false)
		msg_layer:show()
		if type == 'progress' then
			runningscene().toastplugin_progress = msg_layer
		else
			runningscene().toastplugin_notify = msg_layer
		end
	end
  --------------------------------------------------------createProgressSprite
	function createProgressSprite(msg_height)
		local progress_sprite = CCSprite:create()
		progress_sprite:setAnchorPoint(ccp(0, 0.5))
		progress_sprite:setPosition(ccp(20, msg_height/2))
		progress_sprite:setTag(1000)
		return progress_sprite
	end

  --------------------------------------------------------create_message_layer
  	function set_lbl_color(lbl, type)
  		local lb_color = ccc3(255,255,255)
		if type == 'progress' then lb_color = ccc3(255,255,255)
		elseif type == 'warning' then lb_color = ccc3(255,206,36) end
		lbl:setColor(lb_color)
  	end
  	
	function setBgSpriteRect(msg_sprite, msg_width, msg_height)
		msg_sprite:setPreferredSize(CCSizeMake(msg_width, msg_height))
		msg_sprite:setPosition(ccp(0, msg_height / 2.0 ))
	end
	
	function createBgSprite(type, msg_width, msg_height)
		--进度框使用不一样的背景
		local sprite_frame_name = 'yxz2-tishimuban.png'
		if type == 'progress' then sprite_frame_name = 'yxz2-tishimuban.png' end
		local msg_sprite = nil
		if type == 'progress' then
			msg_sprite = CCScale9Sprite:createWithSpriteFrameName(sprite_frame_name)
		else
			local tmpSprite = CCSprite:createWithSpriteFrameName(sprite_frame_name)
			local size = tmpSprite:getContentSize()
			local fullRect = CCRectMake(0, 0, size.width, size.height)
			local insetRect = CCRectMake(20, 20, size.width-40, size.height-40)
			msg_sprite = CCScale9Sprite:createWithSpriteFrameName(sprite_frame_name, insetRect)
		end
	
		msg_sprite:setAnchorPoint(ccp(0, 0.5))
		setBgSpriteRect(msg_sprite, msg_width, msg_height)
		return msg_sprite
	end
	
	function setLabelRect(lbl, msg_width, msg_height)
		lbl:setPosition(ccp(msg_width/2, msg_height/2))
	end
	
	function createLabel(message, type, msg_width, msg_height)
		--进度框，成功框，警告框使用不一样的字体颜色
		local msg_lb = CCLabelTTF:create(message, "default", 20)
		set_lbl_color(msg_lb, type)
		msg_lb:setAnchorPoint(ccp(0.5, 0.5))
		setLabelRect(msg_lb, msg_width, msg_height)
		return msg_lb
	end
	
	function addRes()
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.dialog_plist)
		cache:addSpriteFramesWithFile(Res.common3_plist)
	end
	
	function setContentRect(content_layer, msg_width, msg_height)
		content_layer:setContentSize(CCSizeMake(msg_width, msg_height))
	end
	
	function createContentLayer(message, type, msg_width, msg_height)
		local win_size = runningscene():getContentSize()
		local content_layer = CCLayer:create()
		content_layer:ignoreAnchorPointForPosition(false)
		content_layer:setAnchorPoint(ccp(0.5, 0.5))
		content_layer:setPosition(ccp(win_size.width/2, win_size.height/2))
		setContentRect(content_layer, msg_width, msg_height)
		
		local msg_sprite = createBgSprite(type, msg_width, msg_height)
		local msg_lb = createLabel(message, type, msg_width, msg_height)
		content_layer:addChild(msg_sprite)
		content_layer:addChild(msg_lb)
		
		content_layer.msg_sprite = msg_sprite
		content_layer.msg_lb = msg_lb
		return content_layer
	end
	
	function create_message_layer(message, params)
		params = params or {}
		local msg_width = params.msg_width
		local msg_height = params.msg_height
		local type = params.type
		local running_scene = runningscene()
		
		cclog("msg_width: " .. msg_width .. ", msg_height: " .. msg_height)
		addRes()

		local msg_layer = CCLayerColor:create(ccc4(1, 11, 84, 75))
		msg_layer:setOpacity(100)

		local content_layer = createContentLayer(message, type, msg_width, msg_height)
		msg_layer:addChild(content_layer)
		msg_layer.msg_lb = content_layer.msg_lb
		msg_layer.content_layer = content_layer
		return msg_layer
	end
	
  --------------------------------------------------------create_progress_animation
	--没有进度动画，生成进度动画，添加进cache并返回进度动画
	function addProgressAnimationToCache()
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		local frames = CCArray:create()
		for i=1, 10 do
			print(string.format("add frame load%02d.png", i))
			local frame = frameCache:spriteFrameByName(string.format("load%02d.png", i))
			frames:addObject(frame)		
		end
		local anim = CCAnimation:createWithSpriteFrames(frames, 0.05);
		CCAnimationCache:sharedAnimationCache():addAnimation(anim, "progress")
		return anim
	end
	
	--在sprite上面跑进度动画
	function create_progress_animation(sprite)
		local anim = CCAnimationCache:sharedAnimationCache():animationByName("progress")
		if not anim then anim = addProgressAnimationToCache() end
		local animate = CCAnimate:create(anim)
		sprite:runAction( CCRepeatForever:create(animate) )
	end

  --------------------------------------------------------check_is_toast_exist	
	function reset_content_size(content_layer, msg_width, msg_height)
		if content_layer:getContentSize().width == msg_width then return end
		setContentRect(content_layer, msg_width, msg_height)
		setLabelRect(content_layer.msg_lb, msg_width, msg_height)
		setBgSpriteRect(content_layer.msg_sprite, msg_width, msg_height)
	end
  
	function check_is_toast_exist(type, message, msg_width, msg_height)
		--检查提示框是否已存在，若已存在只是改变其文字，然后调用show方法
		local running_scene = runningscene()
		local dialog = running_scene.toastplugin_progress
		if type ~= 'progress' then
			dialog = running_scene.toastplugin_notify
		end
		if dialog then
			dialog.msg_lb:setString(message)
			set_lbl_color(dialog.msg_lb, type)
			reset_content_size(dialog.content_layer, msg_width, msg_height)
			dialog:reset_auto_dimiss()
			dialog:show()
			return true
		else
			return false
		end
	end
	
	function show_notify(message, params)
		local width = 200 + 5*string.len(message)
		params = params or {}
		local w = params.msg_width or width
		local h = params.msg_height or 70
		local type = params.type or 'warning'
		local dismiss_time = params.dismiss_time or 1
		if check_is_toast_exist(type, message, w, h) then return end
		
		local msg_layer = create_message_layer(message, {type=type,msg_width=w, msg_height=h})
		if params.touch_dismiss then
			msg_layer.content_layer:setTag(11)
			msg_layer.content_layer.on_touch_fn = function (e, x, y) if e == "ended" then msg_layer:dismiss() end end
			
		--	msg_layer.msg_lb:setTag(11)
		--	msg_layer.msg_lb.on_touch_fn = function (e, x, y) if e == "ended" then msg_layer:dismiss() end end
		end
		scaleNode(msg_layer, GlobalSetting.content_scale_factor)
		
		initDialog(msg_layer, type)
		msg_layer:setBackDismiss(false)
		msg_layer:setClickOutDismiss(false)
		msg_layer:set_auto_dismiss(dismiss_time)
	end

----------------------------------------------------------public use function
	--进度框
	function ToastPlugin.show_progress_message_box(message, msg_width, msg_height)
		print("show_progress_message_box, class name=> "..runningscene().__cname)
		msg_width = msg_width or 350
		msg_height = msg_height or 73
		if check_is_toast_exist("progress", message, msg_width, msg_height) then return end
		
		--step 1.生成提示框的布局
		local progress_sprite = createProgressSprite(msg_height)
		local msg_layer = create_message_layer(message, {type='progress',msg_width=msg_width, msg_height=msg_height})
		msg_layer.content_layer:addChild(progress_sprite)
		msg_layer.msg_lb:setPosition(ccp(msg_width/2 + 20, msg_height/2))
		print("show_progress_message_box, msg_layer=> ", msg_layer)
		scaleNode(msg_layer, GlobalSetting.content_scale_factor)
	
		--step 2.进度框要加一个进度动画
		-- create_progress_animation(progress_sprite)
		
		--step 3.设置对话框的相关选项
		initDialog(msg_layer, 'progress')
		msg_layer:setBackDismiss(false)
		msg_layer:setClickOutDismiss(false)
	end
	
	--dismiss掉进度框
	function ToastPlugin.hide_progress_message_box()
		local dialog = runningscene().toastplugin_progress
		if dialog then dialog:dismiss() end
	end
	
	--服务器消息提示框
	function ToastPlugin.show_server_notify(message, type)
		type = type or 'ok'
		local params = {type=type, touch_dismiss=true, dismiss_time=5}
		show_notify(message, params)
	end
	
	--本地错误提示框
	function ToastPlugin.show_message_box(message, params)
		show_notify(message, params)
	end
	
	--本地成功提示框
	function ToastPlugin.show_message_box_suc(message, params)
		params = params or {}
		params.type = 'ok'
		show_notify(message, params)
	end
	

