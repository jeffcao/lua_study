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

	function theClass:initSocket(websocket, restore_name)
		self.ss_websocket = websocket
		self.ss_restore_name = restore_name
		self.ss_websocket.on_open = function() 
			if self.onSocketReopened then 
				self:restoreConnection()
				self:onSocketReopened() 
			end 
		end
		self.ss_websocket:bind("connection_closed", function(data) self:onSocketProblem(data, "connection_closed") end)
		self.ss_websocket:bind("connection_error", function(data) self:onSocketProblem(data, "connection_error") end)
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
		local event_data = {user_id = GlobalSetting.current_user.user_id, token = GlobalSetting.current_user.login_token, notify_id = self.ss_websocket:get_notify_id()}
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