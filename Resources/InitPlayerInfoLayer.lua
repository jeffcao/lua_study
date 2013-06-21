require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

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
--	self.rootNode:setTouchEnabled(true)
--	self.rootNode:registerScriptTouchHandler(__bind(self.on_msg_layer_touched, self), false, -1024, true)
--	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
--	
	self.input_png = "kuang_a.png"
	self.nick_name_box = self:addEditbox(self.nick_name_box_layer, 225, 30, false, 101)
	self.password_box = self:addEditbox(self.pwd_box_layer, 225, 30, true, 101)

	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.init_player_info_callback = init_player_info_callback
	
end

function InitPlayerInfoLayer:do_ui_commit_btn_clicked(tag, sender)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
	
--	self:show_progress_message_box("更新资料...")
--	self:reset_password(old_pwd, new_pwd)
end

function InitPlayerInfoLayer:do_ui_close_btn_clicked(tag, sender)
	print("[InitPlayerInfoLayer:do_on_trigger_success]")
	self.init_player_info_callback(false)
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