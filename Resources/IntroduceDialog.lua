require "src.DialogInterface"
require "CCBReaderLoad"
require "src.SoundEffect"

IntroduceDialog = class("IntroduceDialog", function()
	print("create IntroduceDialog")
	return display.newLayer("IntroduceDialog")
end
)

function showIntroduce(moment, msg, layer)
	-- do nothing, do not show introduce
--[[
	local dialog = createIntroduceDialog()
	dialog:setMessage(msg)
	layer:addChild(dialog, 6000, 1002)
	dialog:show()
	dialog:playIntroduce(moment)
	return dialog
]]
end

function createIntroduceDialog()
	print("new IntroduceDialog")
	return IntroduceDialog.new()
end

function IntroduceDialog:ctor()

	ccb.Introduce = self
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("Introduce.ccbi", ccbproxy, false, "")
	self:addChild(node)
	self.rootNode = node

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local menus = CCArray:create()
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	self:setOnKeypad(function(key)
		if key == "back" then
			print("introduce dialog on key pad")
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	
	self.rootNode:registerScriptTouchHandler(__bind(self.onTouchI, self))
    self.rootNode:setTouchEnabled(true)
    self:setVisible(false)
end

function IntroduceDialog:setMessage(msg)
	self.content_lbl:setString(msg)
end

function IntroduceDialog:onTouchI(eventType, x, y)
	cclog("touch event IntroduceDialog:%s,x:%d,y:%d", eventType, x, y)
	if eventType == "began" then
		return true
	elseif eventType == "ended" then
		self:dismiss()
	end
end

DialogInterface.bind(IntroduceDialog)
SoundEffect.bind(IntroduceDialog)