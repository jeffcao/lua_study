AboutScene = class("AboutScene", function()
	print("new about scene")
	return display.newScene("AboutScene")	
end
)

function createAboutScene()
	print("create about scene")
	return AboutScene.new()
end

function AboutScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("AboutScene.ccbi")
	assert(node, "about scene load fail")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local function onKeypad(key)
		if key == "backClicked" then 
			local scene = HallScene.new()
			CCDirector:sharedDirector():replaceScene(scene)
		end
	end
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(onKeypad)
	
	local scale = GlobalSetting.content_scale_factor
	local green_black_bg = self.ccbproxy:getNodeWithType("green_black_bg", "CCScale9Sprite")
	--green_black_bg:setScaleX(scale)
	--green_black_bg:setScaleY(scale)
	--local rectInsets = CCRectMake(40,60,40,30)
	--green_black_bg:setContentSize(776*scale, 456*scale)
	--green_black_bg:setCapInsets(rectInsets)
	--local rectInsets = CCRectMake(41,0,41,0)
	
	--self.green_black_bg = green_black_bg:resizableSpriteWithCapInsets(rectInsets)
	
	--green_black_bg:setContentSize(CCSizeMake(776*GlobalSetting.content_scale_factor, 456*GlobalSetting.content_scale_factor))
	--green_black_bg:setContentSize(776*GlobalSetting.content_scale_factor, 456*GlobalSetting.content_scale_factor)
	--green_black_bg:setCapInsets(rectInsets)
	--green_black_bg:removeFromParent()
	--self.rootNode:addChild(self.green_black_bg)
	
	--[[
	local scale = GlobalSetting.content_scale_factor
	local rect = CCRectMake(0,0,112,456);   --图片的大小  
    local rectInsets = CCRectMake(40,0,40,0); --left，right，width，height  
    local winRect = CCSizeMake(776*GlobalSetting.content_scale_factor, 456*GlobalSetting.content_scale_factor) --设置要拉伸后的的大小  
    local m_pNextBG   = CCScale9Sprite:create("biankuang_9.9.png",rect,rectInsets)
    m_pNextBG:setPreferredSize(winRect)                 --这个是关键  
    m_pNextBG:setCapInsets(rectInsets)
    
    m_pNextBG:setPosition(400, 240)
    self.rootNode:addChild(m_pNextBG,5)  
    ]]
end

