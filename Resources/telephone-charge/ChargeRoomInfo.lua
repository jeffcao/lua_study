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
		ToastPlugin.show_message_box_suc('报名')
	end
end

function ChargeRoomInfo:init_room_info(room_info)
	self.room_info = room_info
	local data = DataProxy.get_exist_instance('charge_matches'):get_data()
	self.rule:setString(data.rule_info[room_info.rule_name])
	self.award:setString(data.bonus_info[room_info.bonus_name])
end

DialogPlugin.bind(ChargeRoomInfo)
