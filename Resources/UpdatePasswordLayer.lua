require "src.UpdatePasswordLayerUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

UpdatePasswordLayer = class("UpdatePasswordLayer", function()
	print("create UpdatePasswordLayer")
	return display.newLayer("UpdatePasswordLayer")
end
)

function createUpdatePasswordLayer()
	print("create UpdatePasswordLayer")
	return UpdatePasswordLayer.new()
end

function UpdatePasswordLayer:ctor()

	ccb.update_pwd_scene = self
	
	self.on_ui_ok_btn_clicked = __bind(self.do_ui_ok_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("UpdatePassword.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(node)
	
--	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
--	
	self.input_png = "kuang_a.png"
	self.old_pwd_box = self:addEditbox(self.old_pwd_box_layer, 225, 30, true, 101)
	self.new_pwd_box = self:addEditbox(self.new_pwd_box_layer, 225, 30, true, 101)
	self.cfm_pwd_box = self:addEditbox(self.cfm_pwd_box_layer, 225, 30, true, 101)
	
	self.old_pwd_box:setPlaceHolder("输入原密码")
	self.new_pwd_box:setPlaceHolder("设置密码")
	self.cfm_pwd_box:setPlaceHolder("重复输入")
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
end

function UpdatePasswordLayer:do_ui_ok_btn_clicked(tag, sender)
	local old_pwd = self.old_pwd_box:getText()
	if is_blank(old_pwd) then
		self:show_message_box("请输入旧密码")
		return
	end
	local new_pwd = self.new_pwd_box:getText()
	if is_blank(new_pwd) then
		self:show_message_box("请输入新密码")
		return
	end
	if #new_pwd < 8 then
		self:show_message_box("密码不能小于8位")
		return
	end
	local cfm_pwd = self.cfm_pwd_box:getText()
	if new_pwd ~= cfm_pwd then
		self:show_message_box("两次输入的新密码不一致")
		return
	end
	self:show_progress_message_box("更改密码...")
	self:reset_password(old_pwd, new_pwd)
end

function UpdatePasswordLayer:do_on_trigger_success(data)
	print("[UpdatePasswordLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	self:show_message_box("更改密码成功")
	
end

function UpdatePasswordLayer:do_on_trigger_failure(data)
	print("[UpdatePasswordLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)

end

UpdatePasswordLayerUPlugin.bind(UpdatePasswordLayer)
UIControllerPlugin.bind(UpdatePasswordLayer)
HallServerConnectionPlugin.bind(UpdatePasswordLayer)