module GameTableState
  PREPARE_READY      = 0
  READY              = 1
  GRAB_LORD          = 2
  PLAY_CARD          = 3
  GAME_OVER          = 4
end
module GameTimingNotifyType
  READY              = 0
  GRAB_LORD          = 1
  PLAY_CARD          = 2
  GAME_OVER          = 3
  KICK_USER          = 4
  LOGIN_TYPE         = 5
  ENTER_ROOM_TYPE    = 6
  END_MATCH          = 7
end
class GameTable
  attr_accessor :dispatcher, :table_info
  def self.get_game_table(table_id, room_id)
    table = GameTable.new(table_id, room_id.to_s)
    if table.table_info.channel_name.nil?
      table.table_info.channel_name = "#{room_id}_#{table_id}"
      table.table_info.save
    end

    table
  end

  def initialize(table_id, room_id)
    t_redis_key = "#{room_id}_#{table_id}"
    @table_info = GameTableInfo.from_redis(t_redis_key)
    if @table_info.nil?
      @table_info =  GameTableInfo.new
      @table_info.room_table_id = t_redis_key
      @table_info.table_id = table_id
      @table_info.bombs = 0
      @table_info.lord_card = nil
      @table_info.all_bombs = 0
      @table_info.lord_value = 0
      @table_info.lord_user_id = nil
      @table_info.lord_turn = []
      @table_info.spring = 0
      @table_info.anti_spring = 0
      @table_info.prev_user_id = 0
      @table_info.lord_card_count = 0
      @table_info.all_out_card = []
      @table_info.next_user_id = nil
      @table_info.last_user_id = nil
      @table_info.room_id = room_id
      @table_info.game_id = "#{@table_info.room_table_id}_#{Time.now.to_i.to_s}"
      @table_info.channel_name = nil
      @table_info.game_result = nil
      @table_info.state = GameTableState::PREPARE_READY
      @table_info.save
      set_current_action_seq
      set_game_sequence
    end
  end

  def init_game_info
    @table_info.bombs = 0
    @table_info.lord_card = nil
    @table_info.all_bombs = 0
    @table_info.lord_value = 0
    @table_info.lord_user_id = nil
    @table_info.lord_turn = []
    @table_info.spring = 0
    @table_info.anti_spring = 0
    @table_info.prev_user_id = 0
    @table_info.lord_card_count = 0
    @table_info.all_out_card = []
    @table_info.next_user_id = nil
    @table_info.last_user_id = nil
    @table_info.save
  end

  def before_player_join_game
    # if users_count == 0
    #   @table_info.game_id = "#{@table_info.room_table_id}_#{Time.now.to_i.to_s}"
    #   @table_info.save
    # end
    Rails.logger.debug("[table.before_player_join_game], game_id=>#{@table_info.game_id}")
  end

  def on_player_join_game(user_id)
    if users_count > 2 or users_count ==0
      set_current_action_finished
      set_current_action_seq
    end
    join_user(user_id)
    @table_info.state = GameTableState::PREPARE_READY
    @table_info.last_action_time = Time.now.to_i
    players = get_players
    players.each do |player|
      if player.player_info.state.to_i == PlayerState::LEAVE_GAME
        leave_user player.player_info.user_id
      end
    end

    @table_info.save

    init_game_info
  end

  def on_player_ready

    @table_info.last_action_time = Time.now.to_i
    @table_info.save
  end

  def is_all_players_ready?
    all_ready = true
    @table_info.reload_from_redis
    if users_count > 2
      players = get_all_players_info
      players.each do |p|
        all_ready = false unless p.state.to_i == PlayerState::READY
        break unless all_ready
      end
    else
      all_ready = false
    end
    all_ready
  end

  def get_all_players_info
    players = []
    users.each do |u_id|
      players.push(PlayerInfo.from_redis(u_id))
    end
    players
  end

  def get_players
    players = []
    unless users.nil?
      users.each do |u_id|
        players.push(Player.get_player(u_id) )
      end
    end
    players
  end

  def on_game_start(lord_cards)
    next_user_id = users[Time.now.to_i % 3]
    @table_info.next_user_id = next_user_id
    @table_info.state = GameTableState::GRAB_LORD
    @table_info.lord_card = lord_cards
    @table_info.save
    next_player = Player.get_player(@table_info.next_user_id)
    next_player.set_current_action_seq
  end

  def on_liuju
    @table_info.next_user_id = nil
    @table_info.lord_card = nil
    @table_info.state = GameTableState::PREPARE_READY
    @table_info.save
  end

  def on_play_card(user_id)
    @table_info.state = GameTableState::PLAY_CARD
    @table_info.last_action_time = Time.now.to_i
    @table_info.save
  end

  def next_play_poke_user(user_id,poke_cards)
    @table_info.all_out_card =[] if @table_info.all_out_card.nil?
    @table_info.all_out_card.push(poke_cards)

    @table_info.prev_user_id = user_id if poke_cards.length > 0
    @table_info.last_user_id = user_id if poke_cards.length > 0
    player = Player.get_player(user_id)
   # p player.player_info.player_role.to_i
    @table_info.lord_card_count =@table_info.lord_card_count.to_i+1 if poke_cards.length > 0 && player.player_info.player_role.to_i ==2
    Rails.logger.debug("next_play_poke_user_lord_card_count#{@table_info.lord_card_count}")
    @table_info.bombs = @table_info.bombs.to_i + 1 if poke_cards.length == 2 && poke_cards.include?("w01")
    if poke_cards.length == 4 &&  !poke_cards.include?("w01")  && !poke_cards.include?("w02")
      poke_cards = poke_cards.collect{|p| p[1,2]}
      @table_info.bombs = @table_info.bombs.to_i + 1 if poke_cards.uniq.length == 1
    end
    next_user_id = users[(users.rindex(user_id)+1)%3]
    @table_info.next_user_id = next_user_id
    @table_info.save
    next_player = Player.get_player(next_user_id)
    next_player.set_current_action_seq  unless next_player.nil?
    if player.player_info.poke_cards.length >0
      next_user_id
    else
      0
    end
  end

  def spring_count
    i = 0
    @table_info.anti_spring = 1 if @table_info.lord_card_count.to_i == 1
    users.each do|user_id|
      player = Player.get_player(user_id)
      i = i +1 if player.player_info.poke_card_count.to_i == 17 && player.player_info.player_role.to_i!=2
    end
    @table_info.spring = 1 if i == 2
    @table_info.save
  end

  def on_game_over
    @table_info.all_bombs = 0
    @table_info.lord_card_count = 0
    @table_info.bombs = 0
    @table_info.spring = 0
    @table_info.anti_spring = 0
    @table_info.state = GameTableState::GAME_OVER
    @table_info.game_id = "#{@table_info.room_table_id}_#{Time.now.to_i.to_s}"
    @table_info.save
    set_game_sequence

  end

  def game_before_bombs_count
    @table_info.all_bombs = @table_info.all_bombs.to_i + 1
    Rails.logger.debug("game_before_bombs_count=>#{@table_info.all_bombs.to_i}")
    @table_info.save
  end

  def on_player_leave(user_id)
    leave_user(user_id)
    if users_count > 0
      set_current_action_finished
      set_current_action_seq
    end
    @table_info.save
    init_game_info
  end

  def on_grab_lord(user_id)
    players_info = get_all_players_info

    lord_value = -1
    lord_user_id = nil
    is_end = true
    players_info.each do |p_info|
      if p_info.lord_value.to_i > lord_value
        lord_value = p_info.lord_value.to_i
        lord_user_id = p_info.user_id
      end
      is_end = false if p_info.lord_value.to_i == -1
    end

    if is_end or lord_value == 3
      @table_info.lord_value = lord_value
      @table_info.lord_user_id = lord_user_id
      @table_info.next_user_id = lord_user_id
      @table_info.last_user_id = lord_user_id
      @table_info.state = GameTableState::PLAY_CARD
    else
      @table_info.lord_value = lord_value
      @table_info.lord_user_id = nil
      @table_info.next_user_id = users[(users.rindex(user_id)+1)%3]
    end
    @table_info.last_action_time = Time.now.to_i
    @table_info.save
    next_player = Player.get_player(@table_info.next_user_id) unless @table_info.next_user_id.nil?
    next_player.set_current_action_seq  unless next_player.nil?
  end

  def get_alive_player_id
    players = get_players
    players.each do |player|
      unless player.is_connection_broken?
         return player.player_info.user_id
      end
    end
    nil
  end

  def on_player_disconnected(timeout_user_id)
    players = get_players
    alive_player = nil
    players.each do |player|
      unless player.player_info.user_id == timeout_user_id or player.is_connection_broken?
        alive_player = player
      end
    end
    if alive_player == nil
      return
    end
    players.each do |player|
      if player.player_info.user_id != alive_player.player_info.user_id and
          (player.player_info.dependence_user == timeout_user_id or player.player_info.user_id == timeout_user_id)
          player.set_dependence_player(alive_player.player_info.user_id)
      end
    end
  end

  def on_restore_connection(user_id)

  end

  def player_in_game?(user_id)
    unless users.include?(user_id.to_s)
      Rails.logger.debug("[player_in_game?] player is not in table.")
       false
    end
    true
  end

  def game_dead?
    if users_count < 1  or table_info.last_action_time.nil?
      Rails.logger.debug("[game_dead?] user.size=>#{users_count.to_s}")
      Rails.logger.debug("[game_dead?] table_info.last_action_time=>#{table_info.last_action_time.to_s}")
      return true
    end
    if (Time.now.to_i - table_info.last_action_time.to_i) > 120
      Rails.logger.debug("[game_dead?] table_info.last_action_time=>#{table_info.last_action_time.to_s} > 120")
      return true
    end
    false
  end

  def left_all_robots?

    result = true
    players = get_players
    players.each do |player|
      result = false unless player.is_robot?
    end
    result
  end

  def is_empty?
    users_count < 1
  end

  def set_current_action_seq
    @table_info.current_action_seq = "#{@table_info.table_id.to_s}_#{rand(9999999).to_s}_#{Time.now.to_i.to_s}"
    @table_info.save
    Rails.logger.debug("[set_current_action_seq] table_info.action_seq=>"+@table_info.current_action_seq)
  end

  def set_game_sequence
    @table_info.game_sequence = "#{@table_info.table_id.to_s}_#{rand(9999999).to_s}_#{Time.now.to_i.to_s}"
    @table_info.save
    Rails.logger.debug("[set_game_sequence] table_info.game_sequence=>"+@table_info.game_sequence)
  end

  def set_current_action_finished(action_seq=nil)
    action_seq =  @table_info.current_action_seq if action_seq.nil?
    Redis.current.set(action_seq, 1)
    Redis.current.expire(action_seq, 120)
    Rails.logger.debug("[set_current_action_finished] table_info.action_seq=>"+@table_info.current_action_seq.to_s)
  end

  def current_action_finished?
    Redis.current.exists(@table_info.current_action_seq)
  end

  def action_finished?(action_seq)
    Redis.current.exists(action_seq)
  end

  def self.increase_table_users_count(table_users_key)
    key = "#{table_users_key}_#{ResultCode::TABLE_USERS_COUNT_KEY_SUFFIX}"
    result = incr_game_key(key)
    Rails.logger.debug("[increase_table_users_count] result 1 =>"+result.to_s)
    while result.nil?
      tmp_v = Redis.current.get(key)
      return nil if tmp_v.to_i >= 3

      result = incr_game_key(key)
      Rails.logger.debug("[increase_table_users_count] result 2 =>"+result.to_s)
      return result if !result.nil? and result <= 3

      if !result.nil? and result > 3
        decrease_table_users_count(table_users_key)
        return nil
      end
    end
    Rails.logger.debug("[increase_table_users_count] result 3 =>"+result.to_s)
    result
  end

  def self.incr_game_key(key)
    Redis.current.watch(key)
    Redis.current.multi
    Redis.current.incr(key)
    Redis.current.exec
  end

  def self.decrease_table_users_count(table_users_key)
    key = "#{table_users_key}_#{ResultCode::TABLE_USERS_COUNT_KEY_SUFFIX}"
    result = decr_game_key(key)
    while result.nil?
      tmp_v = Redis.current.get(key)
      return 0 if tmp_v.to_i == 0

      result = decr_game_key(key)

      return result if !result.nil? and result >= 0

      if !result.nil? and result < 0
        increase_table_users_count(table_users_key)
        return nil
      end
    end
  end
  def self.decr_game_key(key)
    Redis.current.watch(key)
    Redis.current.multi
    Redis.current.incr(key)
    Redis.current.exec
  end

  def self.get_table_users_count(table_users_key)
    key = "#{table_users_key.to_s}_#{ResultCode::TABLE_USERS_COUNT_KEY_SUFFIX}"
    count = Redis.current.get(key)
    count = 0 if count.nil?
    count.to_i
  end

  def users_count
    #get_table_users_count("#{@table_info.room_id}_#{@table_info.table_id}")
    users.length
  end

  def users
    key = "#{@table_info.room_id.to_s}_#{@table_info.table_id.to_s}_#{ResultCode::TABLE_USERS_KEY_SUFFIX}"
    result = Redis.current.get(key)
    Rails.logger.debug("[table.users], result=>#{result}")
    if result.nil?
      Redis.current.set(key, [].to_json)
      return []
    end
      JSON.parse(result)
  end

  def join_user(user_id)
    key = "#{@table_info.room_id.to_s}_#{@table_info.table_id.to_s}_#{ResultCode::TABLE_USERS_KEY_SUFFIX}"
    while true
      begin
        return_nil = false
        Redis.current.watch(key)
        result = Redis.current.get(key)
        Redis.current.multi
        Rails.logger.debug("[join_user] result=>#{result}")
        unless result.nil?
          arr_result = JSON.parse(result)
          return_nil = true if arr_result.length > 2
          Redis.current.set(key, arr_result.push(user_id.to_s).to_json) unless return_nil or arr_result.include?(user_id.to_s)
          Rails.logger.debug("[join_user] Redis.current.set")
        end
        result = Redis.current.exec
        Rails.logger.debug("[join_user] Redis.current.exec")
        return nil if return_nil
        return "ok" unless result.nil?
      rescue Exception=>e
        Rails.logger.debug("[join_user] e=>#{e}, msg=>#{e.message}")
      end
    end

  end

  def leave_user(user_id)
    key = "#{@table_info.room_id.to_s}_#{@table_info.table_id.to_s}_#{ResultCode::TABLE_USERS_KEY_SUFFIX}"
    while true
      begin
        Redis.current.watch(key)
        result = Redis.current.get(key)
        Redis.current.multi
        Rails.logger.debug("[leave_user] Redis.current.exec")
        unless result.nil?
          arr_result = JSON.parse(result)
          if arr_result.include?(user_id.to_s)
            arr_result.delete(user_id.to_s)
            Redis.current.set(key, arr_result.to_json)
          end
          Rails.logger.debug("[leave_user] Redis.current.set")
        end
        result = Redis.current.exec
        Rails.logger.debug("[leave_user] Redis.current.exec")
        return unless result.nil?
      rescue Exception=>e
        Rails.logger.debug("[leave_user] e=>#{e}, msg=>#{e.message}")
      end
    end
  end

  def set_game_start_event_end
    key = "#{@table_info.game_sequence.to_s}_#{ResultCode::GAME_START_EVENT_KEY_SUFFIX}"
    while true
      begin
        Redis.current.watch(key)
        Redis.current.multi
        Rails.logger.debug("[set_game_start_event_end] Redis.current.incr")
        Redis.current.incr(key)
        result = Redis.current.exec
        Rails.logger.debug("[set_game_start_event_end] Redis.current.exec")
        return result unless result.nil?
      rescue Exception=>e
        Rails.logger.debug("[set_game_start_event_end] e=>#{e}, msg=>#{e.message}")
      end
    end
  end

  def set_game_start_key_expired
    key = "#{@table_info.game_sequence.to_s}_#{ResultCode::GAME_START_EVENT_KEY_SUFFIX}"
    Redis.current.expire(key, 60*3)
  end

  def escape_money(room_base)
    bombs = 1
    bombs = (2**@table_info.all_bombs.to_i) if @table_info.all_bombs.to_i > 0
    load_value = 3
    total = room_base.to_i * load_value * 2 * 2
    total * bombs

  end

end