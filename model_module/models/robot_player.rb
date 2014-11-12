#encoding: utf-8

class RobotPlayer < Player
  def is_robot?
    true
  end


  def ready_timing(action_seq, timeout=nil, &block)
    # EventMachine.add_timer(Time.now.to_i%10) do
      block.call @player_info.user_id
    # end
  end

  def grab_lord_timing(action_seq, timeout=nil, &block)

    EventMachine::Timer.new(rand(1..2)) do
      block.call @player_info.user_id, grab_lord
    end

  end

  def grab_lord
    table = GameTable.get_game_table(@player_info.table_id, @player_info.room_id)
    players = table.get_players
    need_grab = true
    lord_value = 0
    real_player_count = 0
    pass_count = 0
    pass_user = []
    max_lord_value = 0
    Rails.logger.debug("robot_player_grab_lord_max_lord_value=>#{players.size}")
    players.each do |player|
      pass_user.push(player) if player.player_info.user_id !=@player_info.user_id
      pass_user.unshift(player) if player.player_info.user_id ==@player_info.user_id
      #unless player.is_robot?
      #  real_player_count = real_player_count + 1
      #end
      #if player.player_info.lord_value.to_i > 0
      #  need_grab = false
      #end
      #if player.player_info.lord_value.to_i > -1
      #  pass_count = pass_count + 1
      #end
      max_lord_value = max_lord_value>player.player_info.lord_value.to_i ? max_lord_value:player.player_info.lord_value.to_i
    end
    Rails.logger.debug("robot_player_grab_lord_max_lord_value=>#{max_lord_value}")


    lord_value = rand(1..3) if need_grab && pass_count > 1
    lord_value = rand(1..3) if need_grab && pass_count ==1 && real_player_count == 1
    lord_value = rand(0..2) if need_grab && pass_count == 0
    Rails.logger.debug("[grab_lord] robot grab lord, lord_value=>"+lord_value.to_s)
    lord_value
  end

  def play_card_timing(game_id, action_seq, last_user_id, last_poke_card=[], timeout=nil, &block)
    EventMachine::Timer.new(rand(1..2)) do
      block.call @player_info.user_id, play_card(last_user_id, last_poke_card)
    end
  end



  def release
    Rails.logger.debug("[release] release robot, user=>"+@player_info.user_id)
    user = User.find_by_user_id(@player_info.user_id)
    user.last_action_time = Time.now
    user.busy = 0
    user.save
  end

  def can_restore_connection?
    false
  end

  def is_connection_broken?
    true
  end

  def voice_props
    user_vip_level = @player_info.vip_level.to_i
    match_item_type = 9900+(user_vip_level -1)*10+1
    v_props = GameProductItem.where("item_type<=? and item_type=9900", match_item_type)
  end

  def playing_card_voice_props
    r_result = []
    return r_result if voice_props.nil?
    voice_props.each { |vp|
      if vp.using_point == "2-9"
        r_result.push({:id => vp.id, :text => vp.feature["text"], :voice => vp.feature["voice"]})
      end
    }
    r_result
  end

  def response_chat(response_voice, &block)
    user_vip_level = vip_level_activity
    match_item_type = 9900+(user_vip_level -1)*10
    if response_voice.item_type <= match_item_type
      EventMachine::add_timer(3) do
        response_voice.take_effect(player_info.user_id, {:is_robot=>true}, &block)
      end

    end
  end

  def chat_on_game_over(&block)

  end

  def after_grab_lord(next_user_id)

  end

  def after_play_card(next_user_id, last_user_id, poke_cards, &block)
    Rails.logger.debug("robot_play_card_voice_last_user_id=>#{last_user_id}")
    last_player = Player.get_player(last_user_id)

    if @player_info.poke_cards.size>0 and last_player.player_info.player_role.to_i != @player_info.player_role.to_i and
        poke_cards.size > 0
      #prop = GameProductItem.find_by_item_name("专属音效16")
      #prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
    end
    if @player_info.vip_level.to_i==4
      num = rand(0..1)%2 ==0 ? 21 : 22
      prop = GameProductItem.find_by_item_name("专属音效#{num}")
      prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
    end
  end

  def play_card_voice_timing(&block)
    Rails.logger.debug("robot_timer_next_user_id=>#{@player_info.user_id}")
    table = GameTable.get_game_table(@player_info.table_id, @player_info.room_id)

    @waiting_timer = EventMachine::Timer.new(9) do
      prop = GameProductItem.find_by_item_name("专属音效15")
      prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
      if @player_info.vip_level.to_i>1
        @waiting_timer = EventMachine::Timer.new(8) do
          prop = GameProductItem.find_by_item_name("专属音效18")
          prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
          if @player_info.vip_level.to_i==4
            @waiting_timer = EventMachine::Timer.new(6) do
              prop = GameProductItem.find_by_item_name("专属音效26")
              prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
            end
            store_current_voice_timer(@waiting_timer)
          end
        end
        store_current_voice_timer(@waiting_timer)
      end
    end
    store_current_voice_timer(@waiting_timer)
  end


  def on_be_hurt(&block)
    if vip_level_activity > 2
      prop = GameProductItem.find_by_item_name("专属音效19")
      prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
    end
  end

  def on_cheer_partner(&block)
    if vip_level_activity >2
      prop = GameProductItem.find_by_item_name("专属音效20")
      prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
    end
  end

  def after_enter_room(&block)
    if vip_level_activity > 1
      prop = GameProductItem.find_by_item_name("专属音效17")
      prop.take_effect(@player_info.user_id, {:is_robot=>true}, &block)
    end
  end

  def before_leave_game(players,&block)
    if vip_level_activity > 2
      num = rand(0..1)%2 ==0 ? 23 : 24
      prop = GameProductItem.find_by_item_name("专属音效#{num}")
      prop.take_effect(@player_info.user_id, {:is_robot=>true,:players=>players}, &block)
    end
  end

end