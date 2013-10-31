GameOverPlugin = {}

function GameOverPlugin.bind(theClass)

	--名字不规范的地方是为了方便js代码直接转化过来，以后再更正
	function theClass:initWith(gaming_layer, data)
		self.gaming_layer = gaming_layer
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		frameCache:addSpriteFramesWithFile(Res.common3_plist)
		local game_result = data.game_result
		dump(game_result, "game_result")
		local win_flag = false
		local win_user = nil
		
		local lose_persons = 0
		
		local self_user_win_value = game_result.self_balance[tostring(gaming_layer.self_user.user_id)]
		self_user_win_value = tonumber(self_user_win_value)

		win_flag = self_user_win_value > 0
		if win_flag then
			self.lbl_self_user_win:setDisplayFrame(frameCache:spriteFrameByName("win.png"))
		--	gaming_layer:playWinEffect()
		else 
			cclog("self user is lose")
			lose_persons = lose_persons + 1
			self.lbl_self_user_win:setDisplayFrame(frameCache:spriteFrameByName("lose.png"))
		--	gaming_layer:playLoseEffect()
		end
		
		
		self.lbl_base:setString("" .. game_result.base)
		self.lbl_base_x:setString("" .. game_result.lord_value)
		self.lbl_bomb:setString("" .. (1+tonumber(game_result.bombs)))
		self.lbl_spring:setString("" .. (1+tonumber(game_result.spring)))
		self.lbl_anti_spring:setString("" .. (1+tonumber(game_result.anti_spring)))
		
		local self_name = gaming_layer.self_user.nick_name .. "[" .. gaming_layer.self_user.user_id .. "]"
		self.lbl_self_user_name:setString(self_name)
		self.lbl_self_user_win_value:setString("" ..  self_user_win_value)
		
		local next_balance = game_result.balance[tostring(gaming_layer.next_user.user_id)]
		local next_user_name = gaming_layer.next_user.nick_name .. "[" .. gaming_layer.next_user.user_id .. "]"
		self.lbl_next_user_name:setString(next_user_name)
		if next_balance <= 0 then
			cclog("next user is lose")
			lose_persons = lose_persons + 1
			self.next_user_win_flag:setDisplayFrame(frameCache:spriteFrameByName("shibai.png"))
		else
			self.next_user_win_flag:setDisplayFrame(frameCache:spriteFrameByName("shengli.png"))
		end
		self.lbl_next_user_win_value:setString("" .. next_balance)
		
		local prev_user_name = gaming_layer.prev_user.nick_name .. "[" .. gaming_layer.prev_user.user_id .. "]"
		local prev_balance = game_result.balance[tostring(gaming_layer.prev_user.user_id)]
		self.lbl_prev_user_name:setString(prev_user_name)
		if prev_balance <= 0 then
			lose_persons = lose_persons + 1
			cclog("prev user is lose")
			self.prev_user_win_flag:setDisplayFrame(frameCache:spriteFrameByName("shibai.png"))
		else
			self.prev_user_win_flag:setDisplayFrame(frameCache:spriteFrameByName("shengli.png"))
		end
		self.lbl_prev_user_win_value:setString("" .. prev_balance)
		
		if lose_persons == 1 then
			self.game_over_bg:setDisplayFrame(frameCache:spriteFrameByName("nongmingwin.png"))
		else 
			self.game_over_bg:setDisplayFrame(frameCache:spriteFrameByName("dizhuwin.png"))
		end
	
		local avatarFrame = Avatar.getUserAvatarFrame(gaming_layer.self_user)
		self.game_over_avatar:setDisplayFrame(avatarFrame)
		self.game_over_avatar:setScale(0.7 * GlobalSetting.content_scale_factor)
	end
	
	function theClass:onToHallClicked()
		self:doToHall()
	end
	
	function theClass:onChangeDeskClicked()
		self:doGameOverChangeDesk()
	end
	
	function theClass:onGameOverCloseClicked()
		self:doClose()
	end
	
	function theClass:doToHall()
		self.gaming_layer:exit()
	end
	
	function theClass:doGameOverChangeDesk()
		self.gaming_layer:doChangeDesk()
	end
	
	function theClass:doClose()
		self.gaming_layer:onReturn()
	end
end