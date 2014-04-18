PromotionScenePlugin = {}
require 'src.MatchLogic'
require 'src.strings'

function PromotionScenePlugin.bind(theClass)

	function theClass:listen_match_event()
		self.match_change_listen_func = __bind(self.on_global_match_change, self)
		MatchLogic.listen('global_match_change', self.match_change_listen_func)
	end
	
	function theClass:unlisten_match_event()
		MatchLogic.unlisten('global_match_change', self.match_change_listen_func)
		self.match_change_listen_func = nil
	end
	
	function theClass:on_global_match_change(data)
		local room_id = tonumber(data.room_id)
		if not self.match_list then return end
		dump(self.match_list, 'self.match_list')
		for _,room in pairs(self.match_list) do
			if tonumber(room.room_id) == room_id then
				for k,v in pairs(room) do
					if data[k] ~= nil then
						room[k] = data[k]--只copy房间本身就有的值
					end
				end
			end
		end
		self.room_layer_t:reloadData()
	end
	
	function theClass:create_promotion_list(promotion_list)
		local t = ListViewPlugin.create_list_view(promotion_list,
			createPromotionItem, 'init_item', CCSizeMake(800,130), CCSizeMake(800,370),
			__bind(self.on_promotion_click, self))
		t:setPosition(CCPointMake(0,10))
		return t
	end
	
	function theClass:on_promotion_click(promotion)
		dump(promotion, 'on_promotion_click')
		promotion.room_type = promotion.match_type
		MatchLogic.on_match_room_click(promotion, function() 
 			if GlobalSetting.hall_scene then
 				GlobalSetting.hall_scene:on_private_match_start(promotion)
 			end
 		end)
	end
	
	function theClass:getPromotionList()
		ToastPlugin.show_progress_message_box(strings.psp_fetch_promotion)
		local event_data = {user_id = GlobalSetting.current_user.user_id}
		GlobalSetting.hall_server_websocket:trigger("ui.get_match_list", event_data,
			__bind(self.on_promotion_list_fetched, self),
			__bind(self.on_promotion_list_fetch_fail, self)
			)
	end
	
	function theClass:on_promotion_list_fetched(data)
		ToastPlugin.hide_progress_message_box()
		dump(data, 'on_promotion_list_fetched')
		if not data or not data.match or #data.match==0 then
			ToastPlugin.show_message_box(strings.psp_fetch_promotion_nil)
			return
		end
		--local s = data.match[1]
		--for index=1,15 do table.insert(data.match, s) end
		--for index=1,5 do table.insert(data.match, 'a') end
		self.match_list = data.match
		local list = self:create_promotion_list(data.match)
		self.room_layer_t = list
		self.layer:setContent(list)
		list:setPosition(ccp(0,35))
	end
	
	function theClass:on_promotion_list_fetch_fail(data)
		ToastPlugin.hide_progress_message_box()
		ToastPlugin.show_message_box(strings.psp_fetch_promotion_w)
		dump(data, 'on_promotion_list_fetch_fail')
	end
end