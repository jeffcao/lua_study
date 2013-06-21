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
--	
	self.input_png = "kuang_a.png"
	self.nick_name_box = self:addEditbox(self.nick_name_box_layer, 225, 30, false, 101)
	self.password_box = self:addEditbox(self.pwd_box_layer, 225, 30, true, 101)
	
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
	
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.init_player_info_callback = init_player_info_callback
	
	local menus = CCArray:create()

	menus:addObject(tolua.cast(self.commit_btn_menu, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.close_btn_menu, "CCLayerRGBA"))
	menus:addObject(tolua.cast(self.nick_name_box, "CCLayerRGBA"))
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
			end
		end
	end)
	
end

function InitPlayerInfoLayer:do_ui_commit_btn_clicked(tag, sender)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
	
	self:show_progress_message_box("更新资料...")
--	self:reset_password(old_pwd, new_pwd)
end

function InitPlayerInfoLayer:do_ui_close_btn_clicked(tag, sender)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
--	self.init_player_info_callback(false)
	self:dismiss()
end

function InitPlayerInfoLayer:do_on_trigger_success(data)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	self:show_message_box("更新资料成功")
	self.init_player_info_callback(true)
end

function InitPlayerInfoLayer:do_on_trigger_failure(data)
	print("[InitPlayerInfoLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)

end

UIControllerPlugin.bind(InitPlayerInfoLayer)
HallServerConnectionPlugin.bind(InitPlayerInfoLayer)
DialogInterface.bind(InitPlayerInfoLayer)