require "CCBReaderLoad"
require "src.DialogInterface"

TimeTask = class("TimeTask", function() return display.newLayer("TimeTask") end)

function createTimeTask() return TimeTask.new() end

function TimeTask:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.TimeTask = self
	local node = CCBReaderLoad("TimeTask.ccbi", self.ccbproxy, true, "TimeTask")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	self:init()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function TimeTask:init()
	local menus = CCArray:create()
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	self:swallowOnKeypad()
end

DialogInterface.bind(TimeTask)