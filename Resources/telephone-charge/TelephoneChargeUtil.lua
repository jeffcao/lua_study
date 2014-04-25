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
	
	hall_scene.after_trigger_success = function(data)
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
	data.rule_info = {}
	data.rule_info.ten = '1.每场比赛30-300人，时间为15分钟，在规\n'..
					   '定的时间赢豆最多的玩家获得胜利，获得相\n'..
					   '应话费奖励。\n'..
					   '2.所有的虚拟奖品实时到账，用户可在排行\n'..
					   '中的话费排行查看中奖情况与金额，话费达\n'..
					   '到20元的整数倍即可提现。'
	data.bonus_info = {}
	data.bonus_info.ten = '第一名  10元\n'..
					 '第二名   5元\n'..
					 '第三名   3元\n'..
					 '第四至第六名   20000豆\n'..
					 '第七至第十名   10000豆'
	data.bonus_info.twenty = '第一名  20元\n'..
					 '第二名   10元\n'..
					 '第三名   6元\n'..
					 '第四至第六名   40000豆\n'..
					 '第七至第十名   20000豆'
	data.bonus_info.thirty = '第一名  30元\n'..
					 	'第二名   15元\n'..
					 	'第三名   9元\n'..
					 	'第四至第六名   60000豆\n'..
					 	'第七至第十名   30000豆'
					 	
	data.match_list = {}
	local match10 = {bonus_name='ten', rule_name='ten', start_time='08:00', ante=10000, png_name='wenzi_10yuansai.png'}
	local match11 = {bonus_name='ten', rule_name='ten', start_time='09:00', ante=10000, png_name='wenzi_10yuansai.png'}
	local match30 = {bonus_name='twenty', rule_name='ten', start_time='10:00', ante=20000, png_name='wenzi_20yuansai.png'}
	local match31 = {bonus_name='thirty', rule_name='ten', start_time='11:00', ante=30000, png_name='wenzi_30yuansai.png'}
	table.insert(data.match_list, match10)
	table.insert(data.match_list, match11)
	table.insert(data.match_list, match30)
	table.insert(data.match_list, match31)
	
	return data
end

TelephoneChargeUtil.get_test_data2 = function()
	local data = {}
	data.rule_info = {}
	data.rule_info.ten = '1.每场比赛30-300人，时间为15分钟，在规\n'..
					   '定的时间赢豆最多的玩家获得胜利，获得相\n'..
					   '应话费奖励。\n'..
					   '2.所有的虚拟奖品实时到账，用户可在排行\n'..
					   '中的话费排行查看中奖情况与金额，话费达\n'..
					   '到20元的整数倍即可提现。'
	data.bonus_info = {}
	data.bonus_info.ten = '第一名  10元\n'..
					 '第二名   5元\n'..
					 '第三名   3元\n'..
					 '第四至第六名   20000豆\n'..
					 '第七至第十名   10000豆'
	data.bonus_info.twenty = '第一名  20元\n'..
					 '第二名   10元\n'..
					 '第三名   6元\n'..
					 '第四至第六名   40000豆\n'..
					 '第七至第十名   20000豆'
	data.bonus_info.thirty = '第一名  30元\n'..
					 	'第二名   15元\n'..
					 	'第三名   9元\n'..
					 	'第四至第六名   60000豆\n'..
					 	'第七至第十名   30000豆'
					 	
	data.match_list = {}
	local match10 = {bonus_name='ten', rule_name='ten', start_time='18:00', ante=10000, png_name='wenzi_10yuansai.png'}
	local match11 = {bonus_name='ten', rule_name='ten', start_time='19:00', ante=10000, png_name='wenzi_10yuansai.png'}
	local match30 = {bonus_name='twenty', rule_name='ten', start_time='20:00', ante=20000, png_name='wenzi_20yuansai.png'}
	local match31 = {bonus_name='thirty', rule_name='ten', start_time='21:00', ante=30000, png_name='wenzi_30yuansai.png'}
	table.insert(data.match_list, match10)
	table.insert(data.match_list, match11)
	table.insert(data.match_list, match30)
	table.insert(data.match_list, match31)
	
	return data
end