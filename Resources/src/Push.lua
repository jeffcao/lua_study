Push = {}

function Push.bind(theClass)
	require "src/WebsocketRails/Timer"
	
	--functions use as interface
	function theClass:start_push()
		if not GlobalSetting.hall_server_websocket then
			return
		end
		if GlobalSetting.push_handler then
			return
		end
		
		local fn = function()
			if not GlobalSetting.hall_server_websocket then print("hall_server_websockt be nil") return false end
			if not GlobalSetting.push_handler then print("push_handler had been removed") return false end
			local event_data = {retry="0", time = GlobalSetting.message_time or 0}
			GlobalSetting.hall_server_websocket:trigger("ui.get_system_message", event_data,
			__bind(self.on_push_coming, self), function() end)
			return true
		end
		GlobalSetting.push_handler = Timer.add_repeat_timer(GlobalSetting.push_period, fn, "push")
		fn()
		
		if not GlobalSetting.hall_closed_lsnrs then GlobalSetting.hall_closed_lsnrs = {} end
		local rm = function()
			self:stop_push()
		end
		GlobalSetting.hall_closed_lsnrs["rm_push"] = nil
		GlobalSetting.hall_closed_lsnrs["rm_push"] = rm
	end
	
	function theClass:stop_push()
		if GlobalSetting.push_handler then
			Timer.cancel_timer(GlobalSetting.push_handler)
			GlobalSetting.push_handle = nil
		end
	end
	
	
	--functions only use in this file
	function theClass:on_push_coming(data)
		if not GlobalSetting.push_handler then 
			print("push_handler had been removed, do not process push message") 
			return false 
		end
		GlobalSetting.message_time = data.message_time
		if not data.system_message then return end
		local fns = {}
		fns["0"]= __bind(self.on_push_toast_message, self)
		fns["1"]= __bind(self.on_push_roll_message, self)
		fns["2"]= __bind(self.on_push_show_message, self)
		for _, message in pairs(data.system_message) do
			if fns[tostring(message.message_type)] then
				fns[tostring(message.message_type)](message.content)
			end
		end
	end
	
	function theClass:on_push_roll_message(content)
		self:toast("roll:"..content)
	end
	
	function theClass:on_push_toast_message(content)
		self:toast("toast:"..content)
	end
	
	function theClass:on_push_show_message(content)
		self:toast("show:"..content)
	end
	
	function theClass:toast(content)
		if self.show_server_notify then
			self:show_server_notify(content)
		end
	end
	
end