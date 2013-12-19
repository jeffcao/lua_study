require "src.YesNoDialogUPlugin"
require "src.DialogPlugin"
require 'CCBReaderLoad'

YesNoDialog = class("YesNoDialog", function()
	print("new YesNoDialog")
	return display.newLayer("YesNoDialog")
end
)

function createYesNoDialog(container, z_order)
	print("create YesNoDialog")
	z_order = z_order or 10000
	local dialog = YesNoDialog.new()
	--container:addChild(dialog, z_order)
	dialog:attach_to(container)
	return dialog
end

function YesNoDialog:ctor()
	local ccbproxy = CCBProxy:create()
	ccbproxy:retain()
 	ccb.YesNoDialog = self
 	CCBReaderLoad("ExitLayer.ccbi", ccbproxy, true, "YesNoDialog")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	set_green_stroke(self.reject_btn_lbl)
	set_red_stroke(self.confirm_btn_lbl)
	
	self:setYesButton(function()
		self:dismiss()
	end)
	self:setNoButton(function()
		self:dismiss()
	end)
	
	self:init_dialog()
	self:setClickOutDismiss(false)
end

YesNoDialogUPlugin.bind(YesNoDialog)
DialogPlugin.bind(YesNoDialog)