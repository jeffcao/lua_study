HallMatchPlugin = {}
require 'YesNoDialog'
function HallMatchPlugin.bind(theClass)
	function theClass:listen_match_event()
		MatchLogic.listen('event_join_success', __bind(self.on_join_success, self))
		MatchLogic.listen('global_match_change', __bind(self.on_global_match_change, self))
		MatchLogic.listen('private_match_start', __bind(self.on_private_match_start, self))
		MatchLogic.listen('private_match_end', __bind(self.on_private_match_end, self))
	end
	
	--room_id, match_seq, notify_type, content, title
	function theClass:on_private_match_start(data)
		local scene = runningscene()
		local dialog = createYesNoDialog(scene.rootNode)
		dialog:setMessage('比赛已开始，是否进入')--TODO
		dialog:setYesButton(function() 
			for _,room in pairs(self.room_datas) do
				if tonumber(room.room_id) == tonumber(data.room_id) then
					self:do_on_room_touched(room)
					self:dismiss()
				end
			end
		end)
		dialog:show()
	end
	
	function theClass:on_private_match_end(data)
		dump(data,'hall scene listen on_private_match_end')
	end
	
	function theClass:on_global_match_change(room_info)
		local room_id = tonumber(room_info.room_id)
		if not self.room_datas then return end
		for _,room in pairs(self.room_datas) do
			if tonumber(room.room_id) == room_id then
				for k,v in pairs(room_info) do
					room[k] = v
				end
			end
		end
		self.room_layer_t:reloadData()
	end
	
	function theClass:on_join_success(room_info)
		self:refresh_room_list()
		self:update_player_beans_with_gl()
		MatchLogic.bind_match_channels(self, GlobalSetting.hall_server_websocket, true)
	end
	
	function theClass:refresh_room_list()
		if self.room_layer_t then self.room_layer_t:reloadData() end
	end
	
end