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
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

UpdatePasswordLayerUPlugin.bind(UpdatePasswordLayer)