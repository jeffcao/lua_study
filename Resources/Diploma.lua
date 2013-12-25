require "CCBReaderLoad"
require "src.DialogPlugin"
require 'src.strings'
Diploma = class("Diploma", function() return display.newLayer("Diploma") end)

function createDiploma() return Diploma.new() end

function Diploma:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	self.onConfirm = __bind(self.do_onConfirm, self)
	ccb.Diploma = self
	CCBReaderLoad("Diploma.ccbi", self.ccbproxy, true, "Diploma")
	self:addChild(self.rootNode)
	self:init_dialog()
	--self.award_lbl.stroke_size = 3
	set_green_stroke(self.confirm_btn_lbl)
	self.msg_lbl:setContentSize(CCSizeMake(400,75))
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function Diploma:do_onConfirm()
	self:dismiss()
end

function Diploma:init(data)
	--local msg = string.gsub(strings.dp_msg, 'nick_name', data.nick_name)
	--msg = string.gsub(msg, 'room_name', data.room_name)
	--msg = string.gsub(msg, 'match_name', data.match_name)
	local msg = data.dp_msg
	msg = string.gsub(msg, '\\b', '\b')
	self.msg_lbl:setString(msg)
	--local award_msg = string.gsub(strings.dp_award_msg, 'order', data.order)
	--award_msg = string.gsub(award_msg, 'award', data.award)
	local award_msg = data.dp_award_msg
	award_msg = string.gsub(award_msg, '\\b', '\b')
	set_yellow_string_with_stroke(self.award_lbl, award_msg)
end

DialogPlugin.bind(Diploma)
