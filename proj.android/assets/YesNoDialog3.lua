require "src.YesNoDialogUPlugin"
require "src.DialogInterface"

YesNoDialog3 = class("YesNoDialog", function()
	print("new YesNoDialog")
	return display.newLayer("YesNoDialog")
end
)

function createYesNoDialog3(yes_no_dialog_dismiss_callback)
	print("create YesNoDialog")
	local dialog = YesNoDialog3.new(yes_no_dialog_dismiss_callback)
--	container:addChild(dialog)
	return dialog
end

function YesNoDialog3:ctor(yes_no_dialog_dismiss_callback)
	local ccbproxy = CCBProxy:create()

 	ccb.YesNoDialog = self

 	local node = CCBReaderLoad("YesNoLayer.ccbi", ccbproxy, true, "YesNoDialog")
	self:addChild(node)
	
	self.msg = tolua.cast(self.msg_text, "CCLabelTTF") 
	self.title = tolua.cast(self.title_text, "CCLabelTTF")
	self.confirm = tolua.cast(self.confirm_btn, "CCMenuItemImage") 
	self.reject = tolua.cast(self.reject_btn, "CCMenuItemImage") 
	
	self:create_scroll_view(self.scroll_layer, self.msg)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:setVisible(false)
	
--	self:setYesButton(function()
--		self:dismiss()
--	end)
	self:setNoButton(function()
		self:dismiss()
		self:do_callback()
	end)
	
	self.yes_no_dialog_dismiss_callback = yes_no_dialog_dismiss_callback
	local menus = CCArray:create()
	
	menus:addObject(tolua.cast(self.scroll_view, "CCLayer"))
	menus:addObject(tolua.cast(self.reject_menu, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.confirm_menu, "CCLayerRGBA"))
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	self:setOnKeypad(function(key)
		print("yesno dialog on key pad")
		if key == "backClicked" then
			if self:isShowing()  then
				self:dismiss()
				self:do_callback()
			end
		end
	end)
	
end

function YesNoDialog3:do_callback()
	if "function" == type(self.yes_no_dialog_dismiss_callback) then
		self.yes_no_dialog_dismiss_callback()
	end
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

	
end
YesNoDialogUPlugin.bind(YesNoDialog3)
DialogInterface.bind(YesNoDialog3)