GDataPlugin = {}

function GDataPlugin.bind(theClass) 

	function theClass:initData()
	--[[
		self.self_user_name = tolua.cast(self.self_user_name, "CCLabelTTF")
		self.prev_user_name = tolua.cast(self.prev_user_name, "CCLabelTTF")
		self.next_user_name = tolua.cast(self.next_user_name, "CCLabelTTF")
		self.self_user_poke_count = tolua.cast(self.self_user_poke_count, "CCLabelTTF")
		self.prev_user_poke_count = tolua.cast(self.prev_user_poke_count, "CCLabelTTF")
		self.next_user_poke_count = tolua.cast(self.next_user_poke_count, "CCLabelTTF")
		
		self.self_user_lord_value = tolua.cast(self.self_user_lord_value, "CCSprite")
		self.prev_user_lord_value = tolua.cast(self.prev_user_lord_value, "CCSprite")
		self.next_user_lord_value = tolua.cast(self.next_user_lord_value, "CCSprite")
		]]
	
		self.winSize = CCDirector:sharedDirector():getWinSize()
		PokeCard.sharedPokeCard(self.rootNode)
		print(g_shared_cards, #g_shared_cards)
		self.cardContentSize = g_shared_cards[1].card_sprite:getContentSize()
	end

	function theClass:retrievePlayers(player_list)
		self.self_user = nil
		self.prev_user = nil
		self.next_user = nil
		
		if #player_list > 1 then
			if player_list[1].user_id == self.g_user_id then
				self.self_user = player_list[1]
				self.next_user = player_list[2]
				if #player_list > 2 then
					self.prev_user = player_list[3]
				else
					self.prev_user = nil
				end
			elseif player_list[2].user_id == self.g_user_id then
				self.self_user = player_list[2]
				self.prev_user = player_list[1]
				if #player_list > 2 then
					self.next_user = player_list[3]
				else
					self.next_user = nil
				end
			elseif #player_list > 2 and player_list[3].user_id == self.g_user_id then
				self.self_user = player_list[3]
				self.prev_user = player_list[2]
				self.next_user = player_list[1]
			
			end
		else
			self.prev_user = nil
			self.next_user = nil
			self.self_user = player_list[1]
		end
		
		for index, _ in pairs(player_list) do
			local player = player_list[index]
		--TODO_LUA	self:doGetUserProfileIfNeed(player.user_id)
		end
		
	end
end