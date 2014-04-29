require 'CCBReaderLoad'
require 'src.DialogPlugin'
require 'telephone-charge.DataProxy'

ChargeRoomInfo = class("ChargeRoomInfo", function() 
	return display.newLayer("ChargeRoomInfo")
	end
)

function createChargeRoomInfo()
	print("create charge room item")
	return ChargeRoomInfo.new()
end

function ChargeRoomInfo:ctor()
	ccb.charge_room_info = self
	
	local ccbproxy = CCBProxy:create()
 	ccbproxy:retain()
 	CCBReaderLoad("ChargeRoomInfo.ccbi", ccbproxy, true, "charge_room_info")
	self:addChild(self.rootNode)

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:init_dialog()
	self:setClickOutDismiss(false)
	self:setBackDismiss(false)
	self:attach_to(CCDirector:sharedDirector():getRunningScene().rootNode)
	
	local winSize = CCDirector:sharedDirector():getWinSize()
	self.rootNode:setPosition(ccp(winSize.width/2, winSize.height/2))
	self.rootNode:ignoreAnchorPointForPosition(false)
	
	self.close_btn.on_touch_fn = function()
		self:dismiss()
	end
	
	self.register_account_btn.on_touch_fn = function()
 		self:on_join_click()
 		self:dismiss()
	end
end

function ChargeRoomInfo:on_join_click()
	local text = nil
	local status = self.room_info.match_state
	local joined = self.room_info.p_is_joined

	if status == CHARGE_MATCH_STATUS.playing then
		if joined then
		--	text = '可进入'
		else
			text = strings.tc_match_join_full
		end
	elseif status == CHARGE_MATCH_STATUS.playing_joining_disable then
		if joined then
		--	text = '可进入'
		else
			text = strings.tc_match_join_full
		end
	elseif status == CHARGE_MATCH_STATUS.playing_joining_enable then
		if joined then
		--	text = '可进入'
		else
		--	text = '报名'
		end
	elseif status == CHARGE_MATCH_STATUS.joining_disable then
		if joined then
			text = strings.tc_match_not_start
		else 
			text = strings.tc_match_join_full
		end
	elseif status == CHARGE_MATCH_STATUS.joining_enable then
		if joined then
			text = strings.tc_match_not_start
		else
		--	text = '报名'
		end
	end
	
	if text then
		ToastPlugin.show_message_box(text)
		return
	end
	--[[
	MatchLogic.on_match_room_click(self.room_info, function() 
 			if GlobalSetting.hall_scene then
 				GlobalSetting.hall_scene:on_private_match_start(self.room_info)
 			end
 		end)
 	]]
 	if GlobalSetting.hall_scene then
 		GlobalSetting.hall_scene:do_on_room_touched(self.room_info)
 	end
	do return end
	if joined then
	-- enter match game process
	else
	-- join match game process
	end
end

function ChargeRoomInfo:init_room_info(room_info)
	self.room_info = room_info
	local data = DataProxy.get_exist_instance('charge_matches'):get_data()
	
	local rule_description = string.gsub(data.rule_info[room_info.rule_name],'</br>','/n')
	self.rule:setString(rule_description)
	local award_description = string.gsub(data.bonus_info[room_info.bonus_name],'</br>','/n')
	self.award:setString(award_description)
	self.join_btn_lbl:setString(TelephoneChargeUtil.get_status_text(room_info))
end

DialogPlugin.bind(ChargeRoomInfo)
