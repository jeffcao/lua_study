require "src.HallServerConnectionPlugin"
require "src.UIControllerPlugin"

AvatarListLayer = class("AvatarListLayer", function()
	return display.newLayer("AvatarListLayer")
end
)

function createAvatarListLayer(avatar_callback)
	return AvatarListLayer.new(avatar_callback)
end

function AvatarListLayer:ctor(avatar_callback)

	ccb.avatar_list_scene = self
	
	self.on_ui_avatar_btn_clicked = __bind(self.do_ui_avatar_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("AvatarList.ccbi", ccbproxy, false, "")
 	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(node)
	self.avatar_callback = avatar_callback
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
end

function AvatarListLayer:do_ui_avatar_btn_clicked(tag, sender)
	print("[AvatarListLayer:do_ui_avatar_btn_clicked]")
	self:show_progress_message_box(strings.update_avatar_ing)
	local changed_info = {retry="0", user_id = GlobalSetting.current_user.user_id, avatar = tag-1000}
	self:complete_user_info(changed_info)
end

function AvatarListLayer:do_on_trigger_success(data)
	print("[AvatarListLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	
	if "function" == type(self.avatar_callback) then
		self.avatar_callback(data)
	end
		
end

function AvatarListLayer:do_on_trigger_failure(data)
	print("[AvatarListLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)
	if "function" == type(self.after_trigger_failure) then
		self.after_trigger_failure(data)
	end
end

HallServerConnectionPlugin.bind(AvatarListLayer)
UIControllerPlugin.bind(AvatarListLayer)

