require "src.UIControllerPlugin"
require "src.LoginServerConnectionPlugin"
require "src.Stats"

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
	self.user_id_box = self:addEditbox(self.user_id_box_layer, 300, 50, false, 101)
	self.user_id_box:setInputMode(kEditBoxInputModeNumeric)
	self.user_id_box:setMaxLength(5)
	self.user_id_box:setPlaceHolder(" 请输入帐号(如:12345)")
	self.mail_box = self:addEditbox(self.mail_box_layer, 300, 50, false, 101)
	self.mail_box:setPlaceHolder(" example@example.com")
	self.user_id_box:setFont("default",24)
	self.user_id_box:setFontColor(ccc3(255,255,255))
	self.mail_box:setFont("default",24)
	self.mail_box:setFontColor(ccc3(255,255,255))
	
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
		self:show_message_box(strings.forget_pswd_id_nil_w)
		return
	end
	local mail = trim_blank(self.mail_box:getText())
	if is_blank(mail) then
		self:show_message_box(strings.forget_pswd_email_nil_w)
		return
	end
	
	if not check_email(mail) then
		self:show_message_box(strings.forget_pswd_email_err_w)
		return
	end
	
	self:show_progress_message_box(strings.forget_pswd_submit_ing)
	self:forget_password(user_id, mail)
end

function ForgetPasswordScene:do_on_trigger_success(data)
	print("[ForgetPasswordScene:do_on_trigger_success]")
	self:hide_progress_message_box()
	
	self:show_message_box_suc(strings.forget_pswd_find_s)

end

function ForgetPasswordScene:do_on_trigger_failure(data)
	print("[ForgetPasswordScene:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self.failure_msg = strings.forget_pswd_find_w
	if not is_blank(data.result_message) then
		self.failure_msg = data.result_message
	end
	self:show_back_message_box(self.failure_msg)

end

function ForgetPasswordScene:onEnter()
	Stats:on_start("forget_password")
end

function ForgetPasswordScene:onExit()
	Stats:on_end("forget_password")
end

UIControllerPlugin.bind(ForgetPasswordScene)
LoginServerConnectionPlugin.bind(ForgetPasswordScene)