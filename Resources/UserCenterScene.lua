require "src.UserCenterSceneUPlugin"
UserCenterScene = class("UserCenterScene", function()
	print("new UserCenterScene")
	return display.newScene("UserCenterScene")
	end
)

function createUserCenterScene()
	print("create UserCenterScene")
	return UserCenterScene.new()
end

function UserCenterScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("UserCenterScene.ccbi")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(__bind(self.onKeypad, self))
	
	self.close_menu_item = self.ccbproxy:getNodeWithType("close_menu_item", "CCMenuItemImage")
	self.close_menu_item:registerScriptTapHandler(__bind(self.onCloseClick, self))
	
end

UserCenterSceneUPlugin.bind(UserCenterScene)