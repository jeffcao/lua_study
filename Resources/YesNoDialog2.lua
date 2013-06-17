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
	
	self.msg = tolua.cast(self.msg_text, "CCLabelTTF")
	self.title = tolua.cast(self.title_text, "CCLabelTTF")
	self.confirm = tolua.cast(self.confirm_btn, "CCMenuItemImage")
	self.reject = tolua.cast(self.reject_btn, "CCMenuItemImage")
	
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