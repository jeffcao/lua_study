require "CCBReaderLoad"
require "src.DialogInterface"

Range = class("Range", function() return display.newLayer("Range") end)

function createRange() return Range.new() end

function Range:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.Range = self
	local node = CCBReaderLoad("Range.ccbi", self.ccbproxy, true, "Range")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	self:init()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function Range:init()
	local menus = CCArray:create()
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	self:swallowOnKeypad()
end

DialogInterface.bind(Range)