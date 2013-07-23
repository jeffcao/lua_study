require "src.UIControllerPlugin"
require "src.LoginServerConnectionPlugin"

ForgetPasswordScene = class("ForgetPasswordScene", function() 
		return display.newScene("ForgetPasswordScene") 
	end)

function createForgetPasswordScene() return ForgetPasswordScene.new() end

function ForgetPasswordScene:ctor()
	ccb.forget_pwd_scene = self
	
	self.on_ui_ok_btn_clicked = __bind(self.do_ui_ok_btn_clicked, self)
	
	local function editBoxTextEventHandle(strEventName,pSender)
		local edit = tolua.cast(pSender,"CCEditBox")
		if strEventName == "changed" then
			self.feedback_ttf:setString(edit:getText())
		end
	end
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("ForgetPassword.ccbi", ccbproxy, false, "")
 	
 	self.input_png = "kuang_a.png"
	self.user_id_box = self:addEditbox(self.user_id_box_layer, 270, 30, false, 101)
	self.user_id_box:setInputMode(kEditBoxInputModeNumeric)
	self.user_id_box:setMaxLength(5)
	self.user_id_box:setPlaceHolder("请输入帐号(如:12345)")
	self.mail_box = self:addEditbox(self.mail_box_layer, 270, 30, false, 101)
	self.mail_box:setPlaceHolder("example@example.com")
	
	--self.feedback_ttf:setDimensions(CCSizeMake(460,160))
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("biaoti08.png")
	
	layer:setContent(node)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)

end

function ForgetPasswordScene:do_ui_ok_btn_clicked(tag, sender)
	print("[ForgetPasswordScene:do_ui_ok_btn_clicked]")
	local user_id = trim_blank(self.user_id_box:getText())
	if is_blank(user_id) then
		self:show_message_box("帐号不能为空")
		return
	end
	local mail = trim_blank(self.mail_box:getText())
	if is_blank(mail) then
		self:show_message_box("邮箱地址不能为空")
		return
	end
	
	if not check_email(mail) then
		self:show_message_box("请输入正确的邮箱地址.")
		return
	end
	
	self:show_progress_message_box("提交取回密码信息...")
	self:forget_password(user_id, mail)
end

function ForgetPasswordScene:do_on_trigger_success(data)
	print("[ForgetPasswordScene:do_on_trigger_success]")
	self:hide_progress_message_box()
	
	self:show_message_box("提交信息成功, 请注意查收邮件.")

end

function ForgetPasswordScene:do_on_trigger_failure(data)
	print("[ForgetPasswordScene:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self.failure_msg = "取回密码失败, 请检查您输入的帐号与绑定邮箱是否正确."
	if not is_blank(data.result_message) then
		self.failure_msg = data.result_message
	end
	self:show_back_message_box(self.failure_msg)

end

UIControllerPlugin.bind(ForgetPasswordScene)
LoginServerConnectionPlugin.bind(ForgetPasswordScene)