GChat = class("GChat", function() return display.newLayer("GChat") end)

function createGChat() return GChat.new() end

function GChat:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GChat = self
	local node = CCBReaderLoad("Chat.ccbi", self.ccbproxy, true, "GChat")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end