require "src.YesNoDialogUPlugin"
require "src.DialogInterface"

BackMessageBoxLayer = class("BackMessageBoxLayer", function()
	print("new BackMessageBoxLayer")
	return display.newLayer("BackMessageBoxLayer")
end
)

function createBackMessageBoxLayer(container)
	print("create BackMessageBoxLayer")
	local dialog = BackMessageBoxLayer.new()
	container:addChild(dialog)
	return dialog
end        

function BackMessageBoxLayer:ctor()
	local ccbproxy = CCBProxy:create()

 	ccb.back_message_box = self

 	local node = CCBReaderLoad("BackMessageBoxLayer.ccbi", ccbproxy, true, "YesNoDialog")
	self:addChild(node)
	
	self.msg = tolua.cast(self.msg_text, "CCLabelTTF") 
	self.title = tolua.cast(self.title_text, "CCLabelTTF")
	self.confirm = tolua.cast(self.confirm_btn, "CCMenuItemImage") 
	self.reject = tolua.cast(self.reject_btn, "CCMenuItemImage") 
	
	self.reject_btn.rootNode = self;

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:setVisible(false)
	
	set_stroke(self.reject_btn_lbl, 2, GlobalSetting.blue_stroke)
	
--	self:setYesButton(function()
--		self:dismiss()
--	end)
	self:setNoButton(function()
		self:dismiss()
	end)
	

	local menus = CCArray:create()

	menus:addObject(tolua.cast(self.reject_menu, "CCLayerRGBA"))
	--menus:addObject(tolua.cast(self.confirm_menu, "CCLayerRGBA"))
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	self:setOnKeypad(function(key)
		print("yesno dialog on key pad")
		if key == "backClicked" then
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	
end


YesNoDialogUPlugin.bind(BackMessageBoxLayer)
DialogInterface.bind(BackMessageBoxLayer)