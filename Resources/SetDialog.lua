require "src.DialogInterface"
SetDialog = class("SetDialog", function()
	print("create SetDialog")
	return display.newLayer("SetDialog")
end
)

function createSetDialog()
	print("new SetDialog")
	return SetDialog.new()
end

function SetDialog:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("Set.ccbi")
	assert(node, "failed to load hall scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:addChild(self.rootNode)
	self.music_slider_layer = self.ccbproxy:getNodeWithType("music_slider_layer", "CCLayer")
	self.effect_slider_layer = self.ccbproxy:getNodeWithType("effect_slider_layer", "CCLayer")
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.dialog_plist);
	local function valueChanged(strEventName,pSender)
        if nil == pSender then
        	return
        end       	
        local pControl = tolua.cast(pSender,"CCControlSlider")
        local strFmt = nil
        if pControl:getTag() == 1001 then
        	strFmt = string.format("Upper slider value = %.02f",pControl:getValue())
        elseif pControl:getTag() == 1002 then
        	strFmt = string.format("Lower slider value = %.02f",pControl:getValue())
        end
        	
        if nil ~= strFmt then
        	print(CCString:create(strFmt):getCString())
        end       	
    end
    --Add the slider
    local track_scale9 = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    --local track_scale9_2 = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    local track_scale9_2 = CCSprite:create()
    
    local thumb_scale9 = CCSprite:createWithSpriteFrameName("keystoke_a.png")
    local pSlider = CCControlSlider:create(track_scale9,track_scale9_2 ,thumb_scale9)
    pSlider:setAnchorPoint(ccp(0, 0.5))
    pSlider:setMinimumValue(0) 
    pSlider:setMaximumValue(100) 
	pSlider:setTag(1001)
	pSlider:setPosition(ccp(0,self.music_slider_layer:getContentSize().height/2))
	self.music_slider_layer:addChild(pSlider)
	pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	
	local track_scale9_e = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    --local track_scale9_2 = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    local track_scale9_2_e = CCSprite:create()
    local thumb_scale9_e = CCSprite:createWithSpriteFrameName("keystoke_a.png")
    local pSlider_e = CCControlSlider:create(track_scale9_e,track_scale9_2_e ,thumb_scale9_e)
    pSlider_e:setAnchorPoint(ccp(0, 0.5))
    pSlider_e:setMinimumValue(0) 
    pSlider_e:setMaximumValue(100) 
	pSlider_e:setTag(1002)
	pSlider_e:setPosition(ccp(0,self.effect_slider_layer:getContentSize().height/2))
	self.effect_slider_layer:addChild(pSlider_e)
	pSlider_e:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	scaleNode(pSlider_e, GlobalSetting.content_scale_factor * 0.90)
	scaleNode(pSlider, GlobalSetting.content_scale_factor * 0.90)
	self:setVisible(false)
	
	local menus = CCArray:create()
	menus:addObject(pSlider)
	menus:addObject(pSlider_e)
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	self:setOnKeypad(function(key)
		print("yesno dialog on key pad")
		if key == "backClicked" then
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
end

DialogInterface.bind(SetDialog)