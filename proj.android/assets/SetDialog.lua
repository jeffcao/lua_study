require "src.DialogInterface"
require "CCBReaderLoad"
require "src.SoundEffect"
SetDialog = class("SetDialog", function()
	print("create SetDialog")
	return display.newLayer("SetDialog")
end
)

function createSetDialog()
	print("new SetDialog")
	return SetDialog.new()
end

function SetDialog:updateVolume()
	local audio = SimpleAudioEngine:sharedEngine()
	local music_volume = audio:getBackgroundMusicVolume()
	local effect_volume = audio:getEffectsVolume()
	print("music_volume", music_volume)
	print("effect_volume", effect_volume)
	self.music_slider:setValue(music_volume)
	self.effect_silder:setValue(effect_volume)
end

function SetDialog:ctor()

	ccb.set_scene = self
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("Set.ccbi", ccbproxy, false, "")
	self:addChild(node)

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	--self.music_slider_layer = self.ccbproxy:getNodeWithType("music_slider_layer", "CCLayer")
	--self.effect_slider_layer = self.ccbproxy:getNodeWithType("effect_slider_layer", "CCLayer")
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.dialog_plist);
	local audio = SimpleAudioEngine:sharedEngine()
	
	local user_default = CCUserDefault:sharedUserDefault()
	
	local function valueChanged(strEventName,pSender)
        if nil == pSender then
        	return
        end       	
        local pControl = tolua.cast(pSender,"CCControlSlider")
        local strFmt = nil
        if pControl:getTag() == 1001 then
        	if self:isShowing() then
	        	user_default:setFloatForKey("bg_music_volume", pControl:getValue())
	        	audio:setBackgroundMusicVolume(pControl:getValue())
	        	strFmt = string.format("Upper slider value = %.02f",pControl:getValue())
	        else
	        --	pControl:setValue(user_default:getFloatForKey("bg_music_volume"))
        	end
        elseif pControl:getTag() == 1002 then
        	if self:isShowing() then
	        	user_default:setFloatForKey("effect_volume", pControl:getValue())
	        	audio:setEffectsVolume(pControl:getValue())
	        	strFmt = string.format("Lower slider value = %.02f",pControl:getValue())
        	else
	        --	pControl:setValue(user_default:getFloatForKey("effect_volume"))
        	end
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
    pSlider:setMaximumValue(1) 
	pSlider:setTag(1001)
	pSlider:setValue(user_default:getFloatForKey("bg_music_volume"))
	pSlider:setPosition(ccp(0,self.music_slider_layer:getContentSize().height/2))
	self.music_slider_layer:addChild(pSlider)
	pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	self.music_slider = pSlider
	
	local track_scale9_e = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    --local track_scale9_2 = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    local track_scale9_2_e = CCSprite:create()
    local thumb_scale9_e = CCSprite:createWithSpriteFrameName("keystoke_a.png")
    local pSlider_e = CCControlSlider:create(track_scale9_e,track_scale9_2_e ,thumb_scale9_e)
    pSlider_e:setAnchorPoint(ccp(0, 0.5))
    pSlider_e:setMinimumValue(0) 
    pSlider_e:setMaximumValue(1) 
	pSlider_e:setTag(1002)
	pSlider_e:setPosition(ccp(0,self.effect_slider_layer:getContentSize().height/2))
	self.effect_silder = pSlider_e
	pSlider_e:setValue(user_default:getFloatForKey("effect_volume"))
	self.effect_slider_layer:addChild(pSlider_e)
	pSlider_e:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	scaleNode(pSlider_e, GlobalSetting.content_scale_factor * 0.90)
	scaleNode(pSlider, GlobalSetting.content_scale_factor * 0.90)
	self:setVisible(false)

    local toggle = CheckBox.create()
    toggle:setPosition(ccp(0,15))
    toggle.toggle:setChecked(SoundSettings.bg_music)
	self.toggle_layer:addChild(toggle)
	local function menuCallback(tag, sender)
		SoundSettings.bg_music = toggle.toggle:isChecked()
		if toggle.toggle:isChecked() then
			self:playBackgroundMusic()
		else
			self:stopBackgroundMusic()
		end
    end
  	toggle.toggle:registerScriptTapHandler(menuCallback)
	
	local menus = CCArray:create()
	menus:addObject(pSlider)
	menus:addObject(pSlider_e)
	menus:addObject(toggle)
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	self:setOnKeypad(function(key)
		if key == "menuClicked" then
			print("set dialog on key pad")
			return true
		end
		if key == "backClicked" then
			print("set dialog on key pad")
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	
	
end

DialogInterface.bind(SetDialog)
SoundEffect.bind(SetDialog)