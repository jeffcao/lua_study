-- this file is use for activity of telephone charge for version 1.4.0

require 'consts'
require 'src.DialogPlugin'

TelephoneChargeUtil = {}

TelephoneChargeUtil.is_telephone_charge_room = function(room_info)
	return room_info and tonumber(room_info.room_type) == ROOM_TYPE_TELEPHONE_CHARGE
end

TelephoneChargeUtil.on_telehone_charge_room_clicked = function()
	local layer = CCLayer:create()
	
	local label = CCLabelTTF:create('test', 'default', "22")
	local layer_size = layer:getContentSize()
	label:setPosition(layer_size.width/2, layer_size.height/2)
	layer:addChild(label)
	DialogPlugin.bind(layer)
	layer:attach_to_scene()
end