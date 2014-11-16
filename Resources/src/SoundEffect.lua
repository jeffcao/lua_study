SoundEffect = {}
SoundSettings = {sound_handler = nil, delay_sound_handler = nil}

function SoundEffect.bind(theClass)

	function theClass:playDealCardEffect()
		if not effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_pick_card)
	end

	function theClass:playButtonEffect()
		if not effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_music_button_click)
	end

	function theClass:playBombEffect()
		if not effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_boom)
		local effect_file = Res.s_effect_bomb_female
		SimpleAudioEngine:sharedEngine():playEffect(effect_file)
	end

	function theClass:playRocketEffect()
		if not effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/rocket_sound.mp3")
		
		local effect_file = Res.s_effect_rocket_female

		SimpleAudioEngine:sharedEngine():playEffect(effect_file)
	end

	function theClass:playCountdownEffect()
		if not effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/countdown_sound.mp3")
	end

	function theClass:playWarningEffect()
		if not effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/warn_sound.mp3")
	end

	function theClass:playLoseEffect()
		if not effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_lost)
	end

	function theClass:playWinEffect()
		if not effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_win)
	end
	
	function theClass:playBackgroundMusic()
		if not bg_music then return end
		local engine = SimpleAudioEngine:sharedEngine()
		if engine:isBackgroundMusicPlaying() then return end
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(Res.s_music_bg, true)
	end

	function theClass:playBackgroundMusicRandom()
		if not bg_music then return end
		if SoundSettings.sound_handler then return end
		local engine = SimpleAudioEngine:sharedEngine()
		if engine:isBackgroundMusicPlaying() then return end
		
		self:playOneBgMusic()
		
		local rep = function() 
	 		if not bg_music then 
	 			SoundSettings.sound_handler = nil
	 			return false 
	 		end
	 		if engine:isBackgroundMusicPlaying() then return true end
	 		if SoundSettings.delay_sound_handler then return true end
	 		local delay = function()
	 			SoundSettings.delay_sound_handler = nil
	 			if engine:isBackgroundMusicPlaying() then 
	 				return true 
	 			end
	 			self:playOneBgMusic()
	 		end
	 		SoundSettings.delay_sound_handler = Timer.add_timer(7, delay, "delay_bg_music")
	 		return true
	 	end	
	 	SoundSettings.sound_handler = Timer.add_repeat_timer(1, rep, "bg_music")
		--[[
		if  bg_music then
			self:stopBackgroundMusic()
			local rd = math.random(#Res.s_music_bg_arr)
			SimpleAudioEngine:sharedEngine():playBackgroundMusic(Res.s_music_bg_arr[rd], true)
		end
		]]
	end
	
	function theClass:playMarketMusic()
		if  bg_music then
			self:stopBackgroundMusic()
			SimpleAudioEngine:sharedEngine():playBackgroundMusic(Res.s_music_market_bg, true)
		end
	end
	
	function theClass:stopMarketMusic()
		self:stopBackgroundMusic()
	end
	
	function theClass:playOneBgMusic()
		local engine = SimpleAudioEngine:sharedEngine()
		local rd = math.random(#Res.s_music_bg_arr)
		engine:playBackgroundMusic(Res.s_music_bg_arr[rd], false)
	end

	function theClass:stopBackgroundMusic()
		if SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying() then
			SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
		end
	end

	function theClass:playDeliverCardsEffect()
		if not effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_deliver_poke_cards)
	end

	function theClass:playGrabLordEffect(lord_value)
		if not effect_music then
			return
		end
			
		local s_effect_file = Res.s_effect_grab_lord_path .. lord_value .. "_f.wav"
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		
	end

	function theClass:playSingleCardEffect(poke_value)
		if not effect_music then
			return
		end
		
		local s_effect_file = Res.s_effect_single_path .. "poke" .. poke_value .. "_f.wav"
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
	end

	function theClass:playPassEffect()
		if not effect_music then
			return
		end
		local n = math.random(3)
		local s_effect_file = Res.s_effect_pass_path .. "buyao" .. n .. "_f.wav"
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		
	end

	function theClass:playPairsEffect(poke_value)
		if not effect_music then
			return
		end
	
		local s_effect_file = Res.s_effect_pairs_path .. "dui" .. poke_value .. "_f.wav"
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		
	end

	function theClass:playCardTypeEffect(card_type)
		if not effect_music then
			return
		end
		
		local tmp_type = ""
		if card_type == CardType.THREE then
			tmp_type = "sange_"
		elseif card_type == CardType.THREE_WITH_ONE then
			tmp_type = "sandaiyi_"
		elseif card_type == CardType.THREE_WITH_PAIRS then
			tmp_type = "sandaiyidui_"
		elseif card_type == CardType.STRAIGHT then
			tmp_type = "shunzi_"
		elseif card_type == CardType.PAIRS_STRAIGHT then
			tmp_type = "liandui_"
		elseif card_type == CardType.PLANE or card_type == CardType.PLANE_WITH_WING or card_type == CardType.THREE_STRAIGHT then
			tmp_type = "feiji_"
		elseif card_type == CardType.FOUR_WITH_TWO then
			tmp_type = "sidaier_"
		elseif card_type == CardType.FOUR_WITH_TWO_PAIRS then
			tmp_type = "sidailiangdui_"
		end	
	
		if tmp_type ~= "" then
			local s_effect_file = Res.s_effect_card_type_path .. tmp_type .. "f.wav"
			SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		end
	end

	function theClass:playCardEffect(card)
		dump(card.owner, "playCardEffect")
		local card_type = card.card_type
		if card.card_type == CardType.NONE then
			self:playPassEffect()
		elseif card_type == CardType.BOMB then
			self:playBombEffect()
		elseif card_type == CardType.ROCKET then
			self:playRocketEffect()
		elseif card_type == CardType.SINGLE then
			self:playSingleCardEffect(card.max_poke_value)
		elseif card.card_type == CardType.PAIRS  then
			self:playPairsEffect(card.max_poke_value)
		else
			self:playCardTypeEffect(card.card_type)
		end
	end

	function theClass:playCardTips(card_count)
		if (not effect_music) or card_count > 2 or card_count < 1 then
			return
		end
		
		local s_effect_file = Res.s_effect_tips_path .. "baojing" .. card_count .. "_woman.wav"
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
	end
	
	
	function theClass:play_vip_voice(voice)
		cclog("play vip voice " .. voice)
		if not effect_music then return end
		local p = Res.s_music_vip .. voice
		SimpleAudioEngine:sharedEngine():playEffect(p)
	end
end