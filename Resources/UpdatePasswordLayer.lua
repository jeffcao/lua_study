require "src.UpdatePasswordLayerUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.AppStats"

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
	self.old_pwd_box = self:addEditbox(self.old_pwd_box_layer, 250, 50, true, 101)
	self.new_pwd_box = self:addEditbox(self.new_pwd_box_layer, 250, 50, true, 101)
	self.cfm_pwd_box = self:addEditbox(self.cfm_pwd_box_layer, 250, 50, true, 101)
	self.old_pwd_box:setFont("default",24)
	self.new_pwd_box:setFont("default",24)
	self.cfm_pwd_box:setFont("default",24)
	self.old_pwd_box:setFontColor(ccc3(255,255,255))
	self.new_pwd_box:setFontColor(ccc3(255,255,255))
	self.cfm_pwd_box:setFontColor(ccc3(255,255,255))
	
	self.old_pwd_box:setPlaceHolder(" 输入原密码")
	self.new_pwd_box:setPlaceHolder(" 设置密码")
	self.cfm_pwd_box:setPlaceHolder(" 重复输入")
	
	set_green_stroke(self.ok_btn_lbl)
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
end

function UpdatePasswordLayer:do_ui_ok_btn_clicked(tag, sender)
	AppStats.event(UM_COMMIT_PASSWORD_MODIFY)
	local old_pwd = self.old_pwd_box:getText()
	if is_blank(old_pwd) then
		self:show_message_box(strings.upl_input_old_pswd_t)
		return
	end
	local new_pwd = self.new_pwd_box:getText()
	if is_blank(new_pwd) then
		self:show_message_box(strings.upl_input_new_pswd_t)
		return
	end
	if #new_pwd < 8 then
		self:show_message_box(strings.upl_pswd_format_w)
		return
	end
	local cfm_pwd = self.cfm_pwd_box:getText()
	if new_pwd ~= cfm_pwd then
		self:show_message_box(strings.upl_pswd_not_same_w)
		return
	end
	self:show_progress_message_box(strings.upl_update_pswd_ing)
	self:reset_password(old_pwd, new_pwd)
end

function UpdatePasswordLayer:do_on_trigger_success(data)
	print("[UpdatePasswordLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	self:show_message_box_suc(strings.upl_update_pswd_s)
	self.old_pwd_box:setText("")
	self.new_pwd_box:setText("")
	self.cfm_pwd_box:setText("")
end

function UpdatePasswordLayer:do_on_trigger_failure(data)
	print("[UpdatePasswordLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)
	self.old_pwd_box:setText("")
	self.new_pwd_box:setText("")
	self.cfm_pwd_box:setText("")
end

UpdatePasswordLayerUPlugin.bind(UpdatePasswordLayer)
UIControllerPlugin.bind(UpdatePasswordLayer)
HallServerConnectionPlugin.bind(UpdatePasswordLayer)