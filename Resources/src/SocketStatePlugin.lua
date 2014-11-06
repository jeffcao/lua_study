SocketStatePlugin = {}

--self.onSocketReopened 网络已重新连接上会调用这个(仅仅socket连通，还需要restore connection)
--self.onSocketReopenFail 网络重连失败会调用这个
--self.onSocketReopening 正在重连网络会调用这个
--self.onSocketRestoreFail restore connection失败会调用这个
--self.onSocketRestored restore connection成功会调用这个(连接已经正常了)
-- onSocketReopening -> onSocketReopened        -> onSocketRestored     
--                   ||                         ||
--                   -> onSocketReopenFail      -> onSocketRestoreFail
function SocketStatePlugin.bind(theClass)

	function theClass:bind_server_kill(kill_event)
		kill_event = kill_event or "ui.ddz_socket_closed"
		local fn = function() 
			cclog("on server kill")
			if self.ss_websocket.state == 'closed' then
				cclog('on server kill, socket already closed')
				return
			end
			self.ss_websocket:close_when_server_kill() 
			self.ss_websocket._conn:on_close({})
		end
		for _, v in pairs(self.ss_websocket.channels) do
			v:bind(kill_event, fn)
		end
	end

	function theClass:initSocket(websocket, restore_name, kill_event)
		local this = self
		self.ss_websocket = websocket
		self.ss_restore_name = restore_name
		self.ss_websocket.on_open = function() 
			if this.onSocketReopened then 
				print('self.ss_websocket',this.ss_websocket)
				this:onSocketReopened(this.ss_websocket) 
			end 
		end
		self.ss_websocket:bind("connection_closed", function(data) 
			dump(this, 'connection_closed self')
			print('self.onSocketProblem', this.onSocketProblem)
			print('self.initSocket', this.initSocket)
			this:onSocketProblem(data, "connection_closed") 
		end)
		self.ss_websocket:bind("connection_error", function(data) this:onSocketProblem(data, "connection_error") end)
		self:bind_server_kill(kill_event)
	end
	
	function theClass:onSocketProblem(data, event_name)
		dump(data, "onSocketProblem:" .. event_name)
		if data.self_close then return end
		if data.retry_excceed then
			if self.onSocketReopenFail then
				self:onSocketReopenFail()
			end
		else
			if self.onSocketReopening then
				self:onSocketReopening()
			end
		end
	end

	--restore connection
	function theClass:restoreConnection()
		local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token, notify_id = self.ss_websocket:get_notify_id(), run_env = GlobalSetting.run_env, app_id = GlobalSetting.app_id}
		if GlobalSetting.game_id then
			event_data.game_id = GlobalSetting.game_id
		end

		local succ = function(data)
			if self.onSocketRestored then
				self:onSocketRestored(data)
			end
		end
		local fail = function()
			if self.onSocketRestoreFail then
				self:onSocketRestoreFail()
			end
		end
		self.ss_websocket:trigger(self.ss_restore_name, event_data, succ, fail)
	end

end