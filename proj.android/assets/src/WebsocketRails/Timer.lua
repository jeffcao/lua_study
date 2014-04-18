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
function Timer.add_timer(delay_secs, fn, timer_name)
	if Timer.scheduler == nil then
		print("**ERROR: Timer.scheduler has not been initialized.")
		return false
	end
	local debug_timer_name = timer_name
	if debug_timer_name == nil and GlobalSetting.debug_timer_name then
	    local traceback = string.split(debug.traceback("", 2), "\n")
    	debug_timer_name = string.trim(traceback[3])
	end
	
	local schedule_handler = 0
	timer_callback = function()
		Timer.scheduler:unscheduleScriptEntry(schedule_handler)
		if debug_timer_name then
			print("trigger timer fn =>[" .. debug_timer_name .."]")
		end
		fn()
	end
	
	schedule_handler = Timer.scheduler:scheduleScriptFunc(timer_callback, delay_secs, false)
	
	return schedule_handler	
end

function Timer.add_repeat_timer(period, fn, timer_name)
	if Timer.scheduler == nil then
		print("**ERROR: Timer.scheduler has not been initialized.")
		return false
	end
	
	local debug_timer_name = timer_name
	if debug_timer_name == nil and GlobalSetting.debug_timer_name then
	    local traceback = string.split(debug.traceback("", 2), "\n")
    	debug_timer_name = string.trim(traceback[3])
	end
	
	local schedule_handler = 0
	timer_callback = function()
		if not fn() then
			Timer.scheduler:unscheduleScriptEntry(schedule_handler)
			if debug_timer_name then
				print("trigger timer fn =>[" .. debug_timer_name .."]")
			end
		end
	end
	
	schedule_handler = Timer.scheduler:scheduleScriptFunc(timer_callback, period, false)
	
	return schedule_handler	
end

function Timer.cancel_timer(handle)
	Timer.scheduler:unscheduleScriptEntry(handle)
end
