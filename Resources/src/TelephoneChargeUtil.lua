-- this file is use for activity of telephone charge for version 1.4.0

require 'consts'
require 'telephone-charge.ChargeRoomHall'

local time = 0
local positions = {}
positions[3] = {ccp(25, 120), ccp(270, 120), ccp(515, 120)}
positions[4] = {ccp(25, 170), ccp(270, 170), ccp(515, 170), ccp(270, 55)}
TelephoneChargeUtil = {}

TelephoneChargeUtil.is_telephone_charge_room = function(room_info)
	return room_info and tonumber(room_info.room_type) == ROOM_TYPE_TELEPHONE_CHARGE
end

TelephoneChargeUtil.on_telehone_charge_room_clicked = function()
	local layer = createChargeRoomHall()
	layer:show()
end