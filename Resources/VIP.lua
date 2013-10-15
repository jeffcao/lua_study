require "FullMubanStyleLayer"
require "src.UIControllerPlugin"
VIP = class("VIP", function()
	print("new VIP")
	return display.newScene("VIP")	
end
)

function createVIP()
	print("create VIP")
	return VIP.new()
end

function VIP:ctor()

	ccb.VIP = self
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("VIP.ccbi", ccbproxy, false, "")
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("vip_vip.png")
	layer:setContent(node)
	
	--[[
	local user_default = CCUserDefault:sharedUserDefault()
	local version = "版本： " .. user_default:getStringForKey("pkg_version_name") 
		.. " build:" .. user_default:getStringForKey("pkg_build")
	self.version_lbl:setString(version)
	layer:setContent(node)

	--test 9sprite
	
	--local scale9 = CCScale9Sprite:create("ccbResources/yinyingkuang.png")
	--scale9:setPosition(ccp(400,240))
	--local size = CCSizeMake(700,340)
	--dump(size, "size is")
	--scale9:setPreferredSize(size)
 	--self:addChild(scale9)
 	]]
 	
 	local function valueChanged(strEventName,pSender)
		local value = pSender:getValue()
    end
    --Add the slider
    local track_scale9 = CCSprite:createWithSpriteFrameName("VIP_hongse.png")
    --local track_scale9_2 = CCSprite:createWithSpriteFrameName("VIP_jingyangkuang.png")
    local track_scale9_2 = CCSprite:createWithSpriteFrameName("VIP_heise.png")
    local thumb = CCSprite:createWithSpriteFrameName("VIP_jiantou.png")
    local pSlider = CCControlSlider:create(track_scale9_2,track_scale9 ,thumb)
    --pSlider:setAnchorPoint(ccp(0, 0.5))
    pSlider:setMinimumValue(0) 
    pSlider:setMaximumValue(100) 
	pSlider:setTag(1001)
	pSlider:setValue(50)
	pSlider:setPosition(ccp(343,10))
	self.progress_bar_layer:addChild(pSlider)
	pSlider:setEnabled(false)
	pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	
 	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

UIControllerPlugin.bind(VIP)
