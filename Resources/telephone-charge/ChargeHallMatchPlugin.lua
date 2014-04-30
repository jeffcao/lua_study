ChargeHallMatchPlugin = {}

function ChargeHallMatchPlugin.bind(theClass)

	function theClass:listen_match_event()
		print('ChargeHallMatchPlugin listen_match_event')
		self.get_charge_room_from_server_listener = function()
			self:get_charge_room_from_server('global_match_change')
		end
		self.get_charge_room_from_server_listener_on_join = function()
			self:get_charge_room_from_server('event_join_success')
		end
		
		MatchLogic.listen('global_match_change', self.get_charge_room_from_server_listener)
		MatchLogic.listen('event_join_success', self.get_charge_room_from_server_listener_on_join)
	end
	
	function theClass:unlisten_match_event()
		print('ChargeHallMatchPlugin unlisten_match_event')
		MatchLogic.unlisten('global_match_change', self.get_charge_room_from_server_listener)
		MatchLogic.unlisten('event_join_success', self.get_charge_room_from_server_listener_on_join)
	end
	
	function theClass:get_charge_room_from_server(event)
		print('get charge room on event:', event)
		if self.last_get_charge_time then
			local cur_time = os.time()
			local is_time_near = cur_time - self.last_get_charge_time == 0
			print('get_charge_room_from_server cur_time:'..cur_time)
			print('get_charge_room_from_server self.last_get_charge_time:'..self.last_get_charge_time)
			if is_time_near then 
				print('get_charge_room_from_server return because time is close')
				return 
			else
				print('get_charge_room_from_server not return because time is not close')
			end
		end
		self.last_get_charge_time = os.time()
		
		local hall_scene = runningscene()
		local suc_func = function(data)
			local data_proxy = DataProxy.get_exist_instance('charge_matches')
			data_proxy:set_data(data)
		end
		hall_scene:get_charge_matches(self.charge_room.room_id, suc_func)
	end
end