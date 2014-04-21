-- this file is use for activity of telephone charge for version 1.4.0

require 'consts'
require 'src.DialogPlugin'
require 'telephone-charge.ChargeRoomItem'

TelephoneChargeUtil = {}

TelephoneChargeUtil.is_telephone_charge_room = function(room_info)
	return room_info and tonumber(room_info.room_type) == ROOM_TYPE_TELEPHONE_CHARGE
end

TelephoneChargeUtil.on_telehone_charge_room_clicked = function()
	local layer = createChargeRoomItem()
	DialogPlugin.bind(layer)
	layer:attach_to_scene()
end