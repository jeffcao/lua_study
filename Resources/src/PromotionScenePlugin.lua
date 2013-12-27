PromotionScenePlugin = {}

function PromotionScenePlugin.bind(theClass)
	function theClass:create_promotion_list(promotion_list)
		local t = ListViewPlugin.create_list_view(promotion_list,
			createPromotionItem, 'init_item', CCSizeMake(800,130), CCSizeMake(800,370))
		t:setPosition(CCPointMake(0,10))
		return t
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
		local list = self:create_promotion_list(data.match)
		self.layer:setContent(list)
		list:setPosition(ccp(0,35))
	end
	
	function theClass:on_promotion_list_fetch_fail(data)
		ToastPlugin.hide_progress_message_box()
		ToastPlugin.show_message_box(strings.psp_fetch_promotion_w)
		dump(data, 'on_promotion_list_fetch_fail')
	end
end