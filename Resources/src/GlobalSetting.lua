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
	game_hall_urls = {},
	
	content_scale_factor = 1.0,
}

