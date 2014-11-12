#encoding: utf-8

require "logic/synchronization"
require "logic/game_cleaner"

class GameLogic
  #@@connections={}
  @@all_poke_cards ||= lambda {
    tmp_cards = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1, 2].collect do |card_index|
      card_value = format("%02d", card_index)
      ["d", "c", "b", "a"].collect { |card_type| "#{card_type}#{card_value}" }
    end.flatten

    tmp_cards << "w01"
    tmp_cards << "w02"
  }.call

  def self.check_room_available(room, player)
    online_count = GameRoomUtility.get_room_online_count(room.room_id)
    result = nil
    result = ResultCode::ROOM_MAINTENANCE if room.state == 1
    if result.nil? and online_count >= room.limit_online_count.to_i and room.limit_online_count.to_i > 0
      result = ResultCode::ROOM_FULL
    end

    user = User.find_by_user_id(player.player_info.user_id)
    if user.game_score_info.reload(:lock => true).score < room.min_qualification.to_i && result.nil?
      result = ResultCode::UN_MATCH_QUALIFICATION
    end
    result
  end

  def self.on_player_enter_game(user_id, room_id, event=nil)
    Rails.logger.debug("[on_player_enter_game] user_id =>"+user_id.to_s)
    Rails.logger.debug("[on_player_enter_game] current time =>"+Time.now.to_s)
    Rails.logger.debug("[on_player_enter_game] room_id =>"+room_id.to_s)
    if room_id.nil?
      GameController.game_trigger_failure({:result_code => ResultCode::ROOM_ID_IS_NULL}, event) unless event.nil?
      return
    end
    player = Player.get_player(user_id)
    prev_table_id = nil
    if player.in_game?
      table = GameTable.get_game_table(player.player_info.table_id, room_id)
      if table.game_dead?
        GameCleaner.clear_table(player.player_info.table_id, player.player_info.room_id)
      else
        Rails.logger.debug("[on_player_enter_game] player is in another table =>"+player.player_info.table_id)
        #on_player_leave_game(user_id)
      end

      #unless table.game_dead?
      #  prev_table_id = table.table_info.table_id
      #  on_player_leave_game(user_id)
      #  #join_previous_game(player, table, event)
      #  #return
      #end
      prev_table_id = table.table_info.table_id
      #on_player_leave_game(user_id)
    end
    room = GameRoomUtility.get_room(room_id)

    Rails.logger.debug("[on_player_enter_game] player =>"+player.player_info.to_json)
    Rails.logger.debug("[on_player_enter_game] room =>"+room.to_json)

    check_result = check_room_available(room, player)
    unless check_result.nil?
      failure_msg = {:result_code => check_result}
      #controller.trigger_failure(failure_msg)
      GameController.game_trigger_failure(failure_msg, event) unless event.nil?
      Rails.logger.debug("[on_player_enter_game] trigger_failure =>"+failure_msg.to_json)
      return
    end

    table = GameRoomUtility.get_one_available_table(user_id, room_id, prev_table_id)
    if table.nil?
      GameController.game_trigger_failure({:result_code => ResultCode::ROOM_ID_IS_NULL}, event) unless event.nil?
      return
    end
    enter_game_room(player, table, room, event)

  end

  def self.join_previous_game(player, table, event)
    Rails.logger.debug("[join_previous_game] user_id=>"+player.player_info.user_id)
    room = GameRoomUtility.get_room(table.table_info.room_id)
    notify_data = get_player_join_notify_data(room, table)
    unless event.nil?
      GameController.game_trigger_success(notify_data, event)
    end
    #controller.trigger_game_notify("g.player_join_notify", notify_data, table.table_info.channel_name)
    GameController.trigger_game_notify("g.player_join_notify", notify_data,
                                       player.player_info.user_id, table.table_info)
  end

  def self.on_robot_enter_game_room(player, table)
    Rails.logger.debug("[on_robot_enter_game_room] user_id =>"+player.player_info.user_id.to_s)
    Rails.logger.debug("[on_robot_enter_game_room] current time =>"+Time.now.to_s)
    room = GameRoomUtility.get_room(table.table_info.room_id)
    Rails.logger.debug("[on_robot_enter_game_room] player =>"+player.player_info.to_json)
    Rails.logger.debug("[on_robot_enter_game_room] room =>"+room.to_json)
    enter_game_room(player, table, room)
  end


  def self.enter_game_room(player, table, room, event=nil)
    table.table_info.reload_from_redis
    table.before_player_join_game
    player.on_join_game(table.table_info.table_id, room.room_id, room.room_type, table.table_info.game_id)

    table.on_player_join_game(player.player_info.user_id)

    room.on_player_join


    GameRoomUtility.increase_room_online_count(room.room_id)
    table.table_info.reload_from_redis
    Rails.logger.debug("[enter_game_room] table info=>"+table.table_info.to_json)

    if table.users_count > 2
      GameRoomUtility.set_table_invalid(room.room_id, table.table_info.table_id)
    end
    notify_data = get_player_enter_notify_data(room, table, player)
    unless event.nil?
      GameController.game_trigger_success(notify_data, event)
      #EventMachine.add_timer(1) do
      #  GameController.game_trigger_success(notify_data, event)
      #end
    end
    #controller.trigger_game_notify("g.player_join_notify", notify_data, table.table_info.channel_name)
    GameController.trigger_game_notify("g.player_join_notify", notify_data,
                                       player.player_info.user_id, table.table_info)

    players_ready_timing [player]

    player.after_enter_room do |text, voice, u_id|
      notify_data = {user_id: u_id, text: text, voice: voice, :notify_type => ResultCode::PROP_VOICE}
      GameController.trigger_game_notify("ui.routine_notify", notify_data, u_id, table.table_info)
    end
    if table.users_count < 3 and !player.is_robot?
      Rails.logger.debug("[on_player_ready] waiting to robot join game.")
      waiting_robot_join_timing(table.table_info.table_id, room.room_id, player.player_info.user_id)
    end
  end


  def self.get_player_join_notify_data(room, table)
    return_game_info = {:id => table.table_info.table_id, :name => room.name, :game_id => table.table_info.game_id,
                        :room_base => room.base, :channel_name => table.table_info.channel_name}
    players = table.get_players
    client_players_info = []
    players.each do |player|
      client_players_info.push(player.client_player_info)
    end
    notify_data = {:game_info => return_game_info, :players => client_players_info}
  end

  def self.get_player_enter_notify_data(room, table, me_player)
    if room.room_type.to_i >1
      rank = match_game_over_self_rank(me_player)
    end
    return_game_info = {:id => table.table_info.table_id, :name => room.name, :game_id => table.table_info.game_id,
                        :room_base => room.base, :room_type => room.room_type, :channel_name => table.table_info.channel_name}
    players = table.get_players
    client_players_info = []
    players.each do |player|
      client_players_info.push(player.client_player_info)
    end
    show_jipaiqi, using_props = me_player.using_props
    voice_props = me_player.playing_card_voice_props
    user_id = me_player.player_info.user_id
    GameTeaching.user_game_teach(user_id, "enter_room")


    match_left_time = GameRoomUtility.get_room_match_left_time(room)

    notify_data = {:game_info => return_game_info, :players => client_players_info,
                   :show_jipaiqi => show_jipaiqi, :using_props => using_props, :voice_props => voice_props,
                   :match_left_time => match_left_time}
    if room.room_type.to_i >1
      notify_data = notify_data.merge({:rank => rank})
    end
    notify_data

  end


  def self.get_success_response_data
    {:result_code => ResultCode::SUCCESS}
  end

  def self.on_player_ready(user_id, event=nil)
    table_id = nil
    Rails.logger.debug("[on_player_ready] user_id =>"+user_id.to_s)
    Rails.logger.debug("[on_player_ready] current time =>"+Time.now.to_s)
    player = Player.get_player(user_id)
    if player.current_action_finished?
      Rails.logger.debug("[on_player_ready] current_action_finished? is true, current_action_seq=>"+player.player_info.current_action_seq.to_s)
      return
    end

    room_id = player.player_info.room_id
    room = GameRoomUtility.get_room(room_id)
    if room.blank?
      Rails.logger.debug("[on_player_ready] room is nil, player=> "+player.player_info.to_json)
      GameController.game_trigger_failure({:result_code => ResultCode::PLAYER_ROOM_IS_NIL, :result_message => "PLAYER_ROOM_IS_NIL"}, event) unless event.nil?
      return
    end

    table_id = player.player_info.table_id
    table = GameTable.get_game_table(table_id, room_id)

    table.on_player_ready
    player.on_ready
    Rails.logger.debug("[on_player_ready] try to trigger_success")
    #controller.trigger_success(get_success_response_data) unless player.is_robot?
    GameController.game_trigger_success(get_success_response_data, event) unless event.nil?

    notify_data = get_player_join_notify_data(room, table)
    Rails.logger.debug("[on_player_ready] try to trigger player join notify.")
    #controller.trigger_game_notify("g.player_join_notify", notify_data)
    GameController.trigger_game_notify("g.player_join_notify", notify_data, user_id, table.table_info)
    if table.is_all_players_ready?
      EventMachine.add_timer(1) do
        on_game_start(table_id, room_id)
      end
    end

    if table.users_count < 3 and !player.is_robot?
      Rails.logger.debug("[on_player_ready] waiting to robot join game.")
      waiting_robot_join_timing(table_id, room_id, user_id)
    end
  end

  def self.waiting_robot_join_timing(table_id, room_id, user_id)
    table = GameTable.get_game_table(table_id, room_id)
    room = GameRoomUtility.get_room(table.table_info.room_id)
    current_seq = table.table_info.current_action_seq
    Rails.logger.debug("[waiting_robot_join_timing] table_info.action_seq=>"+table.table_info.current_action_seq.to_s)
    timeout = ResultCode::ADD_ROBOT_TIMEOUT_LEVEl[room.room_type.to_i - 1]
    EventMachine.add_timer(rand(2..5)) do
      table = GameTable.get_game_table(table_id, room_id)
      unless table.action_finished?(current_seq)
        table.set_current_action_finished
        if table.users_count > 0 and table.users_count < 3
          Rails.logger.debug("[waiting_robot_join_timing] table.users =>"+table.users.to_json)
          Rails.logger.debug("[waiting_robot_join_timing] current time =>"+Time.now.to_s)
          arrange_robot_join_game(table, user_id)
        end
      end
    end
  end

  def self.arrange_robot_join_game(table, user_id)
    (3-table.users_count).times do |i|
      timeout = rand(i*1..i*3)
      EventMachine.add_timer(timeout) do
        table.table_info.reload_from_redis
        unless table.users_count > 2 or table.users_count == 0 or table.left_all_robots?
          unless table.join_user(user_id).nil?
            robot = Player.initialize_robot(user_id, table.table_info.table_id, table.table_info.room_id)
            if robot.nil?
              Rails.logger.debug("[arrange_robot_join_game] all robots are busy.")
            else
              on_robot_enter_game_room(robot, table)
            end
          end
        end
      end
    end
  end

  def self.on_game_start(table_id, room_id)
    key ="count_pj_time_#{table_id}_#{room_id}"
    unless Redis.current.exists(key)
      Redis.current.set key, Time.now.to_i
    end
    UserSheet.count_paiju
    Rails.logger.debug("[on_game_start] table_id =>"+table_id.to_s)
    table = GameTable.get_game_table(table_id, room_id)
    if table.users.length < 3
      Rails.logger.debug("[on_game_start] some player escaped, break game start.")
      return
    end
    v_start_event_end = table.set_game_start_event_end
    if v_start_event_end.nil? or v_start_event_end[0] > 1
      Rails.logger.debug("[on_game_start] game start event end. game_seq=>#{table.table_info.current_action_seq.to_s}")
      return
    end
    table.set_game_start_key_expired

    tmp_call_poke_cards = @@all_poke_cards.dup.shuffle
    poke_cards = []
    3.times do
      poke_cards.push(CardUtility.get_cards_with_17(tmp_call_poke_cards))
    end
    lord_card = tmp_call_poke_cards.dup

    table.on_game_start(lord_card)
    Rails.logger.debug("[on_game_start] table info =>"+table.table_info.to_json)
    Rails.logger.debug("[on_game_start] next_user_id"+table.table_info.next_user_id.to_s)

    players = table.get_players
    Rails.logger.debug("[on_game_start] table_info =>"+table.table_info.lord_card.to_json)
    players.each_with_index do |player, index|
      player.on_game_start(poke_cards[index], table.table_info.next_user_id)
    end

    notify_data_players = []
    players.each do |player|
      notify_data_players.push(player.client_player_info)
    end

    bombs_count(table_id, room_id)
    room = GameRoomUtility.get_room(room_id)
    players.each do |player|
      Rails.logger.debug("[on_game_start] player info =>"+player.player_info.poke_cards.to_json)
      if player.player_info.user_id.to_i == table.table_info.next_user_id.to_i
        grab_lord = 1
      else
        grab_lord = 0
      end
      unless player.is_robot?
        show_jipaiqi, using_props = player.using_props
        notify_data = {:user_id => player.player_info.user_id.to_i,
                       :next_user_id => table.table_info.next_user_id.to_i,
                       :grab_lord => grab_lord,
                       :lord_value => -1, :poke_card_count => 17,
                       :poke_cards => player.player_info.poke_cards, :players => notify_data_players,
                       :show_jipaiqi => show_jipaiqi, :using_props => using_props, :game_id => table.table_info.game_id,
                       :game_seq => table.table_info.game_sequence, :escape_money => table.escape_money(room.base)}
        #controller.trigger_personal_game_notify(player.player_info.user_id, "g.game_start", notify_data)
        GameController.trigger_personal_game_notify(player.player_info.user_id, "g.game_start", notify_data, table.table_info)
      end
    end

    DdzGameServer::Synchronization.publish({:user_id => table.table_info.next_user_id,
                                            :notify_type => GameTimingNotifyType::GRAB_LORD})
  end

  def self.on_liuju(table_id, room_id)
    Rails.logger.debug("[on_liuju] table_id =>"+table_id.to_s)
    table = GameTable.get_game_table(table_id, room_id)
    players = table.get_players
    table.on_liuju
    players.each do |player|
      player.on_liuju
    end

    room = GameRoomUtility.get_room(table.table_info.room_id)

    table.on_game_over

    notify_data = get_player_join_notify_data(room, table)
    GameController.trigger_game_notify("g.player_join_notify", notify_data, nil, table.table_info)

    players.each do |player|
      DdzGameServer::Synchronization.publish({:user_id => player.player_info.user_id,
                                              :notify_type => GameTimingNotifyType::READY})
    end

  end

  def self.players_ready_timing(players, timeout=nil)
    players.each do |player|
      if player.is_robot?
        player.ready_timing(player.player_info.current_action_seq, timeout) do |u_id|
          on_player_ready u_id
        end
      else
        player.ready_timing(player.player_info.current_action_seq, timeout) do |u_id|
          Rails.logger.debug("[players_ready_timing] time out, os on_player_leave_game, user_id=>"+u_id.to_s)
          on_player_leave_game u_id
        end
      end
    end
  end

  def self.player_grab_lord_timing(player)

    player.grab_lord_timing(player.player_info.current_action_seq) do |u_id, lord_value|
      on_grab_lord(u_id, lord_value)
    end
  end

  def self.player_play_card_timing(player)
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    tmp_all_out_cards = table.table_info.all_out_card.dup
    Rails.logger.debug("[self.player_play_card_timing] tmp_all_out_card＝>#{tmp_all_out_cards}")
    tmp_all_out_cards.delete([])
    player.play_card_timing(player.player_info.game_id, player.player_info.current_action_seq, table.table_info.last_user_id,
                            tmp_all_out_cards.last) do |u_id, poke_cards|
      on_play_card(u_id, poke_cards)
    end
  end

  def self.kick_player(user_id)
    player = Player.get_player(user_id)
    if player.in_game?
      on_player_leave_game(user_id)
    else
      unless player.player_info.table_id.blank? or player.player_info.table_id.to_i == 0
        GameCleaner.clear_table(player.player_info.table_id, player.player_info.room_id)
      end
    end
  end

  def self.on_player_timing(notify_data)
    user_id = notify_data["user_id"]
    notify_type = notify_data["notify_type"]
    server_id = notify_data["server_id"]
    Rails.logger.debug("[on_player_timing] user_id=>#{user_id.to_s}, notify_type=>#{notify_type.to_s}")
    Rails.logger.debug("[on_player_timing] server_id=>#{server_id.to_s}, Process.pid=>#{Process.pid.to_s}")
    return if user_id.blank? or user_id.to_i == 0
    player = Player.get_player(user_id)

    if GameController.connection_exist?(user_id) or
      GameController.connection_exist?(player.player_info.dependence_user) or
      server_id.to_s == Process.pid.to_s

      Rails.logger.debug("[on_player_timing] ok")

      if notify_type.to_i == GameTimingNotifyType::READY
        players_ready_timing [player]
      elsif notify_type.to_i == GameTimingNotifyType::GRAB_LORD
        player_grab_lord_timing(player)
      elsif notify_type.to_i == GameTimingNotifyType::PLAY_CARD
        player_play_card_timing(player)
      elsif notify_type.to_i == GameTimingNotifyType::GAME_OVER
        players_ready_timing [player], ResultCode::GAME_OVER_RETURN_GAME_TIMEOUT
      elsif notify_type.to_i == GameTimingNotifyType::KICK_USER
        kick_player(user_id)
      end
    end


  end

  def self.on_grab_lord(user_id, lord_value, event=nil)
    Rails.logger.debug("[player_grab_lord] user_id =>#{user_id.to_s}, lord_value =>#{lord_value.to_s}")
    Rails.logger.debug("[player_grab_lord] current time =>"+Time.now.to_s)
    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    table = GameTable.get_game_table(table_id, player.player_info.room_id)
    if player.current_action_finished?
      Rails.logger.debug("[player_grab_lord], it is not my turn, current_action_finished? is true, current_action_seq=>"+player.player_info.current_action_seq.to_s)
      return
    end
    if table.table_info.state.to_i != GameTableState::GRAB_LORD or table.table_info.next_user_id.to_i != user_id.to_i
      Rails.logger.debug("[player_grab_lord], it is not my turn,  table_info=>#{table.table_info.to_json}")
      return
    end


    player.on_grab_lord(lord_value)

    players = table.get_players
    is_liuju = players.select { |p| p.player_info.lord_value.to_i == 0 }.count == 3
    if is_liuju
      Rails.logger.debug("[player_grab_lord] liu_ju =>")
      on_liuju(table_id, player.player_info.room_id)
    else

      table.on_grab_lord(user_id)
      Rails.logger.debug("[player_grab_lord] table_info =>"+table.table_info.to_json)
      is_end_grab_lord = true unless table.table_info.lord_user_id.blank?
      if is_end_grab_lord
        Rails.logger.debug("[player_grab_lord] end to grab_lord.")
        players.each do |p|
          p.on_grab_lord_end(table.table_info.lord_user_id, table.table_info.lord_card)
        end
      end

      return_players = []
      players.each do |p|
        return_players.push p.client_player_info
        if is_end_grab_lord
          tmp_user = User.find_by_id(p.player_info.id)
          judge_user_luck(tmp_user.user_id, p.player_info.poke_cards)
          User.record_user_game_teach(p.player_info.user_id, "lord") if p.player_info.player_role.to_i == 2
          User.record_user_game_teach(p.player_info.user_id, "farmer") if p.player_info.player_role.to_i == 1
        end
      end

      
      if is_end_grab_lord
        event_data = {lord_user_id: table.table_info.lord_user_id.to_i,
                      lord_value: table.table_info.lord_value,
                      lord_cards: table.table_info.lord_card.join(","), :players => return_players}
      else
        event_data = {lord_user_id: 0, lord_value: table.table_info.lord_value,
                      prev_lord_user_id: user_id.to_i,
                      next_user_id: table.table_info.next_user_id.to_i,
                      :players => return_players}

      end
      player.after_grab_lord(table.table_info.next_user_id) do |text, voice, u_id|
        notify_data = {user_id: u_id, text: text, voice: voice, notify_type: ResultCode::PROP_VOICE}
        GameController.trigger_game_notify("ui.routine_notify", notify_data, u_id, table.table_info)
      end


      GameController.trigger_game_notify("g.grab_lord_notify", event_data, user_id, table.table_info)
      Rails.logger.debug("[player_grab_lord] end to grab_lord_notify.")
      if is_end_grab_lord
        DdzGameServer::Synchronization.publish({:user_id => table.table_info.next_user_id,
                                                :notify_type => GameTimingNotifyType::PLAY_CARD})
      else
        DdzGameServer::Synchronization.publish({:user_id => table.table_info.next_user_id,
                                                :notify_type => GameTimingNotifyType::GRAB_LORD})
      end
    end

  end

  def self.on_play_card(user_id, poke_cards, event=nil)
    Rails.logger.debug("[on_play_card] user_id =>#{user_id.to_s}, poke_cards =>#{poke_cards.to_json}")
    Rails.logger.debug("[on_play_card] current time =>"+Time.now.to_s)

    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    Rails.logger.debug("[on_play_card] poke_cards =>#{poke_cards}")
    table = GameTable.get_game_table(table_id, player.player_info.room_id)
    if player.current_action_finished? or
      table.table_info.state.to_i != GameTableState::PLAY_CARD or table.table_info.next_user_id.to_i != user_id.to_i

      Rails.logger.debug("[on_play_card] return_false, table_last_user_id =>"+"#{table.table_info.last_user_id}")
      GameController.game_trigger_failure({:result_code => ResultCode::IT_IS_NOT_TURN}, event) unless event.nil?
      return
    end

    GameController.game_trigger_success(nil, event) unless event.nil?

    poke_cards = poke_cards.split(",")
    player.on_play_cards(poke_cards, event.nil?)
    table.on_play_card(user_id)
    old_last_user_id = table.table_info.last_user_id
    next_user_id = table.next_play_poke_user(user_id, poke_cards)
    Rails.logger.debug("[on_play_card] next_user_id =>#{next_user_id}")
    all_players = table.get_players
    return_players = []
    return_players.push(all_players[0].client_player_info)
    return_players.push(all_players[1].client_player_info)
    return_players.push(all_players[2].client_player_info)
    #if player.player_info.poke_cards.length <1
    #   user_id = 0
    #end

    event_data = {player_id: user_id,
                  poke_cards: poke_cards.join(","),
                  players: return_players,
                  next_user_id: next_user_id,
                  last_user_id: table.table_info.last_user_id
    }
    Rails.logger.debug("[on_play_card] event_data =>#{event_data}")

    GameController.trigger_game_notify("g.play_card", event_data, nil, table.table_info)
    #next_user = Player.get_player(next_user_id,controller)
    #player = Player.get_player(user_id,controller)
    #if next_user.is_robot? && player.player_info.poke_cards.length > 0
    #  #机器人出牌
    #end

    if player.player_info.poke_cards.length <1
      on_game_over(player)
    else
      DdzGameServer::Synchronization.publish({:user_id => next_user_id,
                                              :notify_type => GameTimingNotifyType::PLAY_CARD})

      player.after_play_card(next_user_id, old_last_user_id, poke_cards) do |text, voice, u_id|
        notify_data = {user_id: u_id, text: text, voice: voice, notify_type: ResultCode::PROP_VOICE}
        GameController.trigger_game_notify("ui.routine_notify", notify_data, u_id, table.table_info)
      end

    end
  end

  def self.on_game_over(player)
    table_id = player.player_info.table_id
    table = GameTable.get_game_table(table_id, player.player_info.room_id)
    key = "count_pj_time_#{table_id}_#{player.player_info.room_id}"
    if Redis.current.exists(key)
      time = Time.now.to_i - Redis.current.get(key).to_i
      UserSheet.paiju_time_count(time)
    end
    all_players = table.get_players
    win_role = player.player_info.player_role

    all_players.each do |p|
      #next if p.player_info.is_robot.to_i == 1
      gaming_push_system_msg(p, win_role)
      #id = p.player_info.id
      #t_user = User.find_by_id(id)
      #next if t_user.nil?
      #key = "#{t_user.user_id}_#{Time.now.to_s[0, 10]}"
      #unless Redis.current.exists(key)
      #  Redis.current.hmset(key, *{total_game: 0, continue_win: 0, win_total: 0,continue_lost:0})
      #  Redis.current.expire(key, 3600*24)
      #end
      #total_game = Redis.current.hget(key, "total_game").to_i + 1
      #Rails.logger.debug("[on_game_over] one_role =>#{p.player_info.player_role}")
      #
      #Rails.logger.debug("[on_game_over] two_role =>#{player.player_info.player_role}")
      #
      #if p.player_info.player_role == player.player_info.player_role
      #  continue_win = Redis.current.hget(key, "continue_win").to_i + 1
      #  win_total = Redis.current.hget(key, "win_total").to_i + 1
      #  continue_lost = 0
      #  Redis.current.hmset(key,*{win_total:win_total})
      #  flag = false
      #  Rails.logger.debug("total_win_get_beans_win_total=>#{Redis.current.hget(key, "win_total").to_i}")
      #  flag, beans = total_win_get_beans(key)
      #  Rails.logger.debug("[total_win_get_beans] flag =>#{flag}")
      #
      #
      #  if flag
      #    t_user.game_score_info.score = t_user.game_score_info.score+beans
      #    t_user.game_score_info.save
      #    notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_TOTAL_WIN,:win_count=>win_total.to_i}
      #    Rails.logger.debug("[total_win_get_beans] notify_data =>#{notify_data}")
      #    GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      #    flag = false
      #  end
      #else
      #  continue_lost =  Redis.current.hget(key, "continue_lost").to_i + 1
      #  continue_win = 0
      #
      #end
      #
      #Redis.current.hmset(key, *{total_game: total_game,continue_win: continue_win, continue_lost:continue_lost})
      #game_over_push_game_prop(t_user.user_id)
      #flag = false
      #flag, beans= play_game_get_beans(key) #连续游戏获取豆子
      #if flag
      #  t_user.game_score_info.score = t_user.game_score_info.score+beans
      #  t_user.game_score_info.save
      #  notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_TOTAL_GAME,:game_count=>total_game.to_i}
      #  GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      #
      #  flag = false
      #end
      #
      #
      #
      #flag, beans = continue_win_get_beans(key)
      #Rails.logger.debug("[continue_win_get_beans] flag =>#{flag}")
      #
      #if flag
      #  t_user.game_score_info.score = t_user.game_score_info.score+beans
      #  t_user.game_score_info.save
      #  notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_CONTINUE_WIN,:continue_win=>continue_win.to_i}
      #  Rails.logger.debug("[continue_win_get_beans] notify_data =>#{notify_data}")
      #
      #  GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      #  flag = false
      #end

    end


    table.spring_count
    bombs = table.table_info.bombs.to_i
    room = GameRoomUtility.get_room(table.table_info.room_id)
    game_base = room.base.to_i
    user_player_role = player.player_info.player_role
    spring = table.table_info.spring.to_i
    anti_spring = table.table_info.anti_spring.to_i
    Rails.logger.debug("on_game_over_anti_spring:#{anti_spring}")
    lord_value = table.table_info.lord_value
    game_result = {}
    game_result[:winner_player_id] = player.player_info.user_id
    game_result[:bombs] = 2**bombs
    game_result[:spring] = 2**spring
    game_result[:anti_spring] = 2**anti_spring
    game_result[:base] = game_base
    game_result[:lord_value] = lord_value
    total = game_base.to_i * lord_value.to_i * 2
    total = total.to_i * (2**bombs.to_i) if bombs.to_i > 0
    total = total.to_i * 2 if spring.to_i > 0 || anti_spring.to_i > 0
    game_result[:total] = total
    game_result[:balance] = {}
    game_result[:self_balance] = {}
    game_result[:rank] = {}
    win_total = total
    Rails.logger.debug("[on_game_over] win_total =>#{win_total}")
    Rails.logger.debug("[on_game_over] win_role =>#{player.player_info.player_role}")

    #save_player_score_to_db(table_id, player.player_info.player_role, total)

    win_total = -total if player.player_info.player_role.to_i != 2
    half_total = -win_total / 2

    return_players = []
    all_players.each do |p|
      return_players.push p.client_player_info
    end

    table.on_game_over

    all_players.each do |player|
      if player.player_info.player_role.to_i == 2
        game_result[:balance][player.player_info.user_id] = win_total
        game_result[:self_balance][player.player_info.user_id] =
          player.on_game_over(win_total > 0, win_total, table.table_info.game_id)
      else
        game_result[:balance][player.player_info.user_id] = half_total
        game_result[:self_balance][player.player_info.user_id] =
          player.on_game_over(half_total > 0, half_total, table.table_info.game_id)
      end
      #if room.room_type.to_i > 1
      #  Rails.logger.debug("[on_game_over] rank_user_id =>#{player.player_info.user_id}")
      #
      #  game_result[:rank][player.player_info.user_id] = match_game_over_self_rank(player)
      #end
      if player.player_info.is_robot.to_i == 0
        bankrupt(player)
        # user_online_time(player.player_info.user_id)
      end
    end

    all_players.each do |player|
      if room.room_type.to_i > 1
        Rails.logger.debug("[on_game_over] rank_user_id =>#{player.player_info.user_id}")

        game_result[:rank][player.player_info.user_id] = match_game_over_self_rank(player)
      end
    end


    #修复结束后把牌亮出 修改此处return_players
    match_left_time = GameRoomUtility.get_room_match_left_time(room)
    notify_data = {game_result: game_result, players: return_players, game_id: table.table_info.game_id, match_left_time: match_left_time}
    Rails.logger.debug("[on_game_over] notify_data =>#{notify_data}")

    GameController.trigger_game_notify("g.game_over", notify_data, nil, table.table_info)

    kick_players = kicks_players_on_game_over(table_id, player.player_info.room_id, room.base, true)

    #table = GameTable.get_game_table(table_id,  player.player_info.room_id)
    #unless table.is_empty?
    #  alive_player_id = table.get_alive_player_id
    #  waiting_robot_join_timing(table_id, room.room_id, alive_player_id)
    #end

    table = GameTable.get_game_table(table_id, player.player_info.room_id)
    players = table.get_players
    players.each do |p|
      unless kick_players.include?(p.player_info.user_id)
        DdzGameServer::Synchronization.publish({:user_id => p.player_info.user_id,
                                                :notify_type => GameTimingNotifyType::GAME_OVER})
      end
    end

    players.each do |p|
      p.chat_on_game_over do |text, voice, u_id|
        notify_data = {user_id: u_id, text: text, voice: voice, notify_type: ResultCode::PROP_VOICE}
        GameController.trigger_game_notify("ui.routine_notify", notify_data, u_id, table.table_info)
      end
    end

  end

  #def self.save_player_score_to_db(table_id, winner_role, total, escape_player_role=nil)
  #  Rails.logger.debug("[save_player_score_to_db]")
  #  table = GameTable.get_game_table(table_id)
  #  escape_player_role = escape_player_role.to_i
  #  table.table_info.users.each do |user_id|
  #    user_player = User.find_by_user_id(user_id)
  #    user_player.game_score_info||user_player.build_game_score_info
  #    user_player.game_score_info.user_id = user_player.id
  #    player = Player.get_player(user_id)
  #    if player.player_info.player_role.to_i == winner_role.to_i
  #      score = (player.player_info.player_role.to_i==2) ? total : total/2
  #      score = score/2 if (player.player_info.player_role.to_i==2 && escape_player_role!=0)
  #      user_player.game_score_info.score = user_player.game_score_info.score.to_i + score
  #      user_player.game_score_info.win_count = user_player.game_score_info.win_count.to_i + 1
  #    else
  #      score = (player.player_info.player_role.to_i==2) ? total : total/2
  #      score = 0 if (escape_player_role !=0 && player.player_info.player_role.to_i==1 && player.player_info.player_role.to_i !=escape_player_role)
  #      score = 2 * score if (escape_player_role !=0 && player.player_info.player_role.to_i==1 && player.player_info.player_role.to_i==escape_player_role)
  #      user_player.game_score_info.score = user_player.game_score_info.score.to_i - score
  #      user_player.game_score_info.lost_count = user_player.game_score_info.lost_count.to_i + 1
  #    end
  #    user_player.game_score_info.all_count = user_player.game_score_info.all_count.to_i + 1
  #    if player.player_info.user_id.to_i == escape_player_role
  #      user_player.game_score_info.flee_count = user_player.game_score_info.flee_count.to_i + 1
  #    end
  #    user_player.game_score_info.save
  #  end
  #  Rails.logger.debug("[save_player_score_to_db] end.")
  #end

  def self.on_player_leave_game(user_id, event=nil)

    Rails.logger.debug("[on_player_leave_game] user_id=>"+user_id.to_s)
    Rails.logger.debug("[on_player_leave_game] current time =>"+Time.now.to_s)
    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    room_id = player.player_info.room_id
    if table_id.nil? or table_id.to_i == 0
      Rails.logger.debug("[on_player_leave_game] table_id=>"+table_id.to_s)
      return false
    end

    table = GameTable.get_game_table(table_id, player.player_info.room_id)

    players = table.get_players
    is_escape = false
    if table.table_info.state.to_i == GameTableState::GRAB_LORD
      player.set_player_role(2)
      players.each do |p|
        p.set_player_role(1) if p.player_info.user_id != player.player_info.user_id
      end
      player_escape(player, players, table)
      is_escape = true
    elsif table.table_info.state.to_i == GameTableState::PLAY_CARD
      player_escape(player, players, table)
      is_escape = true
    end

    player_leave_game(user_id)
    room = GameRoomUtility.get_room(room_id)

    kick_players = kicks_players_on_game_over(table_id, player.player_info.room_id, room.base, false)
    table = GameTable.get_game_table(table_id, room_id)
    players = table.get_players

    if is_escape
      players.each do |p|
        unless kick_players.include?(p.player_info.user_id)
          DdzGameServer::Synchronization.publish({:user_id => p.player_info.user_id,
                                                  :notify_type => GameTimingNotifyType::GAME_OVER})
        end
      end
    end


  end

  def self.player_leave_game(user_id)
    Rails.logger.debug("[on_player_leave_game] user_id=>"+user_id.to_s)
    Rails.logger.debug("[on_player_leave_game] current_time=>"+Time.now.to_s)
    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    if table_id.nil? or table_id.to_i == 0
      Rails.logger.debug("[on_player_leave_game] table_id=>"+table_id)
      return false
    end

    table = GameTable.get_game_table(table_id, player.player_info.room_id)


    Rails.logger.debug("[on_player_leave_game] users_count=>"+table.users.length.to_s)
    players = table.get_players

    table.on_player_leave(user_id)


    player.before_leave_game(players) do |text, voice, u_id|
      notify_data = {user_id: u_id, text: text, voice: voice, :notify_type => ResultCode::PROP_VOICE}
      GameController.trigger_game_notify("ui.routine_notify", notify_data, u_id, table.table_info)
    end

    GameRoomUtility.decrease_room_online_count(table.table_info.room_id)

    return_players = []
    players = table.get_players


    Rails.logger.debug("[on_player_leave_game] users_count=>"+table.users.length.to_s)

    players.each do |p|
      return_players.push p.client_player_info
    end

    notify_data = {:user_id => user_id, :players => return_players}
    GameController.trigger_game_notify("g.leave_game_notify", notify_data, nil, table.table_info)
    Rails.logger.debug("[on_player_leave_game] room_id=>"+table.table_info.room_id.to_s)

    GameController.unsubscribe_channel(user_id, table.table_info.channel_name)

    GameRoomUtility.set_table_available(table.table_info.room_id, table.table_info.table_id)

    table.table_info.reload_from_redis
    unless table.is_empty? or table.left_all_robots?
      Rails.logger.debug("[on_player_leave_game] waiting_robot_join_timing")
      alive_player_id = table.get_alive_player_id
      waiting_robot_join_timing(table_id, table.table_info.room_id, alive_player_id)
    end

    player.set_dependence_player(0)

    true
  end

  def self.kicks_players_on_game_over(table_id, room_id, room_base, is_game_over)
    table = GameTable.get_game_table(table_id, room_id)
    players = table.get_players
    kick_players = []
    players.each do |p|
      p_user = User.find_by_user_id(p.player_info.user_id)
      probability = rand(1..100)
      Rails.logger.debug("[kicks_players_on_game_over] user_id=>#{p.player_info.user_id.to_s}, is_lost=>#{p.player_info.is_lost.to_s}")
      if (p.is_robot? && is_game_over && p.player_info.is_lost.to_i == 1 && probability > 33) or
        (p.is_robot? && is_game_over && p.player_info.is_lost.to_i == 0 && probability < 33) or
        (p.is_robot? && !is_game_over) or
        (!p.is_robot? && p.player_info.dependence_user.to_i > 0) or
        (!p_user.nil? && p_user.game_score_info.reload(:lock => true).score.to_i < room_base.to_i)

        must_kick = p_user.game_score_info.reload(:lock => true).score.to_i < room_base.to_i
        kick_players.push p.player_info.user_id
        Rails.logger.debug("[kicks_players_on_game_over] after seconds, user_id=>"+p.player_info.user_id.to_s)
        #table.on_player_leave(p.player_info.user_id)
        table.table_info.reload_from_redis
        timeout = ResultCode::KICKS_PLAYER_TIMEOUT
        timeout = rand(5..10) if p.is_robot?
        timeout = rand(0..1) if table.left_all_robots? or (!p.is_robot? && p.player_info.dependence_user.to_i > 0) or must_kick
        Rails.logger.debug("[kicks_players_on_game_over] timeout=>"+timeout.to_s)
        EventMachine.add_timer(timeout) do
          p.player_info.reload_from_redis

          if must_kick or p.player_info.dependence_user.to_i > 0 or p.is_robot? and p.player_info.table_id.to_s == table_id.to_s
            player_leave_game(p.player_info.user_id)
            Rails.logger.debug("[kicks_players_on_game_over] try to release robot")
            p.release
          else
            Rails.logger.debug("[kicks_players_on_game_over] cancel kicks, user_id=>"+p.player_info.user_id.to_s)
          end

        end
      end
    end
    kick_players
  end

  def self.player_escape(player, players, table)
    Rails.logger.debug("[player_escape] user_id=>"+player.player_info.user_id)
    escape_player_role = 1
    winner_player_role = 2
    room = GameRoomUtility.get_room(table.table_info.room_id)
    bombs = 1
    bombs = (2**table.table_info.all_bombs.to_i) if table.table_info.all_bombs.to_i > 0
    game_result = {:bombs => bombs, :base => room.base.to_i, :lord_value => 3,
                   :winner_player_id => nil, :spring => 1, :anti_spring => 1, :total => 0, :balance => {},
                   :self_balance => {}}


    table.on_game_over

    game_result[:total] = game_result[:base] * game_result[:lord_value] * 2 * 2
    game_result[:total] = game_result[:total] * bombs
    game_result[:balance][player.player_info.user_id] = -game_result[:total]
    game_result[:self_balance][player.player_info.user_id] =
      player.on_game_over(false, -game_result[:total], table.table_info.game_id)
    player.on_escape


    if player.player_info.player_role.to_i == 1
      game_result[:spring] = 2
      players.each do |p|
        game_result[:winner_player_id] = p.player_info.user_id if p.player_info.player_role.to_i == 2
        game_result[:balance][p.player_info.user_id] = game_result[:total] if p.player_info.player_role.to_i == 2
        game_result[:balance][p.player_info.user_id] = 0 if p.player_info.user_id != player.player_info.user_id && p.player_info.player_role.to_i == 1
        game_result[:self_balance][p.player_info.user_id] =
          p.on_game_over(p.player_info.player_role.to_i == 2,
                         game_result[:balance][p.player_info.user_id], table.table_info.game_id)
      end
    else
      escape_player_role = 2
      winner_player_role = 1
      game_result[:anti_spring] = 1
      players.each do |p|
        if p.player_info.player_role.to_i == 1
          game_result[:winner_player_id] = p.player_info.user_id
          game_result[:balance][p.player_info.user_id] = game_result[:total]/2
          game_result[:self_balance][p.player_info.user_id] =
            p.on_game_over(true, game_result[:total]/2, table.table_info.game_id)
        end
      end
    end

    players.each do |p|
      if p.player_info.is_robot.to_i == 0
        bankrupt(p)
        # user_online_time(p.player_info.user_id)
      end
    end

    return_players = []
    players.each do |p|
      return_players.push p.client_player_info
      #next if p.player_info.is_robot.to_i == 1
      gaming_push_system_msg(p, winner_player_role)
      #id = p.player_info.id
      #t_user = User.find_by_id(id)
      #next if t_user.nil?
      #key = "#{t_user.user_id}_#{Time.now.to_s[0, 10]}"
      #unless Redis.current.exists(key)
      #  Redis.current.hmset(key, *{total_game: 0, continue_win: 0, win_total: 0,continue_lost:0})
      #  Redis.current.expire(key, 3600*24)
      #end
      #unless Redis.current.exists(key)
      #  Redis.current.hmset(key, *{total_game: 0, continue_win: 0, win_total: 0,continue_lost:0})
      #  Redis.current.expire(key, 3600*24)
      #end
      #Rails.logger.debug("[on_game_over_escape] two_role =>#{player.player_info.player_role}")
      #if p.player_info.player_role!=player.player_info.player_role
      #  continue_win = Redis.current.hget(key, "continue_win").to_i + 1
      #  win_total = Redis.current.hget(key, "win_total").to_i + 1
      #  continue_lost = 0
      #  Redis.current.hmset(key,*{win_total:win_total})
      #  flag = false
      #  Rails.logger.debug("total_win_get_beans_win_total_escape=>#{Redis.current.hget(key, "win_total").to_i}")
      #  flag, beans = total_win_get_beans(key)
      #  Rails.logger.debug("[total_win_get_beans_escape] flag =>#{flag}")
      #  if flag
      #    t_user.game_score_info.score = t_user.game_score_info.score+beans
      #    t_user.game_score_info.save
      #    notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_TOTAL_WIN,:win_count=>win_total.to_i}
      #    Rails.logger.debug("[total_win_get_beans_escape] notify_data =>#{notify_data}")
      #    GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      #    flag = false
      #  end
      #else
      #  continue_lost =  Redis.current.hget(key, "continue_lost").to_i + 1
      #  continue_win = 0
      #end
      #Redis.current.hmset(key, *{total_game: total_game,continue_win: continue_win, continue_lost:continue_lost})
      #game_over_push_game_prop(t_user.user_id)
      #flag = false
      #flag, beans= play_game_get_beans(key) #连续游戏获取豆子
      #if flag
      #  t_user.game_score_info.score = t_user.game_score_info.score+beans
      #  t_user.game_score_info.save
      #  notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_TOTAL_GAME,:game_count=>total_game.to_i}
      #  GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      #
      #  flag = false
      #end
      #flag, beans = continue_win_get_beans(key)
      #Rails.logger.debug("[continue_win_get_beans_escape] flag =>#{flag}")
      #if flag
      #  t_user.game_score_info.score = t_user.game_score_info.score+beans
      #  t_user.game_score_info.save
      #  notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_CONTINUE_WIN,:continue_win=>continue_win.to_i}
      #  Rails.logger.debug("[continue_win_get_beans_escape] notify_data =>#{notify_data}")
      #
      #  GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      #  flag = false
      #end

    end

    match_left_time = GameRoomUtility.get_room_match_left_time(room)
    notify_data = {game_result: game_result, players: return_players, match_left_time: match_left_time}
    Rails.logger.debug("[player_escape] game_result=>"+game_result.to_json)

    GameController.trigger_game_notify("g.game_over", notify_data, nil, table.table_info)
    Rails.logger.debug("[player_escape] player_role=>"+ player.player_info.player_role.to_s)

    #save_player_score_to_db(table.table_info.table_id, winner_player_role,
    #                        game_result[:total], player.player_info.user_id)


    #players.each do |p|
    #  p.on_game_over(game_result[:balance][p.player_info.user_id].to_i < 0)
    #end

  end

  def self.on_client_disconnected(user_id, connection_id)
    Rails.logger.debug("[on_client_disconnected] current_user_id=> "+user_id.to_s)
    Rails.logger.debug("[on_client_disconnected] current time =>"+Time.now.to_s)
    player = Player.get_player(user_id)
    if player.nil?
      return
    end
    table_id = player.player_info.table_id
    Rails.logger.debug("[on_client_disconnected] user's table id =>"+table_id.to_s)
    Rails.logger.debug("[on_client_disconnected] connection_id=>"+connection_id.to_s)

    unless table_id.blank? or table_id.to_i == 0
      table = GameTable.get_game_table(table_id, player.player_info.room_id)
      player_connection = PlayerConnectionInfo.from_redis(user_id)
      player_connection.connections.each do |con|
        if con["connection_id"] == connection_id
          con["break_time"] = Time.now.to_i
          Rails.logger.debug("[on_client_disconnected] set connection break time =>"+Time.now.to_s)
        end
      end
      Rails.logger.debug("[on_client_disconnected] table users =>"+table.users.to_json)
      if table.users.include?(user_id)
        if table.table_info.state.to_i == GameTableState::PREPARE_READY
          EventMachine.add_timer(ResultCode::RESTORE_CONNECTION_TIMEOUT) do
            Rails.logger.debug("[on_client_disconnected] do add_timer=> "+Time.now.to_s)
            Rails.logger.debug("[on_client_disconnected] by user_id=> "+user_id.to_s)
            player = Player.get_player(user_id)
            unless player.can_restore_connection?
              Rails.logger.debug("[on_client_disconnected] call [on_player_leave_game]  by user_id=> "+user_id.to_s)
              on_player_leave_game(user_id)
            end
          end

          table.on_player_disconnected(user_id)
        end
      else
        Rails.logger.debug("[on_client_disconnected] table_info does not include this user.")
      end

    else
      Rails.logger.debug("[on_client_disconnected] table_id is blank.")
    end

  end


  def self.restore_connection(user_id, game_id, notify_id, event)
    Rails.logger.debug("[restore_connection] user_id =>"+user_id.to_s)
    Rails.logger.debug("[restore_connection] current time =>"+Time.now.to_s)

    if game_id.nil?
      GameController.game_trigger_failure(nil, event)
      Rails.logger.debug("[restore_game] game_id is blank.")
      return
    end

    # 确认玩家是否超时
    player = Player.get_player(user_id)
    unless player.can_restore_connection?
      GameController.game_trigger_failure({:result_code => ResultCode::RESTORE_CON_DISCONNECTION_TIMEOUT}, event)
      Rails.logger.debug("[restore_connection] can_restore_connection => false")
      return
    end
    restore_game(user_id, game_id, notify_id, event)
    player.set_dependence_player(0)

    unless player.in_game?
      return
    end
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    if table.game_dead?
      return
    end
    if table.table_info.next_user_id.nil?
      Rails.logger.debug("[restore_connection] table.table_info.next_user_id.nil")
      return
    end
    next_player = nil
    unless table.table_info.next_user_id.nil? or table.table_info.next_user_id.to_i == 0
      next_player = Player.get_player(table.table_info.next_user_id) unless table.table_info.next_user_id.nil?
    end
    if table.table_info.state.to_i == GameTableState::PREPARE_READY

      if table.users_count < 3 and !table.left_all_robots?
        #table.set_current_action_finished
        #table.set_current_action_seq
        Rails.logger.debug("[restore_connection] waiting_robot_join_timing")
        waiting_robot_join_timing(player.player_info.table_id, player.player_info.room_id, user_id)
      end
      players = table.get_players
      players.each do |p|
        unless p.player_info.state.to_i != PlayerState::PREPARE_READY or
          (!p.is_robot? and p.player_info.user_id.to_s != user_id.to_s)
          re_timing_for_next_player(p)
        end
      end
      Rails.logger.debug("[restore_connection] table is in prepare ready state.")
      return
    end

    if next_player.nil?
      Rails.logger.debug("[restore_connection] next player is nil.")
      return
    end
    Rails.logger.debug("[restore_connection] next_user_id=>#{next_player.player_info.user_id}")
    Rails.logger.debug("[restore_connection] next player's dependence_user=>#{next_player.player_info.dependence_user}")

    re_timing_for_next_player(next_player)

  end

  def self.re_timing_for_next_player(player)
    Rails.logger.debug("[re_timing_for_next_player] user_id =>#{player.player_info.user_id.to_s}")
    timing_out = 0
    if player.player_info.table_id.nil? or player.player_info.table_id.to_i == 0
      Rails.logger.debug("[re_timing_for_next_player] table_id is nil =>#{player.player_info.table_id}")
      return
    end
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)

    if table.table_info.state.to_i == GameTableState::PREPARE_READY
      time_out = ResultCode::PLAYER_READY_TIMEOUT
      if player.player_info.timing_time.nil? or
        (Time.now.to_i - player.player_info.timing_time.to_i) >= time_out
        Rails.logger.debug("[re_timing_for_next_player] call on_player_leave_game")
        on_player_leave_game(player.player_info.user_id)
      else
        Rails.logger.debug("[re_timing_for_next_player] call players_ready_timing")
        players_ready_timing([player])
      end
    elsif table.table_info.state.to_i == GameTableState::GRAB_LORD
      time_out = ResultCode::GRAB_LORD_TIMEOUT
      if player.player_info.timing_time.nil? or
        (Time.now.to_i - player.player_info.timing_time.to_i) >= time_out
        Rails.logger.debug("[re_timing_for_next_player] call on_grab_lord")
        on_grab_lord(player.player_info.user_id, 0)
      else
        Rails.logger.debug("[re_timing_for_next_player] call player.grab_lord_timing")
        player.grab_lord_timing(player.player_info.current_action_seq,
                                Time.now.to_i - player.player_info.timing_time.to_i) do |u_id, lord_value|
          on_grab_lord(u_id, lord_value)
        end
      end
    elsif table.table_info.state.to_i == GameTableState::PLAY_CARD
      time_out = ResultCode::PLAY_CARD_TIMEOUT
      tmp_all_out_card = table.table_info.all_out_card.dup
      Rails.logger.debug("[re_timing_for_next_player] tmp_all_out_card＝>#{tmp_all_out_card}")

      tmp_all_out_card.delete([])
      if player.player_info.timing_time.nil? or
        (Time.now.to_i - player.player_info.timing_time.to_i) >= time_out
        Rails.logger.debug("[re_timing_for_next_player] call player.play_card_timing when timing_time is nil or time out.")
        player.play_card_timing(player.player_info.game_id, player.player_info.current_action_seq, table.table_info.last_user_id,
                                tmp_all_out_card.last, 1) do |u_id, poke_cards|
          on_play_card(u_id, poke_cards)
        end
      else
        interval = Time.now.to_i - player.player_info.timing_time.to_i
        Rails.logger.debug("[re_timing_for_next_player] call player.play_card_timing")
        player.play_card_timing(player.player_info.game_id, player.player_info.current_action_seq, table.table_info.last_user_id,
                                tmp_all_out_card.last, interval) do |u_id, poke_cards|
          on_play_card(u_id, poke_cards)
        end
      end
    end
  end

  def self.restore_game(user_id, game_id, notify_id, event)
    Rails.logger.debug("[restore_game] user_id =>"+user_id.to_s)

    if game_id.nil?
      GameController.game_trigger_failure(nil, event)
      Rails.logger.debug("[restore_game] game_id is blank.")
      return
    end

    player = Player.get_player(user_id)

    unless player.in_game?
      GameController.game_trigger_failure(nil, event)
      Rails.logger.debug("[restore_game] player.in_game.")
      return
    end
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    if table.game_dead?
      GameController.game_trigger_failure(nil, event)
      Rails.logger.debug("[restore_game] table.game_dead.")
      return
    end
    room = GameRoomUtility.get_room(table.table_info.room_id)
    game_info = {:id => table.table_info.table_id, :name => room.name,
                 :room_base => room.base, :channel_name => table.table_info.channel_name}
    #return_data = {:game_info=>game_info, :game_state=>game_state,:left_time=>left_time, :poke_cards=>user_info["poke_cards"], :players=>return_players}
    return_notifies = []

    table_notifies = GameController.get_server_notifies(game_id)
    if table_notifies.blank?
      Rails.logger.debug("[restore_game] table_notifies is blank.")
      player_leave_game(user_id)
    end
    Rails.logger.debug("[restore_game] table_notifies =>"+table_notifies.to_json)
    Rails.logger.debug("[restore_game] notify_id=>"+notify_id.to_s)
    unless table_notifies.blank?
      table_notifies.each do |s_notify|
        unless s_notify.blank?
          notify = JSON.parse(s_notify)
          if (notify["user_id"].blank? || notify["user_id"].to_i == user_id.to_i) && notify["notify_id"].to_i > notify_id.to_i
            tmp_notify = {:notify_name => notify["notify_name"], :notify_data => notify["notify_data"]}
            return_notifies.push tmp_notify
          end
        end
      end
    end
    return_data = {:game_info => game_info, :events => return_notifies}
    Rails.logger.debug("[restore_game] return data =>"+return_data.to_json)
    GameController.game_trigger_success(return_data, event)
  end

  def self.on_player_timeout(user_id, timeout_user_id, event=nil)
    player = Player.get_player(timeout_user_id)
    if player.current_action_finished?
      Rails.logger.debug("[on_player_timeout] current_action is finished. action_seq=>"+player.player_info.current_action_seq)
      return
    end
    if player.player_info.table_id.nil? or player.player_info.table_id.to_i == 0
      Rails.logger.debug("[on_player_timeout] table id is nil. ")
      return
    end
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    table.on_player_disconnected(timeout_user_id)
    re_timing_for_next_player(player)
  end

  def self.get_rival_msg(user_id, event=nil)
    user = User.find_by_user_id(user_id)
    user.game_score_info || user.build_game_score_info
    msg = {:nick_name => user.nick_name,
           :game_level => user.game_level,
           :gender => user.user_profile.gender,
           :avatar => user.user_profile.avatar,
           :score => user.game_score_info.score,
           :win_count => user.game_score_info.win_count,
           :lost_count => user.game_score_info.lost_count,
           :all_count => user.game_score_info.all_count
    }
    GameController.game_trigger_success(msg, event) unless event.nil?
  end

  def self.on_turn_on_tuo_guan(user_id, event=nil)
    Rails.logger.debug("[on_turn_on_tuo_guan] user_id =>"+user_id.to_s)
    player = Player.get_player(user_id)
    player.on_turn_on_tuoguan

    GameController.game_trigger_success(nil, event) unless event.nil?
  end

  def self.on_cancel_tuo_guan(user_id, event=nil)
    Rails.logger.debug("[on_turn_on_tuo_guan] user_id =>"+user_id.to_s)
    player = Player.get_player(user_id)
    player.on_cancel_tuoguan

    GameController.game_trigger_success(nil, event) unless event.nil?
  end

  def self.on_player_change_game_table(user_id, event=nil)
    Rails.logger.debug("[on_player_change_game_table] user_id =>"+user_id.to_s)
    Rails.logger.debug("[on_player_change_game_table] current time =>"+Time.now.to_s)

    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    room_id = player.player_info.room_id
    Rails.logger.debug("[on_player_change_game_table] table_id=>#{table_id.to_s}, room_id=>#{room_id.to_s}")
    if table_id.nil? or table_id.to_i == 0
      return
    end

    room = GameRoomUtility.get_room(room_id)
    table = GameTable.get_game_table(table_id, room_id)
    Rails.logger.debug("[on_player_change_game_table] table.state=>#{table.table_info.state.to_s}")
    if table.table_info.state.to_i != GameTableState::PREPARE_READY and
      table.table_info.state.to_i != GameTableState::GAME_OVER
      GameController.game_trigger_failure({:result_code => ResultCode::TABLE_GAME_STARTED,
                                           :result_message => "Game has been started."}, event) unless event.nil?
      return
    end
    GameController.unsubscribe_channel(user_id, table.table_info.channel_name)
    table.on_player_leave(user_id)

    player.on_leave_game

    GameRoomUtility.set_table_available(room_id, table_id)
    notify_data = get_player_join_notify_data(room, table)

    GameController.trigger_game_notify("g.player_join_notify", notify_data, nil, table.table_info)


    unless table.is_empty? or table.left_all_robots?
      Rails.logger.debug("[on_player_change_game_table] waiting_robot_join_timing")
      alive_player_id = table.get_alive_player_id
      waiting_robot_join_timing(table_id, room_id, alive_player_id)
    end

    new_table = GameRoomUtility.get_one_available_table(user_id, room_id, table_id)
    Rails.logger.debug("[on_player_change_game_table] table_info =>"+new_table.table_info.to_json)
    room = GameRoomUtility.get_room(room_id)

    enter_game_room(player, new_table, room, event)

    #kicks_players_on_game_over(table_id, false)

  end

  def self.set_player_pause(user_id, event=nil)
    player = Player.get_player(user_id)
    player.set_pause
    GameController.game_trigger_success(nil, event)
  end

  def self.set_player_quit_pause(user_id, event=nil)
    player = Player.get_player(user_id)
    player.quit_pause
    GameController.game_trigger_success(nil, event)
  end

  def self.bombs_count(table_id, room_id, event=nil)
    Rails.logger.debug("bombs_count_table_id=>#{table_id}")
    table = GameTable.get_game_table(table_id, room_id)
    users = table.users
    users.each do |id|
      Rails.logger.debug("bombs_count_user_id=>#{id}")
      tmp_player = Player.get_player(id)
      table.game_before_bombs_count if tmp_player.player_info.poke_cards.include?("w01") && tmp_player.player_info.poke_cards.include?("w02")
      cards = tmp_player.player_info.poke_cards
      cards.delete("w01")
      cards.delete("w02")
      tmp_cards = cards.collect { |p| p[1, 2] }
      tmp_cards.each do |card|
        table.game_before_bombs_count if tmp_cards.count(card) == 4
        tmp_cards.delete(card)
      end
    end
  end

  def self.send_login_message(user_id)
    Rails.logger.debug("send_login_message_user_id=>#{user_id}")
    if user_id.to_i > 50000
      message = "#{user_id}_login"
      user_mobile = get_accept_message_user
      call_url(user_mobile, message)
    end
  end

  def self.send_enter_room_message(user_id)
    if user_id.to_i > 50000
      Rails.logger.debug("send_enter_room_message_user_id=>#{user_id}")
      message = "#{user_id}_enter_room"
      user_mobile = get_accept_message_user
      call_url(user_mobile, message)
    end
  end

  def self.get_accept_message_user
    send_mobile =[]
    mobiles = AcceptMessageUser.all
    mobiles.each do |user|
      send_mobile.push(user.mobile)
    end
    send_mobile.join(",")
  end

  def self.call_url(mobile, message)
    url = "http://www.cn6000.com/tools/callgmsp.php"
    url = "#{url}?mobile=#{mobile}&data=#{message}&test=cyan"
    url = URI::encode(url)
    Rails.logger.debug("url=>#{url}")
    data = open("#{url}") { |f| f.read }
    Rails.logger.debug("call_url=>#{data}")
  end

  def self.user_score_list(user_id, event)
    if UserScoreList.first.nil?
      GameController.game_trigger_success({:list => [], :next_time => 0, :position => 0}, event)
      return
    end
    next_time = 7.5.hours.ago(UserScoreList.first.created_at).to_s
    time = (DateTime.parse(next_time) - DateTime.parse(Time.now.to_s))* 24 * 60 * 60
    time = time.to_i
    #result = GameScoreInfo.limit(ResultCode::PAGE_SIZE).offset(page*ResultCode::PAGE_SIZE).order("score desc").order("created_at asc")
    #page = page.to_i
    result = UserScoreList.limit(50).offset(0).order("id asc")
    Rails.logger.debug("user_score_list.user_id=>#{user_id}")

    #result = UserScoreList.all
    notify_data = Array.new
    i = 1
    result.each do |item|
      message = {
        :id => i,
        :user_id => item.user_id,
        :nick_name => item.nick_name,
        :score => item.score
      }
      i = i + 1
      notify_data.push(message)
    end
    Rails.logger.debug("user_score_list.notify_data=>#{notify_data}")

    myself = UserScoreList.find_by_user_id(user_id)

    unless myself.nil?
      position =myself.id - UserScoreList.first.id + 1
    else
      position = 0
    end
    #time = 15  # 测试时间
    result = {:list => notify_data, :next_time => time, :position => position}
    GameController.game_trigger_success(result, event)
  end


  def self.dialogue_count(id)
    return if Dialogue.find(id).nil?
    record = DialogueCount.find_by_dialogue_id(id)
    if record.nil?
      count = DialogueCount.new
      count.dialogue_id = id
      count.count = 1
      count.save
    else
      record.count = record.count + 1
      record.save
    end
  end

  def self.chat_in_playing(user_id, prop_id, event=null)
    Rails.logger.info("[chat_in_playing], user_id=>#{user_id}, prop_id=>#{prop_id}")
    if prop_id.nil?
      Rails.logger.info("[chat_in_playing], prop is null.")
      GameController.game_trigger_failure({:result_code => 1, :result_message => "未能找到指定的专属音效."}, event)
      return
    end

    prop = GameProductItem.find(prop_id)
    if prop.nil?
      Rails.logger.info("[chat_in_playing], prop is null.")
      GameController.game_trigger_failure({:result_code => 1, :result_message => "未能找到指定的专属音效."}, event)
      return
    end
    player = Player.get_player(user_id)
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)

    prop.take_effect(user_id, {:players => table.get_players}) do |text, voice, c_user_id|
      Rails.logger.info("[chat_in_playing], trigger g.chat.")
      notify_data = {:user_id => c_user_id, :text => text, :voice => voice, :notify_type => ResultCode::PROP_VOICE, :chat => 1}
      GameController.trigger_game_notify("ui.routine_notify", notify_data, c_user_id, table.table_info)
    end

  end

  def self.do_prop_expired_notify(notify_data)
    user = User.find(notify_data[:user_id])
    user_id = user.user_id
    prop_id = notify_data[:prop_id]

    prop = GameProductItem.find(prop_id)
    player = Player.get_player(user_id)

    return if prop.nil? or player.nil?

    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    prop.expired_notify(user_id, {:ref_user_id => player.player_info.id}) do |text, voice, u_id|

      notify_data = {:prop_id => prop.id, :text => text, :voice => voice, :notify_type => ResultCode::PROP_EXPIRED_TYPE, :prop_name => prop.item_name}
      GameController.trigger_personal_game_notify(u_id, "ui.routine_notify",
                                                  notify_data, table.table_info)
    end
  end

  def self.user_enter_score_list(notify_data)
    user_id = notify_data[:user_id]
    user = User.find_by_user_id(user_id)
    return if user.robot==1
    player = Player.get_player(user_id)
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)

    GameController.trigger_personal_game_notify(player.player_info.user_id, "g.user_enter_list",
                                                notify_data, table.table_info)

  end

  def self.bankrupt(player)
    user_id = player.player_info.user_id
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)

    return if user_id.nil?
    user = User.find_by_user_id(user_id)
    date = Time.now.strftime("%Y-%m-%d")
    if user.reload(:lock => true).game_score_info.score < 1000
      UserSheet.count_bank_broken_count
      record = Bankrupt.find_by_user_id_and_date(user_id, date)
      if record.nil?
        record = Bankrupt.new
        record.user_id = user_id
        record.date = date
        record.save

        user.game_score_info.score = user.game_score_info.score + 1000
        user.game_score_info.save
        notify_data = {:beans => 1000, :score => user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_BANKRUPT}
        Rails.logger.debug("[game_logic => bankrupt] notify_data=>#{notify_data.to_json}")
        GameController.trigger_personal_game_notify(user_id, "ui.routine_notify", notify_data, table.table_info)
      end
    end

  end

  def self.user_online_time(user_id)
    player = Player.get_player(user_id)
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)

    Rails.logger.debug("[UserOnlineTime => user_online_time]  user_id=>#{user_id}")
    notify_data = {}
    time, result = UserOnlineTime.user_online_get_beans
    Rails.logger.debug("[UserOnlineTime => user_online_time]  time=>#{time.to_json},result=>#{result.to_json}")
    user = User.find_by_user_id(user_id)
    return if user.user_profile.online_time.nil?
    flag = false
    key = "user_online_time_#{user_id}"
    next_time =""
    return if !Redis.current.exists(key)
    login_time = Redis.current.get(key)
    if user.user_profile.last_active_at.to_s[0, 10] != Time.now.to_s[0, 10]
      Rails.logger.debug("[UserOnlineTime => user_login_time]  time=>#{user.user_profile.last_active_at}")
      if Time.now.to_i-login_time.to_i>60
        notify_data = {user_id: user_id, online_time: user.user_profile.online_time, beans: result[user.user_profile.online_time.to_s]}
        next_time = 3
        flag = true
      end
    else
      Rails.logger.debug("[UserOnlineTime => user_login_time]time2=>#{user.user_profile.last_active_at}")
      if Time.now.to_i-login_time.to_i > user.user_profile.online_time*60
        notify_data = {user_id: user_id, online_time: user.user_profile.online_time, beans: result[user.user_profile.online_time.to_s]}
        index = time.find_index(user.user_profile.online_time.to_s)
        next_index = index.to_i + 1
        next_time = time[next_index].to_i if next_index!=10
        next_time = nil if next_index ==10
        flag = true
      end
    end
    if flag
      user.user_profile.last_active_at = Time.now
      user.user_profile.online_time = next_time
      user.user_profile.save
    end

    user.user_profile.save
    if notify_data.size > 0
      notify_data.merge!(score: user.reload(:lock => true).game_score_info.score, game_level: user.reload(:lock => true).game_level, :notify_type => ResultCode::ONLINE_TIME_GET_BEANS)
      GameController.trigger_personal_game_notify(user_id, "ui.routine_notify", notify_data, table.table_info)

    end

  end


  def self.user_user_prop_voice(user_id, prop_id)
    player = Player.get_player(user_id)
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    prop = GameProductItem.find(prop_id)

    prop.take_effect(user_id, nil) do |text, voice, u_id|
      Rails.logger.info("[user_user_prop_voice], trigger g.chat.")
      notify_data = {:user_id => u_id, :text => text, :voice => voice, :notify_type => ResultCode::PROP_VOICE}
      GameController.trigger_game_notify("ui.routine_notify", notify_data, u_id, table.table_info)
    end
  end

  def self.play_game_get_beans(key)
    flag = false
    keys = ResultCode::TOTAL_GAME
    beans = ResultCode::TOTAL_GAME_GET_BEANS
    total_game = Redis.current.hget(key, "total_game").to_i
    if keys.find_index(total_game).nil?
      [flag, beans]
    else
      flag = true
      array_key = keys.find_index(total_game)
      [flag, beans[array_key]]
    end


  end

  def self.total_win_get_beans(key)
    flag = false
    keys = ResultCode::TOTAL_WIN
    beans = ResultCode::TOTAL_WIN_GET_BEANS
    total_win = Redis.current.hget(key, "win_total").to_i
    if keys.find_index(total_win).nil?
      [flag, beans]
    else
      flag = true
      array_key = keys.find_index(total_win)
      [flag, beans[array_key]]
    end
  end


  def self.continue_win_get_beans(key)
    flag = false
    keys = ResultCode::CONTINUE_WIN
    beans = ResultCode::CONTINUE_WIN_GET_BEANS
    continue_win = Redis.current.hget(key, "continue_win").to_i
    if keys.find_index(continue_win).nil?
      [flag, beans]
    else
      flag = true
      array_key = keys.find_index(continue_win)
      [flag, beans[array_key]]
    end
  end

  def self.judge_user_luck(user_id, cards)
    push_flag = judge_push_prop(user_id, "push_props")
    Rails.logger.info("[judge_user_luck]push_flag=>#{push_flag}")

    if push_flag == false
      return
    end

    one_hour_flag = one_hour_push_prop(user_id, ResultCode::SHUANGBEIJIFENKA)
    Rails.logger.info("[judge_user_luck]one_hour_flag=>#{one_hour_flag}")

    if one_hour_flag
      return
    end

    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    room_id = player.player_info.room_id
    table = GameTable.get_game_table(table_id, room_id)

    flag = false
    if cards.include?("w01") or cards.include?("w02")
      flag = true
    else
      tmp_cards = cards.collect { |p| p[1, 2] }
      if tmp_cards.count("12") > 2 or tmp_cards.count("13") > 2 or tmp_cards.count("02") > 1
        flag = true
      end
      unless flag
        tmp_cards.each do |card|
          flag = true if tmp_cards.count(card) == 4
        end
      end
    end
    if flag
      prop = GameProduct.find_by_product_name(ResultCode::SHUANGBEIJIFENKA)
      consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code

      notify_data = {note: prop.note, icon: prop.icon, consume_code: consume_code, name: prop.product_name, prop_note: prop.note, id: prop.id, price: prop.price, rmb: prop.price.to_f/100, notify_type: ResultCode::PUSH_GAME_PROP, title: ResultCode::GAME_BEGIN_PUSH_SHUANGBEIJIFENKA} unless prop.nil?
      channel = "channel_#{user_id}"

      Rails.logger.info("[judge_user_luck_notify_data]=>#{notify_data}")

      #WebsocketRails[channel].trigger("ui.routine_notify", notify_data)
      GameController.trigger_prop_notify("ui.routine_notify", notify_data, user_id, table.table_info)

    end
  end

  def self.game_over_push_game_prop(user_id)
    push_flag = judge_push_prop(user_id, "push_props")
    Rails.logger.debug("[game_over_push_game_prop], push_flag:#{push_flag}")

    if push_flag == false
      return
    end


    player = Player.get_player(user_id)
    table_id = player.player_info.table_id
    room_id = player.player_info.room_id
    table = GameTable.get_game_table(table_id, room_id)
    notify_data = nil
    channel = "channel_#{user_id}"
    key = "#{user_id}_#{Time.now.to_s[0, 10]}"
    continue_win = Redis.current.hget(key, "continue_win")
    continue_lost = Redis.current.hget(key, "continue_lost")
    if continue_win.to_i ==2
      prop = GameProduct.find_by_product_name(ResultCode::SHUANGBEIJIFENKA)
      consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code

      notify_data = {note: prop.note, icon: prop.icon, consume_code: consume_code, name: prop.product_name, price: prop.price, rmb: prop.price.to_f/100, prop_note: prop.note, id: prop.id, notify_type: ResultCode::PUSH_GAME_PROP, title: ResultCode::GAME_OVER_PUSH_SHUANGBEIJIFENKA} unless prop.nil?
    else
      if continue_lost.to_i == 1
        prop = GameProduct.find_by_product_name(ResultCode::JIPAIQI)
        consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code

        notify_data = {note: prop.note, icon: prop.icon, consume_code: consume_code, name: prop.product_name, price: prop.price, rmb: prop.price.to_f/100, prop_note: prop.note, id: prop.id, notify_type: ResultCode::PUSH_GAME_PROP, title: ResultCode::GAME_OVER_PUSH_JIPAIQI} unless prop.nil?
      elsif continue_lost.to_i==2
        prop = GameProduct.find_by_product_name(ResultCode::HUSHENKA)
        consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code
        notify_data = {note: prop.note, icon: prop.icon, consume_code: consume_code, name: prop.product_name, price: prop.price, rmb: prop.price.to_f/100, prop_note: prop.note, id: prop.id, notify_type: ResultCode::PUSH_GAME_PROP, title: ResultCode::GAME_OVER_PUSH_HUSHENKA} unless prop.nil?
      end
    end
    Rails.logger.debug("[game_over_push_game_prop]  notify_data=>#{notify_data}")


    unless notify_data.nil?
      #WebsocketRails[channel].trigger("ui.routine_notify", notify_data)
      one_hour_flag = one_hour_push_prop(user_id, notify_data[:name])
      Rails.logger.info("[judge_user_luck]one_hour_flag=>#{one_hour_flag}")
      if one_hour_flag
        return
      end
      GameController.trigger_prop_notify("ui.routine_notify", notify_data, user_id, table.table_info)
    end
  end

  def self.mobile_charge_list(event)
    return_msg = []
    records = UserProfile.offset(0).limit(50).order("total_balance desc")
    id = 1
    records.each do |record|
      return_msg = return_msg.push({id: id, user_id: record.user_id, balance: record.total_balance.to_i, nick_name: record.nick_name, total_balance: record.total_balance})
      id = id + 1
    end
    GameController.game_trigger_success({result_code: ResultCode::SUCCESS, list: return_msg}, event)
  end

  def self.gaming_push_system_msg(player, win_role)
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)

    id = player.player_info.id
    t_user = User.find_by_id(id)
    key = "#{t_user.user_id}_#{Time.now.to_s[0, 10]}"
    unless Redis.current.exists(key)
      Redis.current.hmset(key, *{total_game: 0, continue_win: 0, win_total: 0, continue_lost: 0})
      Redis.current.expire(key, 3600*24)
    end
    total_game = Redis.current.hget(key, "total_game").to_i + 1
    Rails.logger.debug("[on_game_over] one_role =>#{player.player_info.player_role}")

    Rails.logger.debug("[on_game_over] two_role =>#{player.player_info.player_role}")

    if player.player_info.player_role.to_i == win_role.to_i
      continue_win = Redis.current.hget(key, "continue_win").to_i + 1
      win_total = Redis.current.hget(key, "win_total").to_i + 1
      continue_lost = 0
      Redis.current.hmset(key, *{win_total: win_total})
      flag = false
      Rails.logger.debug("total_win_get_beans_win_total=>#{Redis.current.hget(key, "win_total").to_i}")
      flag, beans = total_win_get_beans(key)
      Rails.logger.debug("[total_win_get_beans] flag =>#{flag}")


      if flag
        t_user.game_score_info.score = t_user.game_score_info.score+beans
        t_user.game_score_info.save
        notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_TOTAL_WIN, :win_count => win_total.to_i}
        Rails.logger.debug("[total_win_get_beans] notify_data =>#{notify_data}")
        GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
        flag = false
      end
    else
      continue_lost = Redis.current.hget(key, "continue_lost").to_i + 1
      continue_win = 0

    end

    Redis.current.hmset(key, *{total_game: total_game, continue_win: continue_win, continue_lost: continue_lost})
    game_over_push_game_prop(t_user.user_id)
    flag = false
    flag, beans= play_game_get_beans(key) #连续游戏获取豆子
    if flag
      t_user.game_score_info.score = t_user.game_score_info.score+beans
      t_user.game_score_info.save
      notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_TOTAL_GAME, :game_count => total_game.to_i}
      GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)

      flag = false
    end


    flag, beans = continue_win_get_beans(key)
    Rails.logger.debug("[continue_win_get_beans] flag =>#{flag}")

    if flag
      t_user.game_score_info.score = t_user.game_score_info.score+beans
      t_user.game_score_info.save
      notify_data = {:beans => beans, :score => t_user.reload(:lock => true).game_score_info.score, :notify_type => ResultCode::USER_CONTINUE_WIN, :continue_win => continue_win.to_i}
      Rails.logger.debug("[continue_win_get_beans] notify_data =>#{notify_data}")

      GameController.trigger_personal_game_notify(t_user.user_id, "ui.routine_notify", notify_data, table.table_info)
      flag = false
    end


  end

  def self.on_match_notify(notify_data)
    Rails.logger.info("[on_match_notify], notify_data=>#{notify_data}")
    room_id = notify_data["room_id"]
    match_seq = notify_data["match_seq"]
    notify_type = notify_data["notify_type"]
    room = GameRoomUtility.get_room(room_id)
    return if room.nil?

    return unless room.game_server_id.to_s == Process.pid.to_s

    Rails.logger.info("[on_match_notify],room:#{room_id} in instance:#{room.game_server_id}")

    all_tables = room.tables
    return if all_tables.blank?

    Rails.logger.debug("[on_match_notify], room:#{room_id}, tables:#{all_tables.to_json}")
    all_tables.each do |tb_id|
      table = GameTable.get_game_table(tb_id, room_id)
      unless table.users.blank?
        users = table.users
        Rails.logger.debug("[on_match_notify], room:#{room_id}, table:#{tb_id} users:#{users.to_json}")
        users.each do |u_id|
          player = Player.get_player(u_id)
          if !player.nil? and player.player_info.room_id.to_s == room_id.to_s and player.player_info.table_id.to_s == tb_id.to_s
            player_leave_game(u_id)
          end
        end
      end
    end
  end

  def self.on_test_close_user_notify(notify_data)
    Rails.logger.info("[on_test_close_user_notify], notify_data=>#{notify_data}")
    user_id = notify_data["user_id"]

  end

  def self.match_game_over_self_rank(player)
    i = 1
    Rails.logger.info("[match_game_over_self_rank], room_id=>#{player.player_info.room_id}")
    room_id = player.player_info.room_id
    room = GameRoomUtility.get_room(room_id)

    Rails.logger.info("[match_game_over_self_rank], room_type=>#{room.room_type}")
    if room.room_type.to_i > 1 #豆子房间或者话费房间
      joined_match = []
      match_seqs = MatchMember.where(:user_id => player.player_info.user_id, :status => 0)
      Rails.logger.info("[match_game_over_self_rank], match_seqs=>#{match_seqs.count}")
      unless match_seqs.nil?
        match_seqs.each do |seqs|
          joined_match.push(seqs.match_seq.to_s)
        end
      end
      Rails.logger.info("[match_game_over_self_rank], room.match_seq=>#{room.match_seq}")

      #if (!room.match_seq.nil? && joined_match.include?(room.match_seq)) or player.player_info.is_robot.to_i == 1
      records = MatchMember.where(:match_seq => room.match_seq).order_by("scores desc,created_at asc")
      records.each do |record|
        if record.user_id.to_i == player.player_info.user_id.to_i
          Rails.logger.info("[match_game_over_self_rank], record.user_id=>#{record.user_id}")
          Rails.logger.info("[match_game_over_self_rank], rank=>#{i}")
          break
        end
        i = i + 1
      end
      #end
    end
    Rails.logger.info("[match_game_over_self_rank], rank_i=>#{i}")

    i
  end

  def self.judge_push_prop(user_id, action)
    flag = false #do not show prop
    Rails.logger.debug("[judge_push_prop], user_id:#{user_id}")
    user = User.find_by_user_id(user_id)
    user_profile = user.user_profile
    payment = user_profile.payment
    Rails.logger.debug("[judge_push_prop], payment:#{payment}")
    if payment.nil?
      flag = true
      return flag
    end
    system_payment = {}
    record = SystemSetting.find_by_setting_name(payment)
    unless record.nil?
      return true if record.setting_value.nil?
      system_payment = JSON.parse(record.setting_value)
      unless system_payment["#{payment}"].nil?
        return true if system_payment["#{payment}"]["#{action}"].nil?
        flag = system_payment["#{payment}"]["#{action}"].to_i ==1 ? true : false
        return flag
      else
        flag = true
        return flag
      end
    else
      true
    end
  end

  def self.one_hour_push_prop(user_id, prop_name)

    flag = false
    if user_id.to_i < 50000
      flag = true
      return flag
    end
    Rails.logger.debug("[one_hour_push_prop],user_id=>#{user_id} prop_name:#{prop_name}")

    prop = GameProduct.find_by_product_name(prop_name)

    Rails.logger.debug("[one_hour_push_prop], prop:#{prop.id}")

    user_record = UserProduct.where("user_id=? and product_name=?", "#{user_id}", "#{prop_name}").order("id asc")
    Rails.logger.debug("[one_hour_push_prop], user_record:#{user_record.size}")


    unless user_record.blank?
      user_buy_time = user_record.last.created_at
      Rails.logger.debug("[one_hour_push_prop], user_buy_time:#{user_buy_time}")
      flag = true if 1.hour.ago(Time.now)<= user_buy_time
    end
    flag
  end
end