GPlayerUpdatePlugin = {}

function GPlayerUpdatePlugin.bind(theClass)
	function theClass:updatePlayers(player_list)
		if player_list then
			self:retrievePlayers(player_list)
		end
	
		self:updateReady()
		self:updateTuoguan()
		self:updatePlayerNames()
		self:updatePlayerStates()
		self:updatePlayerRoles()
		self:updatePlayerPokeCounts()
		self:updatePlayerAvatars()
		self:updatePlayerLevels()
	end
	
	function theClass:updatePlayerLevels()
		local info = nil
		if self.self_user then
			info = self.users[tostring(self.self_user.user_id)]
		end
		self:updatePlayerLevel(info, self.self_level_layer, self.self_level_sprite)
		
		info = nil
		if self.prev_user then
			info = self.users[tostring(self.prev_user.user_id)]
		end
		self:updatePlayerLevel(info, self.prev_level_layer, self.prev_level_sprite)
		
		info = nil
		if self.next_user then
			info = self.users[tostring(self.next_user.user_id)]
		end
		self:updatePlayerLevel(info, self.next_level_layer, self.next_level_sprite)
	end
	
	function theClass:updatePlayerLevel(info, player_level_layer, player_level_sprite)
		if info and info.game_level then
			player_level_layer:setVisible(true)
			set_level_sprite(player_level_sprite, info.game_level)
		else
			player_level_layer:setVisible(false)
		end
 	end

	function theClass:updateTuoguan()
		if self.self_user and self.self_user.tuo_guan == 1 and self.self_user.poke_card_count > 0 then
			cclog("is tuoguan status")
			if not self.menu_tuoguan:isVisible() then
				cclog("show tuoguan")
				self.menu_tuoguan:setVisible(true)
			end
	 	else 
			dump(self.menu_tuoguan, "is not tuoguan status")
			if self.menu_tuoguan:isVisible() then
				cclog("hide tuoguan")
				self.menu_tuoguan:setVisible(false)
			end
		end
	end
	
	function theClass:updatePlayerNames()
		self:updatePlayerName(self.self_user, self.self_user_name)
		self:updatePlayerName(self.prev_user, self.prev_user_name)
		self:updatePlayerName(self.next_user, self.next_user_name)
	end
	
	function theClass:updatePlayerName(player, player_name_ui)
		if player then
			local player_name = player.nick_name
			player_name_ui:setString(player_name)
		else
			player_name_ui:setString("")
		end
 	end
	
	function theClass:updatePlayerStates()
		self:updatePlayerState(self.self_user, self.self_user_state)
		self:updatePlayerState(self.prev_user, self.prev_user_state)
		self:updatePlayerState(self.next_user, self.next_user_state)
		
		self:updatePlayerPrepare(self.self_user, self.self_user_prepare)
		self:updatePlayerPrepare(self.prev_user, self.prev_user_prepare)
		self:updatePlayerPrepare(self.next_user, self.next_user_prepare)
	end
	
	function theClass:updatePlayerState(player, player_state_ui)
		if player then
			--表明是服务器自动帮忙准备的
			if player == self_user and player.state ==1 and self.menu_ready:isVisible() then
				self.menu_ready:setVisible(false)
				self.menu_huanzhuo:setVisible(false)
				self:stopUserAlarm()
			end
			if game_over_layer and game_over_layer:isVisible() and player == self_user and player.state == 1 then
				cclog("服务器自动准备，要隐藏游戏结束对话框，并reset所有的牌")
				self.game_over_layer:setVisible(false)
				self:reset_all()
				local x = self.alarm:getPositionX()
				local y = self.alarm:getPositionY()
				cclog("alarm position:(" .. x .. ", " .. y .. ")")
				if self.alarm:isVisible() and x == 200 and y == 100 then
					cclog("stop user alarm")
					self:stopUserAlarm()
				end
			end
		
		end			
	end
	
	function theClass:updatePlayerPrepare(player, player_ui)
		if player and player.state ==1 and player.poke_card_count == 0 then
			player_ui:setVisible(true)
		elseif player_ui:isVisible() then
			player_ui:setVisible(false)
		end
	end
	
	function theClass:updatePlayerRoles()
		self:updatePlayerRole(self.self_user, self.self_user_role, true)
		self:updatePlayerRole(self.prev_user, self.prev_user_role, true) 
		self:updatePlayerRole(self.next_user, self.next_user_role, false)
	end
	
	function theClass:updatePlayerRole(player, role_ui, flip_x)
		if not (player and player.player_role and player.player_role >= self.ROLE_FARMER) then
			role_ui:setVisible(false)
			return
		end
		
		cclog("[updatePlayerRole] player.player_role => " .. player.player_role)
		
		local farmerFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("youxizhong2/yxz2-xiaotu/yxz2-pingmin.png")
		local lordFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("youxizhong2/yxz2-xiaotu/yxz2-dizhu2.png")
		
		if player.player_role == self.ROLE_FARMER then
			role_ui:setDisplayFrame(farmerFrame)
		else 
			role_ui:setDisplayFrame(lordFrame)
		end
	
		role_ui:setScale(GlobalSetting.content_scale_factor)
		role_ui:setAnchorPoint(ccp(0, 0.5)) 	
		if player.player_role == self.ROLE_FARMER then
			role_ui:setFlipX(flip_x)
		end
		role_ui:setVisible(true)
	end
	
	function theClass:updatePlayerPokeCounts()
		self:updatePlayerPokeCount(self.self_user, self.self_user_poke_count, self.self_user_card_tag)
		self:updatePlayerPokeCount(self.prev_user, self.prev_user_poke_count, self.prev_user_card_tag)
		self:updatePlayerPokeCount(self.next_user, self.next_user_poke_count, self.next_user_card_tag)
	end
	
	function theClass:updatePlayerPokeCount(player, player_poke_count_ui, player_card_tag_ui)
		if player and player.poke_card_count > 0 then
			if not player_card_tag_ui:isVisible() then
				player_card_tag_ui:setVisible(true)
			end
			player_poke_count_ui:setString( "" .. player.poke_card_count )
		else
			if player_card_tag_ui:isVisible() then
				player_card_tag_ui:setVisible(false)
			end
			player_poke_count_ui:setString( "" )
		end			
	end
	
	function theClass:updatePlayerAvatars()
		self:updatePlayerAvatar(self.self_user, self.self_user_avatar, self.self_user_avatar_bg)
		self:updatePlayerAvatar(self.prev_user, self.prev_user_avatar, self.prev_user_avatar_bg)
		self:updatePlayerAvatar(self.next_user, self.next_user_avatar, self.next_user_avatar_bg)
	end
	
	function theClass:updatePlayerAvatar(player, player_avatar_ui, player_avatar_bg)
		local avatarFrame = nil
		if not player then
			-- if player_avatar_bg:isVisible() then
			-- 	player_avatar_bg:setVisible(false)
			-- end
			if player_avatar_ui:isVisible() then
				player_avatar_ui:setVisible(false)
			end
		else
			if not player_avatar_ui:isVisible() then
				player_avatar_ui:setVisible(true)
			end
			-- if not player_avatar_bg:isVisible() then
			-- 	player_avatar_bg:setVisible(true)
			-- end
			avatarFrame = Avatar.getUserAvatarFrame(player)
			player_avatar_ui:setNormalSpriteFrame(avatarFrame)
			player_avatar_ui:setSelectedSpriteFrame(avatarFrame)
		end
	end
	
	
	--------------------------------------------------------------------------
	-- 显示不出标签 参数： buchu_ui 显示不出图片的UI控件 bBuchu True 显示 False 隐藏
	--------------------------------------------------------------------------
	function theClass:updatePlayerBuchu(buchu_ui, bBuchu) 
		if not bBuchu then
			buchu_ui:setVisible(false)
			return
		end
		
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		buchu_ui:setDisplayFrame(frameCache:spriteFrameByName("info_buchu.png"))
		buchu_ui:setVisible(true)
	end
	
	function theClass:isTuoguan() 
		return self.menu_tuoguan:isVisible()
	end
	

end