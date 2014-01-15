require "src.DialogInterface"
require "CCBReaderLoad"
require "src.SoundEffect"
local jni = DDZJniHelper:create()
local user_default = CCUserDefault:sharedUserDefault()
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
	local volume = jni:get("MusicVolume")
	self.music_slider:setValue(tonumber(volume))
end

function SetDialog:ctor()

	ccb.set_scene = self
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("Set2.ccbi", ccbproxy, false, "")
	self:addChild(node)
	self.rootNode = node

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.dialog_plist);
	local audio = SimpleAudioEngine:sharedEngine()
	
	local user_default = CCUserDefault:sharedUserDefault()
	
	local function valueChanged(strEventName,pSender)
		if self:isShowing() then
			local value = pSender:getValue()
		--	user_default:setFloatForKey("music_volume", value)
			jni:messageJava("set_music_volume_" .. tonumber(value))
        end
    end
    --Add the slider
    local track_scale9 = CCSprite:createWithSpriteFrameName("keystoke_b.png")
    local track_scale9_2 = CCSprite:create()
    
    local thumb_scale9 = CCSprite:createWithSpriteFrameName("keystoke_a.png")
    local pSlider = CCControlSlider:create(track_scale9,track_scale9_2 ,thumb_scale9)
    pSlider:setAnchorPoint(ccp(0, 0.5))
    pSlider:setMinimumValue(0) 
    pSlider:setMaximumValue(1) 
	pSlider:setTag(1001)
	pSlider:setValue(tonumber(jni:get("MusicVolume")))
	pSlider:setPosition(ccp(0,self.music_slider_layer:getContentSize().height/2))
	self.music_slider_layer:addChild(pSlider)
	pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	self.music_slider = pSlider
	
	scaleNode(pSlider, GlobalSetting.content_scale_factor * 0.90)
	

    local music_toggle = CheckBox.create()
    music_toggle:setPosition(ccp(0,15))
    music_toggle.toggle:setChecked(bg_music)
	self.music_toggle_layer:addChild(music_toggle)
	local function menuCallback(tag, sender)
		bg_music = music_toggle.toggle:isChecked()
		user_default:setBoolForKey("bg_music", not bg_music)
		if bg_music then
		--	jni:messageJava("set_music_volume_" .. user_default:getFloatForKey("music_volume"))
			self:playBackgroundMusic()
		else
			self:stopBackgroundMusic()
		end
    end
  	music_toggle.toggle:registerScriptTapHandler(menuCallback)
  	
  	local effect_toggle = CheckBox.create()
    effect_toggle:setPosition(ccp(0,15))
    effect_toggle.toggle:setChecked(effect_music)
	self.effect_toggle_layer:addChild(effect_toggle)
	local function effect_callback(tag, sender)
		effect_music = effect_toggle.toggle:isChecked()
		user_default:setBoolForKey("effect_music", not effect_music)
    end
  	effect_toggle.toggle:registerScriptTapHandler(effect_callback)
	
	local menus = CCArray:create()
	menus:addObject(pSlider)
	menus:addObject(music_toggle)
	menus:addObject(effect_toggle)
	menus:addObject(self.rootNode)
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
	
	self.rootNode:registerScriptTouchHandler(__bind(self.onTouch, self))
    self.rootNode:setTouchEnabled(true)
    self:setVisible(false)
    local func = function()
    	cclog('set dialog receive on volume change')
    	if self and self:isShowing() then
    		cclog('set dialog respond to on volume change')
    		pSlider:setValue(tonumber(jni:get("MusicVolume")))
    	else
    		cclog('set dialog do not respond to on volume change')
    		NotificationProxy.removeAllObserver("on_volume_change")
    		cclog('set dialog unregist on volume change')
    	end
    end
    NotificationProxy.registerScriptObserver(func,"on_volume_change")
end

function SetDialog:onTouch(eventType, x, y)
	cclog("touch event PlayerInfo:%s,x:%d,y:%d", eventType, x, y)
	if eventType == "began" then
		return self:onTouchBegan(ccp(x, y))
	elseif eventType == "moved" then
		return self:onTouchMoved(ccp(x, y))
	else
		return self:onTouchEnded(ccp(x, y))
	end
end

function SetDialog:onTouchBegan(loc)
	return true
end

function SetDialog:onTouchMoved(loc)
end

function SetDialog:onTouchEnded(loc)
	--loc = self.bg:convertToNodeSpace(loc)
	if not self.container_layer:boundingBox():containsPoint(loc) then
		self:dismiss()
	end
end

DialogInterface.bind(SetDialog)
SoundEffect.bind(SetDialog)