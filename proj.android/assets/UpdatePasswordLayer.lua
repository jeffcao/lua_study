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
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:create()
	
	local node = self.ccbproxy:readCCBFromFile("UpdatePassword.ccbi")
	self.rootNode = node
	self:addChild(self.rootNode)
	
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
	
	local old_layer = self.ccbproxy:getNodeWithType("old_layer", "CCLayer")
	add_editbox(old_layer)
	old_layer.editbox:setPlaceHolder("输入原密码")
	
	local new_layer = self.ccbproxy:getNodeWithType("new_layer", "CCLayer")
	add_editbox(new_layer)
	new_layer.editbox:setPlaceHolder("设置密码")
	
	local confirm_layer = self.ccbproxy:getNodeWithType("confirm_layer", "CCLayer")
	add_editbox(confirm_layer)
	confirm_layer.editbox:setPlaceHolder("重复输入")
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

UpdatePasswordLayerUPlugin.bind(UpdatePasswordLayer)