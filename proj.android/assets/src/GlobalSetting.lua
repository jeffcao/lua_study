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
	EVENT_RESEND_TIMEFRAME = 2,
	
	-- ping pong 时间间隔， 通常是服务器的间隔＋10
	PING_PONG_TIMEFRAME = 40,
	
	-- 当前用户信息
	current_user = {},
	-- 游戏大厅的URLs
	show_init_player_info_box = 1,
	need_init_hall_rooms = 0,
	game_hall_urls = {},
	login_urls = {"ws://login.jc.170022.cn/websocket", "ws://login.test.170022.cn:8080/websocket"},
	login_server_websocket = nil,
	
	hall_server_url = "",
--	hall_server_token = "",
	hall_server_websocket = nil,
	
	game_server_url = "",
	
	content_scale_factor = 1.0,
	
	debug_dump_websocket_raw = true,
	debug_dump_websocket_event = true,
	debug_dump_outgoing_event = true,
	debug_dump_internal_event = false,
}

