require "src.YesNoDialogUPlugin"
require "src.DialogInterface"

YesNoDialog = class("YesNoDialog", function()
	print("new YesNoDialog")
	return display.newLayer("YesNoDialog")
end
)

function createYesNoDialog(container, z_order)
	print("create YesNoDialog")
	z_order = z_order or 10000
	local dialog = YesNoDialog.new()
	container:addChild(dialog, z_order)
	return dialog
end

function YesNoDialog:ctor()
	local ccbproxy = CCBProxy:create()

 	ccb.YesNoDialog = self

 	local node = CCBReaderLoad("ExitLayer.ccbi", ccbproxy, true, "YesNoDialog")
	self:addChild(node)
	
	self.msg = tolua.cast(self.msg_text, "CCLabelTTF") 
	self.title = tolua.cast(self.title_text, "CCLabelTTF")
	self.confirm = tolua.cast(self.confirm_btn, "CCMenuItemImage") 
	self.reject = tolua.cast(self.reject_btn, "CCMenuItemImage") 
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:setVisible(false)
	
	self:setYesButton(function()
		self:dismiss()
	end)
	self:setNoButton(function()
		self:dismiss()
	end)
	
	local menus = CCArray:create()

	menus:addObject(tolua.cast(self.reject_menu, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.confirm_menu, "CCLayerRGBA"))
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	set_green_stroke(self.reject_btn_lbl)
	set_red_stroke(self.confirm_btn_lbl)
	
	self:setOnKeypad(function(key)
		print("yesno dialog on key pad")
		if key == "backClicked" then
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	
end


YesNoDialogUPlugin.bind(YesNoDialog)
DialogInterface.bind(YesNoDialog)