require 'src.strings'
require 'src.ToastPlugin'
MatchLogic = {}

--room data info
--  can_join:true, false#是否可以报名当前场次
--  entry_fee#报名费用
--  match_ante#底注
--  is_in_match#此房间是否正在比赛
--  cur_match_seq#当前场次：如果当前有比赛进行，则为正在进行的比赛，没有则
--               #        为正在接受报名的比赛
--  next_match_seq#下一场可以报名的
--  room_type:1#普通，2#豆子，3#话费  #之前已有字段

--ui.join_match#报名比赛
--  request:{user_id=, match_seq=}
--
--  result_code:0#成功，其他#失败
--  joined_match:{seq1,seq2...}#成功时返回已报名的所有比赛场次
--  result_message:#失败时返回，直接显示
--  score:#扣除报名费用之后的豆子数
--  time:#比赛还有多久开始，单位为秒，假如为0代表比赛已开始

--ui.request_enter_room#进入房间 #之前已有接口
--  result_code新加7，代表房间不能进入

--登录请求接口返回值新增
--  joined_match:{seq1,seq2...}#已报名的所有比赛场次

--比赛房间信息变更通知
--  MATCH_P_NOTIFY_START = 20#notify_type:个人channel,比赛开始
--  MATCH_P_NOTIFY_END = 21#notify_type:个人channel,比赛结束
--  MATCH_G_NOTIFY_START = 22#notify_type:大厅全局channel,比赛开始
--  MATCH_G_NOTIFY_STOP_JOIN = 23#notify_type:大厅全局channel,比赛报名截至
--  MATCH_G_NOTIFY_END = 24#notify_type:大厅全局channel,比赛结束
--  bind("global_channel")--刷新数据，如果是在大厅界面，刷新房间列表
--    通知给所有人，比赛房间开始，报名截至，结束
--    在大厅里面需要绑定这个channel，游戏里面不需要绑定
--  bind(match_seq)--通知用户比赛状态，比赛开始提示用户，比赛结束把用户从游戏界面踢出
--    通知给已报名某场比赛的人，比赛房间已经开始，结束
--    room_id, match_seq, notify_type, content, title

function table.contains(t, item, compare_func)
	compare_func = compare_func or function(a,b) return a == b end
	for _,v in pairs(t) do
		if compare_func(v,item) then return true end
	end
	return false
end

--监听比赛房间事件
--  event_join_success
--    data:@{room data info}
--  global_match_change
--    data:@{room data info}
function MatchLogic.listen(event_name, func)
	if not MatchLogic.events_listener then MatchLogic.events_listener = {} end
	if not MatchLogic.events_listener[event_name] then MatchLogic.events_listener[event_name] = {} end
	table.insert(MatchLogic.events_listener[event_name], func)
end

--取消比赛房间事件监听
function MatchLogic.unlisten(event_name, func)
	if not MatchLogic.events_listener or not MatchLogic.events_listener[event_name] then return end
	for k,v in pairs(MatchLogic.events_listener[event_name]) do
		if v == func then
			MatchLogic.events_listener[event_name][k] = nil
		end
	end
end

function MatchLogic.clear()
	print('MatchLogic.clear()')
	MatchLogic.events_listener = {}
end

function MatchLogic.notify_event(event_name, data)
	if MatchLogic.events_listener[event_name] then
		for _,func in pairs(MatchLogic.events_listener[event_name]) do
			func(data)
		end
	end
end

function MatchLogic.has_joined_cur(data)
	local user = GlobalSetting.current_user
	dump(user.joined_match, 'user.joined_match')
	return table.contains(user.joined_match, data.cur_match_seq)
end

function MatchLogic.has_joined_next(data)
	local user = GlobalSetting.current_user
	return table.contains(user.joined_match, data.next_match_seq)
end

--是否已经报名当前房间的【当前场次或下一场次】
function MatchLogic.has_joined(data)
	local joined_cur_match = MatchLogic.has_joined_cur(data)
	local joined_next_match = MatchLogic.has_joined_next(data)
	return joined_cur_match or joined_next_match
end

--是否可以进入当前房间的当前比赛
function MatchLogic.can_enter_match(match)
	print(match.is_in_match, 'match.is_in_match')
	if not match.is_in_match then 
		return false 
	else
		print(MatchLogic.has_joined_cur(match), 'MatchLogic.has_joined_cur(match)')
		return MatchLogic.has_joined_cur(match)
	end
end

--获取当前房间【可以报名的】比赛序列号
function MatchLogic.get_join_match_seq(data)
	local can_join_id = nil
	if data.can_join and data.cur_match_seq then
		--可以报名当前场次
		can_join_id = data.cur_match_seq
	elseif data.next_match_seq then
		--只能报名下一场
		can_join_id = data.next_match_seq
	end
	return can_join_id
end

function MatchLogic.get_status_text(room_info)
	local text = '敬请期待'
	if MatchLogic.has_joined(room_info) then
		text = '已报名'
		if MatchLogic.can_enter_match(room_info) then text = '进入' end
	elseif not is_blank(MatchLogic.get_join_match_seq(room_info)) then
		text = '报名'
	end
	dump(room_info, 'room_info')
	dump(GlobalSetting.current_user.joined_match, 'GlobalSetting.current_user.joined_match')
	print('room text:', text)
	return text
end

function MatchLogic.on_global_match_status_change(data)
	MatchLogic.notify_event('global_match_change', data)
end

function MatchLogic.on_private_match_status_change(data)
	local event = 'private_match_start'
	if tonumber(data.notify_type) == 21 then
		event = 'private_match_end'
	end
	cclog('m_ channel event is %s', event)
	MatchLogic.notify_event(event, data)
