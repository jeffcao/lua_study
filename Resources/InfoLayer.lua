require "src.InfoLayerUPlugin"
require "src.CheckBox"

InfoLayer = class("InfoLayer", function()
	print("new InfoLayer")
	return display.newLayer("InfoLayer")
end
)

function createInfoLayer()
	print("create InfoLayer")
	return InfoLayer.new()
end

function InfoLayer:ctor()

	ccb.info_scene = self
	
	self.on_ui_ok_btn_clicked = __bind(self.do_ui_ok_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("Info.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.common_plist)
	
	local scale9_2 = CCScale9Sprite:createWithSpriteFrameName("kuang_a.png")
	local editbox2 = CCEditBox:create(CCSizeMake(320,40), scale9_2)
	editbox2:setPosition(ccp(72,25))
	editbox2:setAnchorPoint(ccp(0,0.5))
	editbox2:setPlaceholderFont("default",16)
	editbox2:setFont("default",16)
	editbox2:setPlaceHolder("那一刻的风情")
	
	self.nickname_layer:addChild(editbox2)

	local menu1 = CheckBox.create("男")
	local menu2 = CheckBox.create("女")
	menu1:setPosition(ccp(72,25))
	menu2:setPosition(ccp(200,25))
	
	local function menuCallback(tag, sender)
        if sender == menu1.toggle then
        	menu2.toggle:setChecked(not menu2.toggle:isChecked())
        else
        	menu1.toggle:setChecked(not menu1.toggle:isChecked())
        end
    end
    menu1.toggle:registerScriptTapHandler(menuCallback)
    menu2.toggle:registerScriptTapHandler(menuCallback)
	menu1.toggle:setChecked(true)
    
	self.gender_layer:addChild(menu1)
	self.gender_layer:addChild(menu2)
	
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end