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
	
	local default_task = {weekday = '星期一', week = 1, name = '长工要债', object = '农民', content = '农民收益增加10%'}
	local task = GlobalSetting.time_task or default_task
	dump(task, 'task in create time task is')
	dump(self.week_day_lbl, 'self.week_day_lbl')
	self.week_day_lbl:setString(task.weekday)
	self.fit_lbl:setString(task.object)
	self.effect_lbl:setString(task.content)
	local xq = task.week
	if xq == 0 then xq = 7 end
	local frame_name = "Iconmeirihuodongzhou" .. tostring(xq) .. ".png"
	local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frame_name)
	self.title_sprite:setDisplayFrame(frame)
end

DialogInterface.bind(TimeTask)