end

function MatchLogic.on_match_room_click(data, enter_room_func)
	cclog('on_match_room_click')
	--未报名，进入报名流程，已报名，进入正常的进入房间流程
	local user = GlobalSetting.current_user
	local is_promotion = is_match_room(data)
	
	print('is_promotion:', is_promotion)
	print('has_joined:', MatchLogic.has_joined(data))
	print('can_enter_match:', MatchLogic.can_enter_match(data))
	
	--1.检查不是比赛房间，直接enter room
	if not is_promotion then enter_room_func() return end
	
	--2.如果没有报名当前房间，则进入报名流程
	if not MatchLogic.has_joined(data) then
		MatchLogic.join_match(data, enter_room_func)
		return
	end
	
	--3.如果已报名当前房间，查看报名的比赛是否已开始，已开始则进入，没开始，提示比赛尚未开始
	if MatchLogic.can_enter_match(data) then
		print('enter_room_func()')
		enter_room_func()
	else
		print('ToastPlugin.show_message_box(strings.ml_match_waiting_w)')
		ToastPlugin.show_message_box(strings.ml_match_waiting_w)
	end
end

--弹出豆子购买框
function MatchLogic.beans_promotion()
	cclog('join match beans is not enough')
	--ToastPlugin.show_message_box('豆子不够')
	PurchasePlugin.suggest_buy('douzi')
end

function MatchLogic.join_match(data, enter_room_func)
	local user = GlobalSetting.current_user
	
	--检查是否可以报名
	local can_join_id = MatchLogic.get_join_match_seq(data)
	if is_blank(can_join_id) then
		ToastPlugin.show_message_box('当前没有比赛')--TODO
		return
	end
	
	--检查豆子是否足够
	if tonumber(user.score) < tonumber(data.entry_fee) then
		--豆子不够，无法报名
		MatchLogic.beans_promotion()
	else
		MatchLogic.request_join_match(can_join_id, data, enter_room_func)
	end
end

--报名成功
function MatchLogic.on_join_match_success(data, match_data, enter_room_func)
	ToastPlugin.hide_progress_message_box()
	local user = GlobalSetting.current_user
	user.score = data.score
	user.joined_match = data.joined_match
	match_data.time = data.time
	--通知各监听器，比赛报名成功
	MatchLogic.notify_event('event_join_success', data)
	if tonumber(data.time) <= 0 then
		--比赛已开始
		--MatchLogic.request_enter_match(match_data)
		enter_room_func()
	else
		MatchLogic.deploy_match_alarm(tonumber(data.time))
	end
end

function MatchLogic.request_join_match(match_seq, match_data, enter_room_func)
	if not GlobalSetting.hall_server_websocket then return end
	local user = GlobalSetting.current_user
	local e_data = {user_id=user.user_id, match_seq=match_seq}
	local suc_func = function(data) MatchLogic.on_join_match_success(data, match_data, enter_room_func) end
	local fail_func = function(data) 
		ToastPlugin.hide_progress_message_box()
		data = data or {}
		dump(data, 'ui.join_match fail')
		ToastPlugin.show_message_box(data.result_message or strings.ml_join_fail_w)
	end
	ToastPlugin.show_progress_message_box(strings.ml_joining)
	GlobalSetting.hall_server_websocket:trigger('ui.join_match', e_data, suc_func, fail_func)
end

function MatchLogic.deploy_match_alarm(time_to_wait)
	local jni_helper = DDZJniHelper:create()
	jni_helper:messageJava("on_deploy_alarm_"..tostring(time_to_wait))
end

--登录的时候，给user设置已加入的比赛，必须要在user已经设置好之后再调用这个方法
function MatchLogic.parse_match_joined_when_login(data)
	local user = GlobalSetting.current_user
	if user then user.joined_match = data.joined_match end
end

function MatchLogic.create_match_channel(ws, name)
	if name ~= 'global_channel' then name = 'm_' .. name end
	local channel = ws:subscribe(name)
	cclog('create match channel[%s]:%s', tostring(name), tostring(channel))
	channel:bind("ui.routine_notify", function(data)
		dump(data, 'on match channel routine notify')
		local type = tonumber(data.notify_type)
		if table.contains({20,21}, type) then
			cclog('MatchLogic.on_private_match_status_change')
			MatchLogic.on_private_match_status_change(data)
		elseif table.contains({22,23,24}, type) then
			cclog('MatchLogic.on_global_match_status_change')
			MatchLogic.on_global_match_status_change(data)
		end
	end)
	return channel
end

function MatchLogic.bind_match_channels(scene, ws, bind_global)
	local user = GlobalSetting.current_user
	if not scene.match_channels then scene.match_channels = {} end
	if bind_global and not scene.match_channels.global_channel then
		scene.match_channels.global_channel = MatchLogic.create_match_channel(ws, "global_channel")
	end
	if not user.joined_match then return end
	--把没有绑定的channel绑定起来
	dump(user.joined_match, 'user.joined_match')
	for _,match_seq in pairs(user.joined_match) do
		match_seq = tostring(match_seq)
		if not scene.match_channels[match_seq] then
			scene.match_channels[match_seq] = MatchLogic.create_match_channel(ws, match_seq)
		end
	end
	--去掉已经不存在的channel
	for match_seq,_ in pairs(scene.match_channels) do
		if not table.contains(user.joined_match, match_seq) and match_seq ~= 'global_channel' then
			ws.channels[match_seq] = nil
			scene.match_channels[match_seq] = nil
		end
	end
end