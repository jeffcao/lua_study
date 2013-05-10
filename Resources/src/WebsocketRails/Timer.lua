Timer = {}

--function Timer.add_timer(delay_secs, fn)
--	if type(Timer.timer_delegator) ~= "function" then
--		print("**ERROR: Timer.timer_delegator is not a function, it must be initialized before use.")
--		return false
--	end
--	
--	return Timer.timer_delegator(delay_sec, fn)
--end
--
function Timer.add_timer(delay_secs, fn)
	if Timer.scheduler == nil then
		print("**ERROR: Timer.scheduler has not been initialized.")
		return false
	end
	
	local schedule_handler = 0
	timer_callback = function()
		Timer.scheduler:unscheduleScriptEntry(schedule_handler)
		fn()
	end
	
	schedule_handler = Timer.scheduler:scheduleScriptFunc(timer_callback, delay_secs, false)
	
	return schedule_handler	
end

function Timer.add_repeat_timer(period, fn)
	if Timer.scheduler == nil then
		print("**ERROR: Timer.scheduler has not been initialized.")
		return false
	end
	
	local schedule_handler = 0
	timer_callback = function()
		if not fn() then
			Timer.scheduler:unscheduleScriptEntry(schedule_handler)
		end
	end
	
	schedule_handler = Timer.scheduler:scheduleScriptFunc(timer_callback, period, false)
	
	return schedule_handler	
end

function Timer.cancel_timer(handle)
	Timer.scheduler:unscheduleScriptEntry(handle)
end
