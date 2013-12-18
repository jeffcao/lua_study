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
end