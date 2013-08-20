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
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
    self:init()
end

function TimeTask:init()

	local menus = CCArray:create()
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	
	self:swallowOnKeypad()
	self:setOnKeypad(function(key)
		if key == "backClicked" then
			print("TimeTask dialog on key pad")
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	self.rootNode:registerScriptTouchHandler(__bind(self.onTouch, self))
    self.rootNode:setTouchEnabled(true)
    
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function TimeTask:onTouch(eventType, x, y)
	cclog("touch event TimeTask:%s,x:%d,y:%d", eventType, x, y)
	if eventType == "began" then
		return self:onTouchBegan(ccp(x, y))
	elseif eventType == "moved" then
		return self:onTouchMoved(ccp(x, y))
	else
		return self:onTouchEnded(ccp(x, y))
	end
end

function TimeTask:onTouchBegan(loc)
	return true
end

function TimeTask:onTouchMoved(loc)
end

function TimeTask:onTouchEnded(loc)
	print('self.bg', self.bg)
	if not self.bg:boundingBox():containsPoint(loc) then
		self:dismiss()
	end
end

DialogInterface.bind(TimeTask)