require "src.YesNoDialogUPlugin"
require "src.DialogPlugin"
require 'CCBReaderLoad'

YesNoDialog3 = class("YesNoDialog", function()
	print("new YesNoDialog")
	return display.newLayer("YesNoDialog")
end
)

function createYesNoDialog3(container)
	print("create YesNoDialog")
	local dialog = YesNoDialog3.new()
	dialog:attach_to(container)
--	container:addChild(dialog)
	return dialog
end

function YesNoDialog3:ctor()
	local ccbproxy = CCBProxy:create()

 	ccb.YesNoDialog = self

 	CCBReaderLoad("YesNoLayer.ccbi", ccbproxy, true, "YesNoDialog")
	self:addChild(self.rootNode)
	
	self:create_scroll_view(self.scroll_layer, self.msg)
	
	set_blue_stroke(self.confirm_btn_lbl)
	set_blue_stroke(self.reject_btn_lbl)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:setVisible(false)

	self:setNoButton(function()
		self:dismiss(true)
	end)
	
	self:init_dialog()
end


function YesNoDialog3:create_scroll_view(p_layer, msg_lb)
	self.rootNode:removeChild(msg_lb, true)
	msg_lb:setDimensions(CCSizeMake(350, 300))
	self.scroll_view = CCScrollView:create()
	self.scroll_view:setViewSize(CCSizeMake(350,200))
	self.scroll_view:setContainer(msg_lb)
	self.scroll_view:setContentOffset(ccp(0,-100))

	self.scroll_view:setDirection(kCCScrollViewDirectionVertical)
	self.scroll_view:setBounceable(true)
	
	p_layer:addChild(self.scroll_view, 998, -1)
	self.scroll_view:ignoreAnchorPointForPosition(false)
	self.scroll_view:setAnchorPoint(ccp(0,0))
	self.scroll_view:setPosition(ccp(0,0))

	p_layer.on_touch_fn = function(e,x,y)
		if e~='moved' then self.scroll_view.last_y = nil return end
		local newPoint = self.scroll_view:convertToNodeSpace(ccp(x,y))
		x = newPoint.x
		y = newPoint.y
		if not self.scroll_view.last_y then 
			self.scroll_view.last_y = y 
			return 
		end
		
		local delta = y - self.scroll_view.last_y
		if math.abs(delta) < 0.209166 then print('delta is little, discard') return end
		local offset = self.scroll_view:getContentOffset()
		local adjust_y = delta + offset.y
		if adjust_y > 0 then adjust_y = 0 end
		if adjust_y < -100 then adjust_y = -100 end
		self.scroll_view:setContentOffset(ccp(0,adjust_y))
	end
end
YesNoDialogUPlugin.bind(YesNoDialog3)
DialogPlugin.bind(YesNoDialog3)