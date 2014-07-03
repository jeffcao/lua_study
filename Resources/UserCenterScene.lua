require "src.UserCenterSceneUPlugin"
require "src.UIControllerPlugin"
require "SetDialog"
require "FullMubanStyleLayer"
require "src.Stats"

UserCenterScene = class("UserCenterScene", function()
	print("new UserCenterScene")
	return display.newScene("UserCenterScene")
	end
)

function createUserCenterScene(avatar_call_back, i_layer)
	print("create UserCenterScene")
	return UserCenterScene.new(avatar_call_back, i_layer)
end

function UserCenterScene:ctor(avatar_call_back, i_layer)
	
	ccb.user_center_scene = self
	self.i_layer = i_layer
	self.on_ui_close_btn_clicked = __bind(self.do_ui_close_btn_clicked, self)
	self.on_ui_avatar_btn_clicked = __bind(self.do_ui_avatar_btn_clicked, self)
	self.on_ui_update_avatar_btn_clicked = __bind(self.do_ui_update_avatar_btn_clicked, self) 
	self.on_ui_update_pwd_btn_clicked = __bind(self.do_ui_update_pwd_btn_clicked, self)
	self.on_player_cats_btn_clicked = __bind(self.do_player_cats_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("UserCenterScene.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	--self:addChild(node)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(__bind(self.onKeypad, self))
	
	self.avatar_call_back = avatar_call_back
	
	--self:init_controller(i_layer)
	
--	self.avatar_bg:setScale(GlobalSetting.content_scale_factor*1.55)
	
	set_anniu_1_3_stroke(self.update_jiben_btn_lbl)
	set_anniu_1_3_stroke(self.update_avatar_btn_lbl)
	set_anniu_1_3_stroke(self.update_pswd_btn_lbl)
	set_anniu_1_3_stroke(self.my_prop_btn_lbl)
	
	local layer = createFullMubanStyleLayer()
	layer:setTitle("wenzi_gerenziliao.png")
	self:addChild(layer)
	layer:setContent(node)
	layer:setOnBackClicked(function() print('muban on close') end)
end

function UserCenterScene:onEnter()
	self:init_controller(self.i_layer)
	Stats:on_start("user_center")
end

function UserCenterScene:onExit()
	Stats:on_end("user_center")
end

UserCenterSceneUPlugin.bind(UserCenterScene)
UIControllerPlugin.bind(UserCenterScene)
SceneEventPlugin.bind(UserCenterScene)