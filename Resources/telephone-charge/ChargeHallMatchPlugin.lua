ChargeHallMatchPlugin = {}

function ChargeHallMatchPlugin.bind(theClass)

	function theClass:listen_match_event()
		MatchLogic.listen('global_match_change', self.get_charge_room_from_server)
	end
	
	function theClass:unlisten_match_event()
		MatchLogic.listen('global_match_change', self.get_charge_room_from_server)
	end
	
	function theClass:get_charge_room_from_server()
		local hall_scene = runningscene()
		hall_scene.after_trigger_success = function(data)
			local data_proxy = DataProxy.get_exist_instance('charge_matches')
			data_proxy:set_data(TelephoneChargeUtil.get_test_data2())
		end
		hall_scene:get_charge_matches()
	end
end