require 'src.SocketStatePlugin'
require 'src.MarqueePlugin'
GamePush = {}
SocketStatePlugin.bind(GamePush)

function GamePush:cancel_fetch_hdlr()
	if self.fetch_hdlr then
		Timer.cancel_timer(self.fetch_hdlr)
	end
end

function GamePush:on_fetch_msg(data)
	CCUserDefault:sharedUserDefault():setStringForKey("last_msg_seq", data.last_msg_seq)
	dump(data, '[GamePush]=>on fetch msg')
	if GlobalSetting.run_env == "test" then
		if #data.messages == 0 and math.random(10)>5 then
			table.insert(data.messages, {content = '测试走马灯第一条'..os.time()})
			local str = "测试走马灯第二条，测试走马灯在显示很长一段文字的时候会出现什么状况：if self.game_push_ws then self.game_push_ws:close() self.game_push_ws = nil end self:cancel_fetch_hdlr() GamePush.obj = nil"
			table.insert(data.messages, {content = '测试走马灯第二条'..os.time()})
			table.insert(data.messages, {loop = true, content = "测试走马灯，这是一条会一直循环展示的走马灯信息。"})
		end
	end
	
	for _,v in pairs(data.messages) do
		MarqueePlugin.marquee(v.content, v.loop)
	end
end

function GamePush:fetch_msg()
	print('[GamePush]=>fetch msg')
	local ws = self.game_push_ws
	if not ws then return false end
	if ws.state ~= 'connected' then
		print('state is not connect, do not fetch msg')
		return
	end
	local last_msg_seq = CCUserDefault:sharedUserDefault():getStringForKey("last_msg_seq") or "0"
	local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token,
		version = resource_version, run_env = GlobalSetting.run_env, last_msg_seq = last_msg_seq}
	local fail = function(data)
		dump(data, 'get_sys_msg fail')
	end
	ws:trigger("ui.get_sys_msg",  event_data, __bind(self.on_fetch_msg, self), fail)
	return true
end

function GamePush:on_check_success(data)
	dump(data, '[GamePush]=>game push on check success')
	self:initSocket(self.game_push_ws, "ui.restore_connection")-- to set socket restore logic
	NotificationProxy.registerScriptObserver(__bind(self.on_resume, self),"on_resume")-- to observe onResume() event
	NotificationProxy.registerScriptObserver(__bind(self.on_pause, self),"on_pause")-- to observe onPause() event
	local period = GlobalSetting.game_push_interval
	self:cancel_fetch_hdlr()
	self:fetch_msg()--fetch once
	self.fetch_hdlr = Timer.add_repeat_timer(period, __bind(self.fetch_msg, self), 'game_push')
end

function GamePush:on_check_fail(data)
	dump(data, 'game push on check fail')
	CheckSignLua:check_stoken(data)
end

function GamePush:check_connection_game_push()
	local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token,
		version = resource_version, run_env = GlobalSetting.run_env}
	CheckSignLua:fix_sign_param(event_data)
	self.game_push_ws:trigger("ui.check_connection",
	event_data, __bind(self.on_check_success, self), __bind(self.on_check_fail, self))
end

function GamePush:do_on_websocket_ready()
	print("[GamePush:do_on_websocket_ready]")
	self:check_connection_game_push()
end

function GamePush:on_websocket_ready()
	print("[GamePush:on_websocket_ready()]")
	self.game_push_ws:bind("ui.hand_shake", function(data)
		print('receive ui.hand_shake')
		dump(data, "ui.hand_shake")
		self.game_push_ws:unbind_clear("ui.hand_shake")
		CheckSignLua:generate_stoken(data)
		self:do_on_websocket_ready()
	end)
end

function GamePush:open_push()
	print("open push")
	local function connection_failure(data)
		print("[GamePush.connection_failure].")
		dump(data, "connection_failure data")
		if data.retry_excceed then
			print("[GamePush.connection_failure]  and end.")
			self.game_push_ws = nil
		else
			print("[GamePush.connection_failure]  try again.")
		end
	end

	if self.game_push_ws == nil then
		print("[GamePush.open_push()] game_push_ws is nil, init it.")
		local url = "ws://"..GlobalSetting.game_push_url.."/websocket"
		print('[GamePush] game push url is', url)
		self.game_push_ws = WebSocketRails:new(url, true)
		self.game_push_ws.on_open = __bind(self.on_websocket_ready, self)
		self.game_push_ws:bind("connection_error", connection_failure)
		self.game_push_ws:bind("connection_closed", connection_failure)
	end
end

function GamePush:close_push()
	print("[GamePush:close_push()]")
	if self.game_push_ws then
		self.game_push_ws:close()
		self.game_push_ws = nil
	end
	self:cancel_fetch_hdlr()
	GamePush.obj = nil
end

function GamePush:new()
	print("GamePush.new()")
	local this_obj = {}
    setmetatable(this_obj, self)
    self.__index = self
	return this_obj
end

function GamePush.open()
	if not GamePush.obj then
		print("GamePush.open()")
		GamePush.obj = GamePush:new()
		GamePush.obj:open_push()
	end
end

function GamePush.close()
	if GamePush.obj then
		print("GamePush.close()")
		GamePush.obj:close_push()
		GamePush.obj = nil
	end
end

function GamePush:updateSocket(status)
	print('GamePush update socket:', status)
end

--正在重连网络
function GamePush:onSocketReopening()
	local jni_helper = DDZJniHelper:create()
	local network_state = jni_helper:get("IsNetworkConnected")
	print("network_state=> ", network_state, string.len(network_state))
	network_state = string.sub(network_state, 1, 1)
	print("GamePush onSocketReopening")
	self:updateSocket("socket: reopening")
end

--网络已重新连接上
function GamePush:onSocketReopened()
	dump(self, "GamePush:onSocketReopened self is")
	print("before bind hand_shake")
	self.game_push_ws:bind("ui.hand_shake", function(data)
		dump(data, "ui.hand_shake of reopened socket")
		self.game_push_ws:unbind_clear("ui.hand_shake")
		CheckSignLua:generate_stoken(data)
		print("GamePush onSocketReopened")
		self:restoreConnection()
		self:updateSocket("socket: reopened, restoring")
	end)
	print("after bind hand_shake")
end

--网络重连失败
function GamePush:onSocketReopenFail()
	print("GamePush onSocketReopenFail")
end

--restore connection失败，退出游戏
function GamePush:onSocketRestoreFail()
	print("GamePush onSocketRestoreFail")
end

--restore connection成功
function GamePush:onSocketRestored(data)
	print("GamePush onSocketRestored")
	self:updateSocket("socket: restored")
end

-- activity onPause
function GamePush:on_pause()
	print("GamePush:on_pause")
	self:op_websocket(true)
end

-- activity onResume
function GamePush:on_resume()
	print("GamePush:on_resume")
	Timer.add_timer(2.5, function() self:op_websocket(false) end)
end

function GamePush:op_websocket(pause)
	print("GamePush:op_websocket")
	dump(self, "GamePush:op_websocet self is")
	self.game_push_ws:pause_event(pause)
end