function create_scale_frame(frame)
	local sprite = CCSprite:createWithSpriteFrameName(frame)
	sprite:setScale(GlobalSetting.content_scale_factor)
	--node:addChild(sprite)
	print('create_scale_frame:'..frame)
	local cs = sprite:getTexture():getContentSize()
	local anchor = sprite:getAnchorPoint()
	local rt = CCRenderTexture:create(cs.width, cs.height)
	local bottomLeft = ccp(cs.width*anchor.x, cs.height*anchor.y)
    rt:begin()
    sprite:setPosition(ccp(bottomLeft.x, bottomLeft.y))
    sprite:visit()
    rt:endToLua()
    
    sprite:removeFromParentAndCleanup(true)
	local sprite_frame = rt:getSprite():displayFrame()
	return sprite_frame
end

function get_scale_frame(frame)
	local scale_name = frame..'__scale'
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local sprite_frame = cache:spriteFrameByName(scale_name)
	if not sprite_frame then
		sprite_frame = create_scale_frame(frame)
		cache:addSpriteFrame(sprite_frame, scale_name)
	end
	return sprite_frame
end

--node:the node to add the scale9sprite, position:the position to add
--pref_size:the scale9 size, frame:the name of the png
function add_scale9sprite(node, pref_size, position, frame)
	frame = frame or "tanchukuang.png"
	local sprite_frame = get_scale_frame(frame)
	local scale9 = CCScale9Sprite:createWithSpriteFrame(sprite_frame)
	scale9:setPreferredSize(pref_size)
	scale9:setPosition(position)
	node:addChild(scale9)
	return scale9
end

function dialog_bg_scale9(dialog)
	local p_size = tolua.cast(dialog.bg,"CCScale9Sprite"):getPreferredSize()
	local c_size = dialog.bg:getContentSize()
	local s_size = CCSizeMake(p_size.width + c_size.width, p_size.height + c_size.height)
	local scale9 = add_scale9sprite(dialog.bg:getParent(), s_size, ccp(dialog.bg:getPosition()))
	dialog.bg:removeFromParentAndCleanup(true)
	dialog.bg=scale9
end

function check_dialog_scale9_bg(dialog)
	if dialog.bg and tolua.cast(dialog.bg, 'CCScale9Sprite').getPreferredSize then
	--	dialog_bg_scale9(dialog)
	end
end