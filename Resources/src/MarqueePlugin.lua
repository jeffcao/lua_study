require 'src.List'
MarqueePlugin = {once = List.new(), loop_text = ""}

function MarqueePlugin.get_text()
	if List.empty(MarqueePlugin.once) then return MarqueePlugin.loop_text end
	local text = List.popleft(MarqueePlugin.once)
	return text
end

function MarqueePlugin.marquee(msg, loop)
	msg = msg or ""--ensure msg not be nil
	if loop then MarqueePlugin.loop_text = msg
	else List.pushright(MarqueePlugin.once, msg) end
end

function MarqueePlugin.addMarquee(node, position)
	if node.marqueeplugin_marquee then return end
	local my_layer = CCLayer:create()
	my_layer:setAnchorPoint(ccp(0.5,0.5))
	my_layer:setContentSize(node:getContentSize())
	my_layer:setPosition(node:getContentSize().width/2, node:getContentSize().height/2)
	my_layer:ignoreAnchorPointForPosition(false)
	local sprite = CCSprite:create("ccbResources/heitiao.png")
	sprite:setAnchorPoint(ccp(0.5,0.5))
	sprite:setTag(9001)
	--sprite:setPosition(ccp(400,100))
	sprite:setScale(GlobalSetting.content_scale_factor)
	sprite:setVisible(false)
	
	node:addChild(sprite, 1)
	node:addChild(my_layer, 2)
	
	local marquee = Marquee:create()
	marquee:enableStroke()
	marquee:setSize(460, 32)
	marquee:setTextProvider(MarqueePlugin.get_text)
	local x = my_layer:getContentSize().width/2
	local y = 400
	if position then
		x = position.x
		y = position.y
	end
	sprite:setPosition(x,y)
	marquee:init(my_layer, x, y)
	node.marqueeplugin_marquee = marquee
end