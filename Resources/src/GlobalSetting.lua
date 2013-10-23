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
	login_urls = {"ws://login.jc.170022.cn/websocket", "ws://login.test.170022.cn:8080/websocket", "ws://login.game.170022.cn/websocket"},
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
	
	run_env = "prod",
	

	zongse = ccc3(67,31,24),

	sina_share_url = "http://service.weibo.com/share/share.php?appkey=2045436852&title="..default_share.."&ralateUid=&language=zh_cn",
	
	tencent_share_url = "http://share.v.t.qq.com/index.php?c=share&a=index&appkey=801192940&title="..default_share

}

