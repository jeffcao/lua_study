require 'CCBReaderLoad'
require 'src.DialogPlugin'

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
end

function ChargeRoomInfo:init_room_info(room_info)
end

function ChargeRoomInfo:on_click()
end

DialogPlugin.bind(ChargeRoomInfo)
