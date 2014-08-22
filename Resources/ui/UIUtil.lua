UIUtil = {}

GL_LINEAR = 0x2601
GL_REPEAT = 0x2901

function UIUtil.getRepeatSprite(width, height, file)
	file = file or "ccbResources/beijingpintu.png"
	local rect = CCRectMake(0,0,width,height)
	local sprite = CCSprite:create(file)
	sprite:setTextureRect(rect)
	local params = ccTexParams:new()
	params.minFilter = GL_LINEAR
	params.magFilter = GL_LINEAR
	params.wrapS = GL_REPEAT
	params.wrapT = GL_REPEAT
	sprite:getTexture():setTexParameters(params)
	return sprite
end