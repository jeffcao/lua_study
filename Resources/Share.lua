require "CCBReaderLoad"
require "src.DialogInterface"

Share = class("Share", function() return display.newLayer("Share") end)

function createShare() return Share.new() end

function Share:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	self.on_tencent_share = function() DDZJniHelper:create():messageJava('share_intent_'..GlobalSetting.tencent_share_url) self:dismiss() end
	self.on_sina_share = function() DDZJniHelper:create():messageJava('share_intent_'..GlobalSetting.sina_share_url) self:dismiss() end
	ccb.Share = self
	local node = CCBReaderLoad("Share.ccbi", self.ccbproxy, true, "Share")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	self:init()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function Share:init()
	local menus = CCArray:create()
	menus:addObject(self.menu_tencent_share)
	menus:addObject(self.menu_sina_share)
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	self:swallowOnKeypad()
end

DialogInterface.bind(Share)