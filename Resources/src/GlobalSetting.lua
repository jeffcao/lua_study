local default_share  = "由老马工作室倾情推出的《我爱斗地主》上线啦！快来看看我们的新玩法吧！\n"
				   .."百万巨制，交友神器，和农民一起斗地主，我的地盘我做主。\n"
                   .."一切尽在《我爱斗地主》。\n"
                   .."（分享自@《我爱斗地主》官方网站）"

GlobalSetting = {
	-- 连接最大重连次数
	CONNECTION_MAX_RETRIES = 6,
	-- 连接超时时间
	CONNECTION_TIMEOUT = 20, 

	-- 最大登陆重试次数
	LOGIN_MAX_RETRIES = 6,
	-- 登陆重试时间间隔
	LOGIN_RETRY_TIMEFRAME = 2,
	
	-- 事件重发次数
	EVENT_MAX_RESEND = 5,
	-- 事件重发时间间隔
	EVENT_RESEND_TIMEFRAME = 5,
	
	-- ping pong 时间间隔， 通常是服务器的间隔＋10
	PING_PONG_TIMEFRAME = 40,
	
	-- 当前用户信息
	current_user = {},
	-- 游戏大厅的URLs
	hall_cur_message_box = {},
	show_init_player_info_box = 1,
	need_init_hall_rooms = 0,
	game_hall_urls = {},
	login_urls = {"ws://login.jc.170022.cn/websocket", "ws://login.test.170022.cn:8080/websocket", "ws://login.game.170022.cn/websocket", "ws://login.game-test.170022.cn/websocket"},
	local_url = nil, --this will be set by local config(if has), or be nil
	login_server_websocket = nil,
	
	cm_sim_card_prefix = "",
	hall_server_url = "",
--	hall_server_token = "",
	hall_server_websocket = nil,
	
	game_server_url = "",
	
	teach_msg = {},
	
	content_scale_factor = 1.0,
	
	debug_dump_websocket_raw = true,
	debug_dump_websocket_event = true,
	debug_dump_outgoing_event = false,
	debug_dump_internal_event = false,
	debug_timer_name = false,
	
	run_env = "test",
	
	app_id = "public_market_app",
	
	push_period = 10,
	
	blue_stroke = ccc3(0, 54, 67),
	
	green_stroke = ccc3(15, 39, 4),
	
	red_stroke = ccc3(61, 0, 9),
	
	light_blue_stroke = ccc3(7,49,64),

	black_stroke = ccc3(48, 48, 48),
	
	anniu_1_3_stroke = ccc3(0, 79, 146),
	anniu5_stroke = ccc3(0, 107, 5),
	anniu6_stroke = ccc3(0, 63, 107),

	zongse = ccc3(67,31,24),
	white = ccc3(255, 255, 255),
	
	rank_stroke = ccc3(39,13,0),
	
	restrict_interval = 20,--unit is s
	
	game_push_interval = 10,
	
	shouchong_finished = 0,
	shouchong_prop_id = nil,
	shouchong_rank_changed = false,
	shouchong_ordered = true,
	
	min_charge_get_limit = 20, -- server will pass this parameter and update this
	
	play_card_wait_time = 18,--play card wait time limit server will pass this parameter and update this
	
	
	company_name = {["1019"] = "XXX有限公司", ["1003"]="XXXxxx有限公司", default = "XXXSSSS有限公司"},
	login_bg = {["1019"] = {name="bg01_2.png",res="ccbResources/common3.plist"}},
	pay_type = {["1019"]="anzhi", ["1003"]="cmcc",default="cmcc"},

	sina_share_url = "",
	
	tencent_share_url = "",
	shop_prop_data = {},
	hall_scroll_view_moving = false,
	charge_hall_scroll_view_moving = false
}

local is_blank = function(str)
	return str == nil or str == ''
end
local user_default = CCUserDefault:sharedUserDefault()
local local_env = user_default:getStringForKey("env")
if not is_blank(local_env) then
	GlobalSetting.run_env = local_env
	print('run env is local env', local_env)
end
local local_url = user_default:getStringForKey("url")
if not is_blank(local_url) then
	GlobalSetting.local_url = local_url
	print("url is local url", local_url)
end
