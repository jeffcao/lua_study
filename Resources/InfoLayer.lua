require "src.InfoLayerUPlugin"

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
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("Info.ccbi")
	self.rootNode = node
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end