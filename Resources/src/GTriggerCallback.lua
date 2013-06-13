GTriggerCallback = {}

function GTriggerCallback.bind(theClass)
	function theClass:onEnterRoomSuccss(data) 
		g_WebSocket:clear_notify_id()
		dump(data, "[onEnterRoomSuccss] data => ")
		local game_info = data.game_info
		
		self:updatePlayers(data.players)
		self:init_channel(game_info)
		self.menu_ready:setVisible(true)
		self.menu_huanzhuo:setVisible(true)
		--local room_base = "底注: " .. String:addCommas(data.game_info.room_base) --TODO
		local room_base = "底注: " .. game_info.room_base
		self.dizhu:setString(room_base)
		self:startSelfUserAlarm(20, function() self:exit() end)
	end
end