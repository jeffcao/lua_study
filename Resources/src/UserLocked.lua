UserLocked = {}

function UserLocked.bind(theClass)
	function theClass:check_locked(data)
		local is_locked = false
		
		--for condition of login
		if data.result_code and tonumber(data.result_code) == 401 then
			is_locked = true
		--for condition in hall or in gaming
		elseif data.notify_type and tonumber(data.notify_type) == 7 then
			is_locked = true
		end
		
		if not is_locked then
			print("device is not locked")
			return false
		end
		
		self:notify_locked(data)
		return true
	end
	
	function theClass:notify_locked(data)
		if not data.text then
			print("notify_locked, data.text is nil")
			return
		end
		if self.hide_progress_message_box and type(self.hide_progress_message_box) == "function" then
			self:hide_progress_message_box()
		end
		if self.show_server_notify and type(self.show_server_notify) == "function" then
			self:show_server_notify(data.text, 'warning')
		else
			print('notify_locked, scene has not show server notify function')
		end
	end
end