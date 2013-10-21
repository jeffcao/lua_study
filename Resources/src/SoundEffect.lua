SoundEffect = {}
SoundSettings = {effect_music = 1, bg_music = 1, sound_handler = nil, delay_sound_handler = nil}

function SoundEffect.bind(theClass)

	function theClass:playDealCardEffect()
		if not SoundSettings.effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_pick_card)
	end

	function theClass:playButtonEffect()
		if not SoundSettings.effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_music_button_click)
	end


	function theClass:playPlayCardEffect() 
		if not SoundSettings.effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/back_sendpoker.mp3")
	end

	function theClass:playStraightEffect()
		if not SoundSettings.effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/straight_sound.mp3")
	end

	function theClass:playBombEffect(male)
		if not SoundSettings.effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_boom)
		local effect_file = Res.s_effect_bomb_female
		if male then
			effect_file = Res.s_effect_bomb_male
		end
		SimpleAudioEngine:sharedEngine():playEffect(effect_file)
	end

	function theClass:playRocketEffect(male)
		if not SoundSettings.effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/rocket_sound.mp3")
		
		local effect_file = Res.s_effect_rocket_female
		if male then
			effect_file = Res.s_effect_rocket_male
		end
		SimpleAudioEngine:sharedEngine():playEffect(effect_file)
	end

	function theClass:playCountdownEffect()
		if not SoundSettings.effect_music then
			return
		end
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/countdown_sound.mp3")
	end

	function theClass:playWarningEffect()
		if not SoundSettings.effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect("res/Music/warn_sound.mp3")
	end

	function theClass:playLoseEffect()
		if not SoundSettings.effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_lost)
	end

	function theClass:playWinEffect()
		if not SoundSettings.effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_win)
	end

	function theClass:playBackgroundMusic()
		if not SoundSettings.bg_music then return end
		if SoundSettings.sound_handler then return end
		local engine = SimpleAudioEngine:sharedEngine()
		if engine:isBackgroundMusicPlaying() then return end
		
		self:playOneBgMusic()
		
		local rep = function() 
	 		if not SoundSettings.bg_music then 
	 			SoundSettings.sound_handler = nil
	 			return false 
	 		end
	 		if engine:isBackgroundMusicPlaying() then return true end
	 		if SoundSettings.delay_sound_handler then return true end
	 		local delay = function()
	 			self:playOneBgMusic()
	 			SoundSettings.delay_sound_handler = nil
	 		end
	 		SoundSettings.delay_sound_handler = Timer.add_timer(7, delay, "delay_bg_music")
	 		return true
	 	end	
	 	SoundSettings.sound_handler = Timer.add_repeat_timer(1, rep, "bg_music")
		--[[
		if  SoundSettings.bg_music then
			self:stopBackgroundMusic()
			local rd = math.random(#Res.s_music_bg_arr)
			SimpleAudioEngine:sharedEngine():playBackgroundMusic(Res.s_music_bg_arr[rd], true)
		end
		]]
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
		if not SoundSettings.effect_music then
			return
		end
		
		SimpleAudioEngine:sharedEngine():playEffect(Res.s_effect_deliver_poke_cards)
	end

	function theClass:playGrabLordEffect(lord_value, male)
		if not SoundSettings.effect_music then
			return
		end
			
		local s_effect_file = Res.s_effect_grab_lord_path .. lord_value .. "_m.wav"
		if not male then
			s_effect_file = Res.s_effect_grab_lord_path .. lord_value .. "_f.wav"
		end
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		
	end

	function theClass:playSingleCardEffect(poke_value, male)
		if not SoundSettings.effect_music then
			return
		end
		
		local s_effect_file = Res.s_effect_single_path .. "poke" .. poke_value .. "_m.wav"
		if not male then
			s_effect_file = Res.s_effect_single_path .. "poke" .. poke_value .. "_f.wav"
		end
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
	end

	function theClass:playPassEffect(male)
		if not SoundSettings.effect_music then
			return
		end
		local n = math.random(3)
		local s_effect_file = Res.s_effect_pass_path .. "buyao" .. n .. "_m.wav"
		if not male then
				s_effect_file = Res.s_effect_pass_path .. "buyao" .. n .. "_f.wav"
		end
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		
	end

	function theClass:playPairsEffect(poke_value, male)
		if not SoundSettings.effect_music then
			return
		end
	
		local s_effect_file = Res.s_effect_pairs_path .. "dui" .. poke_value .. "_m.wav"
		if not male then
					s_effect_file = Res.s_effect_pairs_path .. "dui" .. poke_value .. "_f.wav"
		end
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		
	end

	function theClass:playCardTypeEffect(card_type, male)
		if not SoundSettings.effect_music then
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
			local s_effect_file = Res.s_effect_card_type_path .. tmp_type .. "m.wav"
			if not male then
				s_effect_file = Res.s_effect_card_type_path .. tmp_type .. "f.wav"
			end
			SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
		end
	end

	function theClass:playCardEffect(card)
		dump(card.owner, "playCardEffect")
		local male = tonumber(card.owner.gender) == 1
		dump(male, "playCardEffect")
		local card_type = card.card_type
		if card.card_type == CardType.NONE then
			self:playPassEffect(male)
	--	elseif card_type == CardType.STRAIGHT then
	--		self:playStraightEffect()
		elseif card_type == CardType.BOMB then
			self:playBombEffect()
		elseif card_type == CardType.ROCKET then
			self:playRocketEffect()
		elseif card_type == CardType.SINGLE then
			self:playSingleCardEffect(card.max_poke_value, male)
		elseif card.card_type == CardType.PAIRS  then
			self:playPairsEffect(card.max_poke_value, male)
		else
			self:playCardTypeEffect(card.card_type, male)
		end
	end

	function theClass:playCardTips(card_count, male)
		if (not SoundSettings.effect_music) or card_count > 2 or card_count < 1 then
			return
		end
		
		local s_effect_file = Res.s_effect_tips_path .. "baojing" .. card_count .. "_man.wav"
		if not male then
			s_effect_file = Res.s_effect_tips_path .. "baojing" .. card_count .. "_woman.wav"
		end
		SimpleAudioEngine:sharedEngine():playEffect(s_effect_file)
	end
	
	function theClass:playIntroduce(moment)
		if not SoundSettings.effect_music then return end
		local p = Res.s_music_introduce
		local sounds = {
		sign=p.."3.mp3",
		shop=p.."5.mp3",
		enter_room=p.."6.mp3",
		farmer=p.."8.mp3",
		lord=p.."7.mp3"
		}
		SimpleAudioEngine:sharedEngine():playEffect(sounds[moment])
	end
	
	function theClass:play_vip_voice(voice)
		cclog("play vip voice " .. voice)
		if not SoundSettings.effect_music then return end
		local p = Res.s_music_vip .. voice
		SimpleAudioEngine:sharedEngine():playEffect(p)
	end
end