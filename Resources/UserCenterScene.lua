require "src.UserCenterSceneUPlugin"
require "src.UIControllerPlugin"
require "SetDialog"


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
	
	ccb.user_center_scene = self
	
	self.on_ui_close_btn_clicked = __bind(self.do_ui_close_btn_clicked, self)
	self.on_ui_avatar_btn_clicked = __bind(self.do_ui_avatar_btn_clicked, self)
	self.on_ui_update_avatar_btn_clicked = __bind(self.do_ui_update_avatar_btn_clicked, self) 
	self.on_ui_update_pwd_btn_clicked = __bind(self.do_ui_update_pwd_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("UserCenterScene.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(__bind(self.onKeypad, self))


	self:doSetLayer("personal_info")
	
end


UserCenterSceneUPlugin.bind(UserCenterScene)