require "src.InfoLayerUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.CheckBox"

InfoLayer = class("InfoLayer", function()
	print("new InfoLayer")
	return display.newLayer("InfoLayer")
end
)

function createInfoLayer(info_changed_callback)
	print("create InfoLayer")
	return InfoLayer.new(info_changed_callback)
end

function InfoLayer:ctor(info_changed_callback)

	ccb.info_scene = self
	
	self.on_ui_ok_btn_clicked = __bind(self.do_ui_ok_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("Info.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(node)

	self:init_input_controller()

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:init_player_info()
	
	self.info_changed_callback = info_changed_callback
end

function InfoLayer:do_gender_checkbox_selected(tag, sender)
	print("[InfoLayer:do_gender_checkbox_selected] ")
	if sender == self.m_checkbox.toggle then
    	self.f_checkbox.toggle:setChecked(not self.f_checkbox.toggle:isChecked())
    else
    	self.m_checkbox.toggle:setChecked(not self.m_checkbox.toggle:isChecked())
    end
    
    local gender =  self.m_checkbox.toggle:isChecked() and 1 or 2
    
	self:show_progress_message_box("更改性别...")
	self.failure_msg = "更改失败"
	local changed_info = {retry="0", user_id = GlobalSetting.current_user.user_id, gender = gender, version="1.0"}
	self:complete_user_info(changed_info)
end

function InfoLayer:editBoxTextEventHandle(strEventName,pSender)
	print("[InfoLayer:do_gender_checkbox_selected] ")
	if strEventName == "ended" then
		local cur_nick_name = trim_blank(self.nick_name_box:getText())
		if is_blank(cur_nick_name) then
			self:show_message_box("昵称不能为空")
			self.nick_name_box:setText(GlobalSetting.current_user.nick_name)
			return
		end
		if cur_nick_name ~= GlobalSetting.current_user.nick_name then
			self:show_progress_message_box("更改昵称...")
			self.failure_msg = "更改失败"
			local changed_info = {retry="0", user_id = GlobalSetting.current_user.user_id, nick_name = cur_nick_name, version="1.0"}
			self:complete_user_info(changed_info)
		end
	end
end

function InfoLayer:init_input_controller()
	print("[InfoLayer:init_input_controller]")
	
	self.input_png = "kuang_a.png"
	self.nick_name_box = self:addEditbox(self.nick_name_edit_layer, 225, 30, false, 101)
	self.nick_name_box:setMaxLength(10)
	self.nick_name_box:setPlaceHolder("昵称为不大于10位的任意字符")
	print("[InfoLayer:init_input_controller] nick_name_box: ", self.nick_name_box)
	self.nick_name_box:registerScriptEditBoxHandler(__bind(self.editBoxTextEventHandle, self))
	print("[InfoLayer:init_input_controller] nick_name_box.onExit: ", self.nick_name_box.onExit)
	
	local menu1 = CheckBox.create("男")
	local menu2 = CheckBox.create("女")
	menu1:setPosition(ccp(72,25))
	menu2:setPosition(ccp(200,25))
	
	local function menuCallback(tag, sender)
        if sender == menu1.toggle then
        	menu2.toggle:setChecked(not menu2.toggle:isChecked())
        else
        	menu1.toggle:setChecked(not menu1.toggle:isChecked())
        end
    end
    menu1.toggle:registerScriptTapHandler(__bind(self.do_gender_checkbox_selected, self))
    menu2.toggle:registerScriptTapHandler(__bind(self.do_gender_checkbox_selected, self))
	menu1.toggle:setChecked(true)
    
	self.gender_layer:addChild(menu1)
	self.gender_layer:addChild(menu2)
	
	self.m_checkbox = menu1
	self.f_checkbox = menu2
end

function InfoLayer:init_player_info()
	print("[InfoLayer:init_player_info]")
	
	local cur_user = GlobalSetting.current_user
	
	local account_lb = tolua.cast(self.account_lb, "CCLabelTTF")
	account_lb:setString(cur_user.user_id)
	
	local nick_name_box = tolua.cast(self.nick_name_edit_layer:getChildByTag(101), "CCEditBox")
	nick_name_box:setText(cur_user.nick_name)
	
	local scores_lb = tolua.cast(self.scores_lb, "CCLabelTTF")
	scores_lb:setString(cur_user.score)
	
	local stas_lb = tolua.cast(self.stas_lb, "CCLabelTTF")
	local stas = cur_user.win_count / (cur_user.win_count + cur_user.lost_count) * 100
	stas = isnan(stas) and 0 or math.floor(stas + 0.5)
	stas_lb:setString(stas.."%  "..cur_user.win_count.." 胜  "..cur_user.lost_count.." 负")
	
	self.m_checkbox.toggle:setChecked(tonumber(cur_user.gender) == 1)
	self.f_checkbox.toggle:setChecked(tonumber(cur_user.gender) == 2)

end


function InfoLayer:do_on_trigger_success(data)
	print("[InfoLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	
	if "function" == type(self.info_changed_callback) then
		self.info_changed_callback(data)
	end
end

function InfoLayer:do_on_trigger_failure(data)
	print("[InfoLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)

end

UIControllerPlugin.bind(InfoLayer)
HallServerConnectionPlugin.bind(InfoLayer)

