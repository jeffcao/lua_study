require "src.YesNoDialogUPlugin"
require "src.DialogPlugin"
require 'CCBReaderLoad'

BackMessageBoxLayer = class("BackMessageBoxLayer", function()
	print("new BackMessageBoxLayer")
	return display.newLayer("BackMessageBoxLayer")
end
)

function createBackMessageBoxLayer(container)
	print("create BackMessageBoxLayer")
	local dialog = BackMessageBoxLayer.new()
	dialog:attach_to(container)
	return dialog
end

function BackMessageBoxLayer:ctor()
	local ccbproxy = CCBProxy:create()
	ccbproxy:retain()
 	ccb.back_message_box = self
 	CCBReaderLoad("BackMessageBoxLayer.ccbi", ccbproxy, true, "back_message_box")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	set_anniu_1_3_stroke(self.reject_btn_lbl)
	self:setNoButton(function() self:dismiss() end)
	self:init_dialog()
end

YesNoDialogUPlugin.bind(BackMessageBoxLayer)
DialogPlugin.bind(BackMessageBoxLayer)