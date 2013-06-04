require "src.YesNoDialogUPlugin"
require "src.SceneDialog"

YesNoDialog2 = class("YesNoDialog2", function()
	return display.newScene("YesNoDialog2")
end
)

function createYesNoDialog2()
	return YesNoDialog2.new()
end

function YesNoDialog2:ctor()
	self:create("ExitLayer.ccbi")
	
	self.msg = self.ccbproxy:getNodeWithType("msg_text", "CCLabelTTF")
	self.title = self.ccbproxy:getNodeWithType("title_text", "CCLabelTTF")
	self.confirm = self.ccbproxy:getNodeWithType("confirm_btn", "CCMenuItemImage")
	self.reject = self.ccbproxy:getNodeWithType("reject_btn", "CCMenuItemImage")
	
	self:setNoButton(function()
		self:dismiss()
	end)

	self:setOnKeypad(function(key)
		print("yesno dialog on key pad")
		if key == "backClicked" then
				self:dismiss()
		end
	end)
	
end
YesNoDialogUPlugin.bind(YesNoDialog2)
SceneDialog.bind(YesNoDialog2)