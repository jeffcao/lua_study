PromotionScenePlugin = {}

function PromotionScenePlugin.bind(theClass)
	function theClass:create_promotion_list(promotion_list)
		if promotion_list == nil then
			return
		end

		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(800,130)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					a3 = createPromotionItem()
					print("[PromotionScenePlugin.create_promotion_list] a1 =>"..a1)
					a3:init_item(promotion_list[a1+1])
					a2:addChild(a3, 0, 1)
				else
					local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
					a3:init_item(promotion_list[a1 + 1])
				end
				r = a2
			elseif fn == "numberOfCells" then
				r = #promotion_list
			elseif fn == "cellTouched" then
			end
			return r
		end)
		local t = LuaTableView:createWithHandler(h, CCSizeMake(800,370))
		t:setPosition(CCPointMake(0,10))
		
		for index=#(promotion_list), 1, -1 do
			t:updateCellAtIndex(index-1)
		end
		
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
		local s = data.match[1]
		for index=1,15 do table.insert(data.match, s) end
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