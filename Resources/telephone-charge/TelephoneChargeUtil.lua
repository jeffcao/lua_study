-- this file is use for activity of telephone charge for version 1.4.0

require 'consts'
require 'src.ToastPlugin'
require 'telephone-charge.ChargeRoomHall'
require 'telephone-charge.DataProxy'

TelephoneChargeUtil = {}

TelephoneChargeUtil.is_telephone_charge_room = function(room_info)
	return room_info and tonumber(room_info.room_type) == ROOM_TYPE_TELEPHONE_CHARGE
end

TelephoneChargeUtil.on_telehone_charge_room_clicked = function()
	--this function only be called in hall scene, so can use hall scene websocket directly
	local hall_scene = runningscene()
	
	hall_scene.on_trigger_success = function(data)
		ToastPlugin.hide_progress_message_box()
		local data_proxy = createDataProxy('charge_matches')
		data_proxy:set_data(TelephoneChargeUtil.get_test_data())
		local layer = createChargeRoomHall()
		layer:show()
	end
	hall_scene:get_charge_matches()
	
	ToastPlugin.show_progress_message_box(strings.hscp_get_charge_matches_i)
end

TelephoneChargeUtil.get_test_data = function()
	local data = {}
	data.rule = '1.每场比赛30-300人，时间为15分钟，在规\n'..
					   '定的时间赢豆最多的玩家获得胜利，获得相\n'..
					   '应话费奖励。\n'..
					   '2.所有的虚拟奖品实时到账，用户可在排行\n'..
					   '中的话费排行查看中奖情况与金额，话费达\n'..
					   '到20元的整数倍即可提现。'
	data.awards = {}
	data.awards.ten = '第一名  10元\n'..
					 '第二名   5元\n'..
					 '第三名   3元\n'..
					 '第四至第六名   20000豆\n'..
					 '第七至第十名   10000豆'
	data.awards.thirty = '第一名  30元\n'..
					 	'第二名   15元\n'..
					 	'第三名   9元\n'..
					 	'第四至第六名   60000豆\n'..
					 	'第七至第十名   30000豆'
					 	
	data.matches = {}
	local match10 = {type='ten', start_time='08:00', ante=10000}
	local match11 = {type='ten', start_time='09:00', ante=10000}
	local match30 = {type='thirty', start_time='10:00', ante=30000}
	local match31 = {type='thirty', start_time='11:00', ante=30000}
	table.insert(data.matches, match10)
	table.insert(data.matches, match11)
	table.insert(data.matches, match30)
	table.insert(data.matches, match31)
	
	return data
end