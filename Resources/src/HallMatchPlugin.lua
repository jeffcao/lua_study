HallMatchPlugin = {}
require 'YesNoDialog'
function HallMatchPlugin.bind(theClass)
	function theClass:listen_match_event()
		MatchLogic.clear()
		print('bind_match_channels by listen_match_event')
		MatchLogic.bind_match_channels(self, GlobalSetting.hall_server_websocket, true)
		MatchLogic.listen('event_join_success', __bind(self.on_join_success, self))
		MatchLogic.listen('global_match_change', __bind(self.on_global_match_change, self))
		MatchLogic.listen('private_match_start', __bind(self.on_private_match_start, self))
		MatchLogic.listen('private_match_end', __bind(self.on_private_match_end, self))
	end
	
	--room_id, match_seq, notify_type, content, title
	function theClass:on_private_match_start(data)
		local scene = runningscene()
		local dialog = createYesNoDialog(scene.rootNode)
		dialog:setTitle('温馨提示')
		dialog:setMessage(strings.hmp_match_begin)
		dialog:setYesButton(function() 
			for _,room in pairs(self.room_datas.room) do
				if tonumber(room.room_id) == tonumber(data.room_id) then
					dialog:dismiss()
					
					--set is_match to true to diff from real match room and
					--match game
					room.is_match = true
					self:do_on_room_touched(room)
				end
			end
		end)
		dialog:show()
	end
	
	function theClass:on_private_match_end(data)
		dump(data,'hall scene listen on_private_match_end')
	end
	
	function theClass:on_global_match_change(room_info)
		if not GlobalSetting.hall_scene then
			print("HallScene:onEnter,GlobalSetting.hall_scene is nil.")
		end
		if GlobalSetting.hall_scene then
			print('refresh hall room data on_global_match_change')
			GlobalSetting.hall_scene:refresh_room_data()
		end
	end
	
	function theClass:on_join_success(room_info)
		self:refresh_room_list()
		self:update_player_beans_with_gl()
		print('bind_match_channels by on_join_success')
		MatchLogic.bind_match_channels(self, GlobalSetting.hall_server_websocket, true)
		if tonumber(room_info.time) > 0 then
			ToastPlugin.show_message_box_suc(strings.hmp_join_s)
		end
	end
	
	function theClass:refresh_room_list()
		if self.room_layer_scrollview then self:refresh_room_data() end
	end
	
end