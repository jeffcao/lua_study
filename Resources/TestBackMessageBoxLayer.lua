require "CCBReaderLoad"

require 'src.DialogPlugin'


TestBackMessageBoxLayer = class("TestBackMessageBoxLayer", function()
	print("new TestBackMessageBoxLayer")
	return display.newLayer("TestBackMessageBoxLayer")
end
)

function createTestBackMessageBoxLayer(container)
	print("create TestBackMessageBoxLayer")
	local dialog = TestBackMessageBoxLayer.new()
	--container:addChild(dialog, getMaxZOrder(container) + 1)
	--dialog:init_r()
	dialog:attach_to(container)
	return dialog
end        
function TestBackMessageBoxLayer:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	ccb.back_message_box = self
	self.onCancel = function()
		self:removeFromParentAndCleanup(true)
	end
	self.onConfrim = function()
		self:removeFromParentAndCleanup(true)
	end
 	CCBReaderLoad("BackMessageBoxLayer.ccbi", self.ccbproxy, true, "back_message_box")
	dump(self, "self is")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	set_blue_stroke(self.reject_btn_lbl)
	set_blue_stroke(self.confirm_btn_lbl)
	self.msg_text:setString("hhhhhhhhhhhhhhhhhhhflewqr")
	
	self:init_dialog()
	--[[
	self.is_dialog = true
	local function cccn(node, x, y)
		return node:boundingBox():containsPoint(node:getParent():convertToNodeSpace(ccp(x, y)))
	end
	self.sel_childs = getTouchChilds(self)
	dump(self.sel_childs, "self.sel_childs")
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(function(e, x,y)
		print("on touch", self)
		if self:getZOrder() < getMaxZOrder(self:getParent()) then print("is not touch me") return false end
		if self.sel_childs then
			for k,v in pairs(self.sel_childs) do
				if cccn(v,x,y) then return false end
			end
		end
		if self.bg and (not cccn(self.bg, x,y)) then
			self:removeFromParentAndCleanup(true)
		end
		return true 
	end, false, -200, true)
	]]
	
end

function TestBackMessageBoxLayer:init_r()
--[[
	self:setKeypadEnabled(true)
	self:registerScriptKeypadHandler( function(key)
			print("on keypad clicked: ", self:getZOrder())
			if self:getZOrder() < getMaxZOrder(self:getParent()) then print("is not keypad me") return end
			if key == "backClicked" then
				Timer.add_timer(0.1, function() self:removeFromParentAndCleanup(true) end, 'timer_name')
				
			end 
		end )
		]]
		self:show()
end

DialogPlugin.bind(TestBackMessageBoxLayer)