require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.DialogInterface"

InitPlayerInfoLayer = class("InitPlayerInfoLayer", function()
	print("create InitPlayerInfoLayer")
	return display.newLayer("InitPlayerInfoLayer")
end
)

function createInitPlayerInfoLayer(init_player_info_callback)
	print("create InitPlayerInfoLayer")
	return InitPlayerInfoLayer.new(init_player_info_callback)
end

function InitPlayerInfoLayer:ctor(init_player_info_callback)

	ccb.init_player_info_scene = self
	
	self.on_ui_commit_btn_clicked = __bind(self.do_ui_commit_btn_clicked, self)
	self.on_ui_close_btn_clicked = __bind(self.do_ui_close_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("InitPlayerInfo.ccbi", ccbproxy, false, "")

	self:addChild(node)
	
	self.init_player_info_callback = init_player_info_callback
	
	set_green_stroke(self.commit_btn_lbl)
	set_red_stroke(self.close_btn_lbl)
	
	self:init_input_controller()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:show_player_info()
end

function InitPlayerInfoLayer:init_input_controller()
	print("[InitPlayerInfoLayer:init_input_controller]")
	self.input_png = "kuang_a.png"
	self.nick_name_box = self:addEditbox(self.nick_name_box_layer, 225, 30, false, 101)
	self.nick_name_box:setMaxLength(10)
	self.nick_name_box:setPlaceHolder("昵称为不大于10位的任意字符")
	self.nick_name_box:setFontColor(ccc3(255,255,255))
	self.password_box = self:addEditbox(self.pwd_box_layer, 225, 30, true, 101)
	self.password_box:setMaxLength(20)
	self.password_box:setPlaceHolder("密码为8到20位的任意字符")
	self.mail_box = self:addEditbox(self.mail_box_layer, 225, 30, false, 101)
	self.mail_box:setPlaceHolder("example@example.com")
	
	self.m_checkbox = CheckBox.create("男")
	self.f_checkbox = CheckBox.create("女")
	self.m_checkbox:setPosition(ccp(0,25))
	self.f_checkbox :setPosition(ccp(125,25))
	
	local function menuCallback(tag, sender)
        if sender == self.m_checkbox.toggle then
        	self.f_checkbox .toggle:setChecked(not self.m_checkbox.toggle:isChecked())
        else
        	self.m_checkbox.toggle:setChecked(not self.f_checkbox.toggle:isChecked())
        end
    end
  	self.m_checkbox.toggle:registerScriptTapHandler(menuCallback)
    self.f_checkbox.toggle:registerScriptTapHandler(menuCallback)
	self.gender_box_layer:addChild(self.m_checkbox)
	self.gender_box_layer:addChild(self.f_checkbox )
	
	
	
	local menus = CCArray:create()

	menus:addObject(tolua.cast(self.commit_btn_menu, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.close_btn_menu, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.nick_name_box, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.mail_box, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.password_box, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.m_checkbox, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.f_checkbox, "CCLayerRGBA"))
	
	self:setVisible(false)
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()

	self:setOnKeypad(function(key)
		if key == "backClicked" then
			if self:isShowing()  then
				self:dismiss()
				self.init_player_info_callback(false)
			end
		end
	end)
end

function InitPlayerInfoLayer:show_player_info()
	print("[InitPlayerInfoLayer:show_player_info]")
	local user_id_lb = tolua.cast(self.user_id_lb, "CCLabelTTF")
    user_id_lb:setString(GlobalSetting.current_user.user_id)
    self.nick_name_box:setText(GlobalSetting.current_user.nick_name)
    self.m_checkbox.toggle:setChecked(tonumber(GlobalSetting.current_user.gender) == 1)
	self.f_checkbox.toggle:setChecked(tonumber(GlobalSetting.current_user.gender) == 2)

end

function InitPlayerInfoLayer:do_ui_commit_btn_clicked(tag, sender)
	print("[InitPlayerInfoLayer:do_ui_commit_btn_clicked]")
	local nick_name = trim_blank(self.nick_name_box:getText())
	local params = {z_order=99999}
	if is_blank(nick_name) then
		self:show_message_box(strings.ii_nick_name_nil_w, params9)
		return
	end
	local password = trim_blank(self.password_box:getText())
	if is_blank(password) then
		self:show_message_box(strings.ii_pswd_nil_w, params)
		return
	end
	if #password < 8 then
		self:show_message_box(strings.ii_pswd_format_w, params)
		return
	end
	local mail = trim_blank(self.mail_box:getText())
	if is_blank(mail) then
		self:show_message_box(strings.ii_email_nil_w,{msg_width=660,z_order=99999})
		return
	end
	if not check_email(mail) then
		self:show_message_box(strings.ii_email_format_w,params)
		return
	end
	local gender =  self.m_checkbox.toggle:isChecked() and 1 or 2
	
	self:show_progress_message_box(strings.ii_update_info_ing, nil, nil, 99999)
	
	self.failure_msg = strings.ii_update_info_w
	local changed_info = {retry="0", user_id = GlobalSetting.current_user.user_id, gender = gender, 
	nick_name = nick_name, password = password, email = mail, version="1.0"}
	--self:complete_user_info(changed_info)
	
	self.failure_msg = strings.hscp_get_player_info_w
	GlobalSetting.hall_server_websocket:trigger("ui.complete_user_info", 
			changed_info,
			__bind(self.do_on_trigger_success_not_toast, self),
			__bind(self.do_on_trigger_failure, self))
end

function InitPlayerInfoLayer:do_ui_close_btn_clicked(tag, sender)
	print("[InitPlayerInfoLayer:do_ui_close_btn_clicked]")
	self:hide_progress_message_box()
	self:dismiss()
	self.init_player_info_callback(false)
end

function InitPlayerInfoLayer:do_on_trigger_success_not_toast(data)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
	GlobalSetting.current_user.nick_name = data.nick_name
	GlobalSetting.current_user.gender = data.gender
	GlobalSetting.current_user.email = data.email
	self:hide_progress_message_box()
	self:dismiss()
	self.init_player_info_callback(true)
	
end

function InitPlayerInfoLayer:do_on_trigger_success(data)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
	GlobalSetting.current_user.nick_name = data.nick_name
	GlobalSetting.current_user.gender = data.gender
	GlobalSetting.current_user.email = data.email
	self:hide_progress_message_box()
	self:show_message_box_suc(strings.ii_update_info_s, params)
	self:dismiss()
	self.init_player_info_callback(true)
	
end

function InitPlayerInfoLayer:do_on_trigger_failure(data)
	print("[InitPlayerInfoLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	local msg = self.failure_msg
	if data.result_message then msg = data.result_message end
	self:show_message_box(msg, params)
	self:show_player_info()
end


UIControllerPlugin.bind(InitPlayerInfoLayer)
HallServerConnectionPlugin.bind(InitPlayerInfoLayer)
DialogInterface.bind(InitPlayerInfoLayer)