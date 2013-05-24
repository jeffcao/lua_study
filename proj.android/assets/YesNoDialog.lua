require "src.YesNoDialogUPlugin"
require "src.DialogInterface"

YesNoDialog = class("YesNoDialog", function()
	print("new YesNoDialog")
	return display.newLayer("YesNoDialog")
end
)

function createYesNoDialog()
	print("create YesNoDialog")
	return YesNoDialog.new()
end

function YesNoDialog:ctor()
	self.ccbproxy = CCBProxy:create()
 	self.ccbproxy:retain()
 	
 	local node = self.ccbproxy:readCCBFromFile("ExitLayer.ccbi")
	assert(node, "failed to load hall scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:addChild(self.rootNode)
	
	self.msg = self.ccbproxy:getNodeWithType("msg_text", "CCLabelTTF")
	self.title = self.ccbproxy:getNodeWithType("title_text", "CCLabelTTF")
	self.confirm = self.ccbproxy:getNodeWithType("confirm_btn", "CCMenuItemImage")
	self.reject = self.ccbproxy:getNodeWithType("reject_btn", "CCMenuItemImage")
	self:setVisible(false)
	
	self:setNoButton(function()
		self:dismiss()
	end)
	
	local menus = CCArray:create()
	self.reject_menu = self.ccbproxy:getNodeWithType("reject_menu", "CCMenu")
	self.confirm_menu = self.ccbproxy:getNodeWithType("confirm_menu", "CCMenu")
	menus:addObject(self.reject_menu)
	menus:addObject(self.confirm_menu)
	self:swallowOnTouch(menus)
	--[[
	self:setOnKeypad(function(key)
		print("yesno dialog on key pad")
		if key == "backClicked" then
			if self:isVisible()  then
				self:setVisible(false)
			end
		end
	end)
	]]
end
YesNoDialogUPlugin.bind(YesNoDialog)
DialogInterface.bind(YesNoDialog)