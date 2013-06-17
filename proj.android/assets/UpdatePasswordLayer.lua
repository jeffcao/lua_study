require "src.UpdatePasswordLayerUPlugin"

UpdatePasswordLayer = class("UpdatePasswordLayer", function()
	print("create UpdatePasswordLayer")
	return display.newLayer("UpdatePasswordLayer")
end
)

function createUpdatePasswordLayer()
	print("create UpdatePasswordLayer")
	return UpdatePasswordLayer.new()
end

function UpdatePasswordLayer:ctor()

	ccb.update_pwd_scene = self
	
	self.on_ui_ok_btn_clicked = __bind(self.do_ui_ok_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("UpdatePassword.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local createEditbox = function()
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.common_plist)
		
		local scale9_2 = CCScale9Sprite:createWithSpriteFrameName("kuang_a.png")
		local editbox2 = CCEditBox:create(CCSizeMake(320,35), scale9_2)
		editbox2:setPosition(ccp(100,30))
		editbox2:setAnchorPoint(ccp(0,0.5))
		editbox2:setPlaceholderFont("default",16)
		editbox2:setFont("default",16)
		editbox2:setPlaceHolder("那一刻的风情")
		editbox2:setInputFlag(kEditBoxInputFlagPassword)
		return editbox2
	end
	
	local add_editbox = function(layer)
		layer.editbox = createEditbox()
		layer:addChild(layer.editbox)
	end

	add_editbox(self.old_layer)
	self.old_layer.editbox:setPlaceHolder("输入原密码")
	
	add_editbox(self.new_layer)
	self.new_layer.editbox:setPlaceHolder("设置密码")
	
	add_editbox(self.confirm_layer)
	self.confirm_layer.editbox:setPlaceHolder("重复输入")
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function UpdatePasswordLayer:do_ui_ok_btn_clicked(tag, sender)

end

UpdatePasswordLayerUPlugin.bind(UpdatePasswordLayer)