GAlarmPlugin = {}

function GAlarmPlugin.bind(theClass)

	function theClass:onAlarmTick(callbackFunc) 
		local current_tick = self.alarm_tick:getTag()
		current_tick = current_tick - 1
		self.alarm_tick:setString("" .. current_tick)
		self.alarm_tick:setTag(current_tick)
		
		if current_tick < 10 and current_tick > 5 then
			if current_tick == 9 then
				self.alarm_tick:setColor( ccc3(255,0,0))
			end
			if type(callbackFunc) == "function" then
				self:playCountdownEffect()
			end
		elseif current_tick <= 5 then
			if current_tick > 0 and type(callbackFunc) == "function" then
				self:playWarningEffect()
			end
			
			if current_tick <= 0 then
				if type(callbackFunc) == "function" then
					callbackFunc()
				end
				self:stopUserAlarm()
				return
			end
		end
		
		-- cc.log("[onAlarmTick] current_tick => " + current_tick)
		local seqAction = CCSequence:createWithTwoActions( CCDelayTime:create(1), 
			CCCallFunc:create(function() self:onAlarmTick(callbackFunc) end))
		seqAction:setTag(9000)
		-- cc.log("[onAlarmTick] start new tick count.")
		self.rootNode:runAction( seqAction )
	end
	
	function theClass:startAlarm(showPoint, tick_count, callbackFunc) 
		
		self:stopUserAlarm()
		
		self.alarm:setPosition(showPoint)
		self.alarm_tick:setString("" .. tick_count)
		self.alarm_tick:setTag(tick_count)
		self.alarm_tick:setColor(ccc3(0,0,0))	
		self.alarm:setVisible(true)
		self.alarm:getParent():reorderChild(self.alarm, self.ALARM_ORDER)
		local seqAction = CCSequence:createWithTwoActions( CCDelayTime:create(1), CCCallFunc:create(function()
			self:onAlarmTick(callbackFunc)
		end))
		seqAction:setTag(9000)
		self.rootNode:runAction( seqAction )
	end
		
	-----------------------------------------------------------------------------
	 -- 开始自己计时动作
	 ----------------------------------------------------------------------------
	function theClass:startSelfUserAlarm(tick_count, callbackFunc) 
		self:startAlarm( ccp(400,230), tick_count, callbackFunc )
	end
		
	-----------------------------------------------------------------------------
	 -- 停止计时动作
	 ----------------------------------------------------------------------------
	function theClass:stopUserAlarm() 
		cclog("[stopUserAlarm] stop.")
		self.alarm:setVisible(false)
		self.rootNode:stopActionByTag(9000)
	end
	
	-----------------------------------------------------------------------------
	 -- 开始前位玩家计时动作
	 ----------------------------------------------------------------------------
	function theClass:startPrevUserAlarm(tick_count, callbackFunc) 
		local callback = function()
			local id = self.prev_user.user_id
			cclog("player over time " .. id)
			self.g_WebSocket:trigger("g.player_timeout",{user_id = self.self_user.user_id, timeout_user_id = id})
			if callbackFunc then
				callbackFunc()
			end
		end
		self:startAlarm( ccp(154, 310), tick_count, callback )
	end
	
	-----------------------------------------------------------------------------
	 -- 开始下位玩家计时动作
	 ----------------------------------------------------------------------------
	function theClass:startNextUserAlarm(tick_count, callbackFunc) 
		local callback = function()
			local id = self.next_user.user_id
			cclog("player over time " .. id)
			self.g_WebSocket:trigger("g.player_timeout",{user_id = self.self_user.user_id, timeout_user_id = id})
			if callbackFunc then
				callbackFunc()
			end
		end
		self:startAlarm( ccp(650, 310), tick_count, callback )
	end
end