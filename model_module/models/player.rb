#encoding: utf-8

require 'debug_log_utility'

module PlayerState
  PREPARE_READY = 0
  READY = 1
  GRAB_LORD = 2
  PLAY_CARD = 3
  TUO_GUAN = 4
  GAME_OVER = 5
  LEAVE_GAME = 6
end
class Player

  attr_accessor :dispatcher, :player_info

  def self.get_player(user_id)
    player_info = PlayerInfo.from_redis(user_id)
    if player_info.nil?
      user = User.find_by_user_id(user_id)
      if user.nil?
        return nil
      end
      player_info = PlayerInfo.new
      player_info.id = user.id
      player_info.user_id = user.user_id.to_s
      player_info.avatar = user.user_profile.avatar
      player_info.nick_name = user.user_profile.nick_name
      player_info.gender = user.user_profile.gender
      player_info.is_robot = user.robot
      player_info.vip_level = 1 || user.vip_level

      player_info.state = PlayerState::LEAVE_GAME
      player_info.table_id = nil
      player_info.room_id = nil
      player_info.game_id = 0
      player_info.is_tuoguan = 0
      player_info.last_action_time = 0
      player_info.lord_value = -1
      player_info.grab_lord = 0
      player_info.player_role = -1
      player_info.poke_cards = []
      player_info.poke_card_count = 0
      player_info.play_card_timeout_times = 0
      player_info.dependence_user = 0
      player_info.timing_time = 0
      player_info.current_action_seq = 0
      player_info.is_lost = 0
      player_info.save
    end
    player = nil
    player = RobotPlayer.new(user_id, player_info) if player_info.is_robot.to_i == 1
    player = DevicePlayer.new(user_id, player_info) if player.nil?
    player
  end

  def self.initialize_robot(dependence_user, table_id, room_id)
    player = nil
    while true
      gender = rand(1..100) > 50 ? 1 : 2
      user = User.includes(:user_profile).where(:users => {:robot => 1, :busy => 0},
                                                :user_profiles => {:gender => gender}).order("users.last_action_time").first

      if user.nil?
        Rails.logger.debug("[create_robot] all robots are busing.")
        break
      end

      unless user.nil?
        Rails.logger.debug("[create_robot] user=>"+user.to_json)
        room = GameRoomUtility.get_room(room_id)
        rnd_beans = rand(room.min_qualification.to_i..room.max_qualification.to_i)
        rnd_beans = rnd_beans - rnd_beans%10
        user.game_score_info.score = rnd_beans
        user.game_score_info.save

        player = get_player(user.user_id.to_s)

        skip_robot = false

        #if player.player_info.current_action_seq.to_i > 0
        #  action_seq = player.player_info.current_action_seq.split("_")[2]
        #  break_period = Time.now.to_i - action_seq.to_i
        #  if break_period < 60*60*1
        #    skip_robot = true
        #    Rails.logger.debug("[create_robot] skip robot user=>"+user.to_json)
        #  end
        #end

        unless skip_robot
          user.busy = 1
          user.save
          player.player_info.dependence_user = dependence_user
          player.player_info.table_id = table_id
          player.player_info.save
          break
        end

      end
    end

    player
  end

  def initialize(user_id, player_info)
    @player_info = player_info
  end

  def on_join_game(table_id, room_id, room_type, game_id)
    set_current_action_finished
    timer = GameController.current_timer(@player_info.user_id)
    unless timer.nil?
      timer.cancel
      Rails.logger.debug("[on_ready] cancel ready timer, user_id=>"+@player_info.user_id.to_s)
    end
    user = User.find_by_user_id(@player_info.user_id)
    unless user.nil?
      @player_info.avatar = user.user_profile.avatar
      @player_info.nick_name = user.user_profile.nick_name
      @player_info.gender = user.user_profile.gender
    end
    @player_info.game_server_id = Process.pid.to_s
    @player_info.game_id = game_id
    @player_info.table_id = table_id
    @player_info.room_id = room_id
    @player_info.location = room_type
    @player_info.grab_lord = 0
    @player_info.player_role = -1
    @player_info.lord_value = -1
    @player_info.poke_card_count = 0
    @player_info.is_tuoguan = 0
    @player_info.is_lost = 0
    @player_info.poke_cards = []
    @player_info.state = PlayerState::PREPARE_READY
    @player_info.save
    set_current_action_seq
  end

  def ready_timing(action_seq, timeout=nil, &block)
    timeout = ResultCode::PLAYER_READY_TIMEOUT if timeout.nil?
    Rails.logger.debug("[ready_timing] timeout=>#{timeout.to_s}")
    ready_timer = EventMachine::Timer.new(timeout) do
      if action_finished?(action_seq)
        Rails.logger.debug("[ready_timing] action_finished, action_seq=>#{action_seq.to_s}")
      else
        block.call @player_info.user_id
      end
    end
    @player_info.timing_time = Time.now.to_i
    @player_info.save
    store_current_timer(ready_timer)
  end

  def on_ready
    #timer = @game_controller.current_timer
    set_current_action_finished
    timer = GameController.current_timer(@player_info.user_id)
    unless timer.nil?
      timer.cancel
      Rails.logger.debug("[on_ready] cancel ready timer, user_id=>"+@player_info.user_id.to_s)
    end
    @player_info.grab_lord = 0
    @player_info.player_role = -1
    @player_info.lord_value = -1
    @player_info.poke_card_count = 0
    @player_info.is_tuoguan = 0
    @player_info.is_lost = 0
    @player_info.poke_cards = []
    @player_info.state = PlayerState::READY
    @player_info.save
  end


  def is_robot?
    false
  end

  def on_game_start(poke_card, next_user_id)
    @player_info.poke_cards = poke_card
    @player_info.poke_card_count = 17
    @player_info.grab_lord = 1 if @player_info.user_id == next_user_id
    @player_info.state = PlayerState::GRAB_LORD
    @player_info.save
  end

  def client_player_info
    state = 0
    state = 1 if player_info.state.to_i >0
    poke_cards = ""
    if player_info.poke_cards.size > 0
      poke_cards = player_info.poke_cards.join(",")
    end
    {:user_id => player_info.user_id.to_i, :avatar => player_info.avatar, :nick_name => player_info.nick_name,
     :gender => player_info.gender, :is_robot => player_info.is_robot, :state => state,
     :tuo_guan => player_info.is_tuoguan.to_i,
     :lord_value => player_info.lord_value.to_i,
     :grab_lord => player_info.grab_lord.to_i,
     :player_role => player_info.player_role.to_i,
     :poke_card_count => player_info.poke_card_count.to_i,
     :poke_cards => poke_cards}
  end

  def on_liuju
    @player_info.state = PlayerState::PREPARE_READY
    @player_info.lord_value = -1
    @player_info.grab_lord = 0
    @player_info.poke_cards = nil
    @player_info.poke_card_count = 0
    @player_info.is_tuoguan = 0
    @player_info.save
    set_current_action_seq
  end


  def set_farmer
    @player_info.player_role = 0
    @player_info.save
  end


  def on_grab_lord(lord_value)
    set_current_action_finished
    cancel_timer
    @player_info.lord_value= lord_value
    @player_info.save
  end

  def cancel_timer
    timer = nil
    if @player_info.dependence_user.nil? or @player_info.dependence_user.to_i ==0
      timer = GameController.current_timer(@player_info.user_id)
    else
      timer = GameController.current_timer(@player_info.dependence_user)
    end
    unless timer.nil?
      timer.cancel
      Rails.logger.debug("[cancel_timer] cancel timer, user_id=>"+@player_info.user_id.to_s)
    end
  end

  def cancel_voice_timer
    timer = nil
    if @player_info.dependence_user.nil? or @player_info.dependence_user.to_i ==0
      timer = GameController.current_voice_timer(@player_info.user_id)
    else
      timer = GameController.current_voice_timer(@player_info.dependence_user)
    end
    unless timer.nil?
      timer.cancel
      Rails.logger.debug("[cancel_voice_timer] cancel timer, user_id=>"+@player_info.user_id.to_s)
    end
  end

  def on_play_cards(poke_cards, is_timeout)
    set_current_action_finished
    cancel_timer
    cancel_voice_timer
    @player_info.poke_cards = @player_info.poke_cards - poke_cards
    if is_timeout and @player_info.is_tuoguan.to_i == 0
      @player_info.play_card_timeout_times = @player_info.play_card_timeout_times.to_i + 1
    else
      @player_info.play_card_timeout_times = 0
    end
    if @player_info.play_card_timeout_times.to_i > 1
      @player_info.play_card_timeout_times = 0
      @player_info.is_tuoguan = 1
      Rails.logger.debug("[on_play_cards] set player tuo_guan=1")
    end
    @player_info.poke_card_count = @player_info.poke_cards.length
    @player_info.save
  end

  def on_game_over(is_win, score, game_id)
    user = User.find_by_user_id(@player_info.user_id)
    Rails.logger.debug("[on_game_over, begin to save score]")
    #used_props =  GameProductItem.includes(:user_profile).where(:users=>{:robot=>1, :busy=>0},
    #                                                       :user_profiles=>{:gender=>gender}).
    #    order("users.last_action_time").first
    Rails.logger.debug("[on_game_over], @player_info=>#{@player_info.to_json}")
    str_sql = "select a.* from game_product_items a, user_used_props b
      where a.id = b.game_product_item_id and a.using_point=3 and b.state=1 and b.user_id = #{@player_info.id}"
    Rails.logger.debug("[on_game_over], str_sql=>#{str_sql}")
    used_props = GameProductItem.find_by_sql(str_sql)
    real_score = score
    used_props.each do |prop|
      if prop.respond_to?(:take_effect)
        real_score = prop.take_effect(@player_info.id, {:is_win => is_win, :beans => real_score})
      end
    end

    #activity_real_score = 0

    #day = Time.now.wday
    #activity = Activity.find_by_week_date(day)
    #if activity.respond_to?(:take_effect)
    #   activity_real_score = activity.take_effect(@player_info.player_role,{:is_win=>is_win, :beans=>score})
    #end

    #user.game_score_info.score = user.game_score_info.score.to_i + real_score + activity_real_score

    day = Time.now.wday
    unless day == 4 or day == 6 or day == 0
      activity = Activity.find_by_week_date(day)
      if !activity.nil? and activity.respond_to?(:take_effect)
        real_score = activity.take_effect(@player_info.id, {:role => @player_info.player_role, :score => score.abs,
                                                            :is_win => is_win, :beans => real_score})
      end
    end
    user.game_score_info.score = user.game_score_info.score.to_i + real_score

    if user.game_score_info.score < ResultCode::PUSH_PROP_ON_GAMING_FOR_BEANS #作成可配置
      table = GameTable.get_game_table(@player_info.table_id, @player_info.room_id)
      prop = GameProduct.find_by_product_name(ResultCode::HUANGJINBAOXIANG)
      consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code
      notify_data = {must_show: "true", note: prop.note, icon: prop.icon, consume_code: consume_code, name: prop.product_name, prop_note: prop.note, id: prop.id, price: prop.price, rmb: prop.price.to_f/100, notify_type: ResultCode::PUSH_GAME_PROP, title: ResultCode::BEANS_IS_NOT_ENOUGH} unless prop.nil?

      Rails.logger.info("[push prop on gaming for beans]=>#{notify_data}")
      GameController.trigger_prop_notify("ui.routine_notify", notify_data, @player_info.user_id, table.table_info)
    end

    if user.game_score_info.score < 0
      user.game_score_info.score = 0
    end
    user.game_score_info.win_count = user.game_score_info.win_count.to_i + 1 if is_win
    user.game_score_info.lost_count = user.game_score_info.lost_count.to_i + 1 unless is_win
    user.game_score_info.score = 0 if user.game_score_info.score < 0
    user.game_score_info.save
    Rails.logger.debug("[on_game_over, end to save score]")

    @player_info.state = GameTableState::PREPARE_READY
    @player_info.player_role = 0
    @player_info.lord_value = -1
    @player_info.is_tuoguan = 0
    @player_info.is_lost = is_win ? 0 : 1
    @player_info.game_id = game_id
    @player_info.save
    clean_current_action_seq_num
    set_current_action_seq
    #### 活动比赛统计计分
    unless @player_info.room_id.nil?
      room = GameRoomUtility.get_room(@player_info.room_id)
      if room.room_type.to_i ==2 or room.room_type.to_i==3
        joined_match = []
        match_seqs = MatchMember.where(:user_id => @player_info.user_id, :status => 0)
        unless match_seqs.nil?
          match_seqs.each do |seqs|
            joined_match.push(seqs.match_seq.to_s)
          end
        end

        if (!room.match_seq.nil? && joined_match.include?(room.match_seq)) or @player_info.is_robot.to_i == 1
          #record = MatchMember.find_by_user_id_and_match_seq(@player_info.user_id, room.match_seq)
          Rails.logger.debug("[on_game_over, end to save score]user_id=>#{@player_info.user_id}match_seq=>#{room.match_seq}")

          record = MatchMember.where("user_id" => @player_info.user_id, "match_seq" => room.match_seq).first
          if record.nil? && @player_info.is_robot.to_i == 1
            record = MatchMember.new
            record.user_id = @player_info.user_id
            record.room_id = @player_info.room_id
            record.match_seq = room.match_seq
            record.room_type = room.room_type
            record.scores = real_score
          else
            record.scores = record.scores.to_i + real_score
          end
          record.last_win_time = Time.now if is_win
          record.save
        end
      end
      #先判断room类型是2或者3不 是的话就是比赛房间类型 取出match_seq
    end
    real_score
  end

  def set_player_role(role_type)
    @player_info.player_role = role_type
    @player_info.save
  end

  def on_leave_game
    set_current_action_finished
    cancel_timer
    @player_info.state = PlayerState::LEAVE_GAME
    @player_info.is_tuoguan = 0
    @player_info.dependence_user = 0
    @player_info.table_id = nil
    @player_info.room_id = nil
    @player_info.save
  end

  def on_escape
    user = User.find_by_user_id(@player_info.user_id)
    user.game_score_info.flee_count = user.game_score_info.flee_count.to_i + 1
    user.game_score_info.save
  end

  def on_grab_lord_end(lord_user_id, lord_card)
    if @player_info.user_id == lord_user_id.to_s
      @player_info.player_role = 2
      @player_info.poke_card_count = 20
      @player_info.poke_cards.concat(lord_card)
    else
      @player_info.player_role = 1
    end
    @player_info.state = PlayerState::GRAB_LORD
    @player_info.save
  end

  def grab_lord_timing(action_seq, timeout=nil, &block)
    timeout = ResultCode::GRAB_LORD_TIMEOUT if timeout.nil?
    Rails.logger.debug("[grab_lord_timing] timeout=>#{timeout.to_s}")
    grab_lord_timer = EventMachine::Timer.new(timeout) do
      if action_finished?(action_seq)
        Rails.logger.debug("[grab_lord_timing] action_finished, action_seq=>#{action_seq.to_s}")
      else
        block.call @player_info.user_id, grab_lord
      end
    end
    @player_info.timing_time = Time.now.to_i
    @player_info.save
    store_current_timer(grab_lord_timer)
  end

  def store_current_timer(timer)
    if @player_info.dependence_user.nil? or @player_info.dependence_user.to_i ==0
      GameController.set_current_timer(@player_info.user_id, timer)
    else
      GameController.set_current_timer(@player_info.dependence_user, timer)
    end
  end

  def store_current_voice_timer(timer)
    if @player_info.dependence_user.nil? or @player_info.dependence_user.to_i ==0
      GameController.set_player_voice_timer(@player_info.user_id, timer)
    else
      GameController.set_player_voice_timer(@player_info.dependence_user, timer)
    end
  end

  def play_card_timing(game_id, action_seq, last_user_id, last_poke_card=[], timeout=nil, &block)
    interval = timeout unless timeout.nil?
    interval = ResultCode::PLAY_CARD_TIMEOUT if timeout.nil?
    unless MatchSystemSetting.first.nil?
      unless MatchSystemSetting.first.play_card_timing.nil?
        interval = MatchSystemSetting.first.play_card_timing
      end
    end
    interval = rand(2..4) if @player_info.is_tuoguan.to_i == 1 and timeout.nil?
    Rails.logger.debug("[play_card_timing] is_tuoguan=>#{@player_info.is_tuoguan.to_s}, timeout=>#{interval.to_s}")
    play_card_timer = EventMachine::Timer.new(interval) do
      @player_info.reload_from_redis
      Rails.logger.debug("[play_card_timing]_player_game_id=>#{@player_info.game_id}")
      Rails.logger.debug("[play_card_timing]_game_id=>#{game_id}")
      if @player_info.game_id == game_id


        if action_finished?(action_seq)
          Rails.logger.debug("[play_card_timing] action_finished, action_seq=>#{action_seq.to_s}")
        else
          block.call @player_info.user_id, play_card(last_user_id, last_poke_card)
        end
      end
    end
    @player_info.timing_time = Time.now.to_i
    @player_info.save
    store_current_timer(play_card_timer)
  end

  def grab_lord
    0
  end

  #def play_card(last_user_id)
  #  table = GameTable.get_game_table(@player_info.table_id, @player_info.room_id)
  #  players = table.get_players
  #  other_user= nil
  #  players.each do|p|
  #    if p.player_info.user_id.to_i!=last_user_id.to_i and p.player_info.user_id.to_i!=@player_info.user_id.to_i
  #      other_user = p
  #    end
  #  end
  #
  #  poke_card = ""
  #  if last_user_id.to_s == @player_info.user_id.to_s
  #    poke_card = @player_info.poke_cards.pop
  #  end
  #  poke_card = "" if poke_card.nil?
  #
  #  poke_card
  #end

  def play_card(last_user_id, last_poke_card)
    poke_card = ""

    last_user_id = @player_info.user_id if last_user_id.nil?
    last_player = Player.get_player(last_user_id)
    skip_play = false
    if last_user_id.to_s == @player_info.user_id.to_s
      last_poke_card = []
    elsif !last_player.nil? and last_player.player_info.player_role.to_i == @player_info.player_role.to_i
      #上家打的牌，且牌为3张以上，牌值大于等于10， 或对友的牌手数少于我的并且其手数小于4手, 则不出

      last_pokes = CardUtility.get_cards_by_str_array(last_poke_card)
      last_card = CardUtility.get_card(last_pokes)
      if last_pokes.length >= 3 or last_card.max_poke_value >= 10 or
        (@player_info.poke_cards.length > last_player.player_info.poke_cards.length and
          last_player.player_info.poke_cards.length < 4)
        skip_play = true
        Rails.logger.debug("[play_card] last player is farmer so skip play card.")
      end

    end
    unless skip_play
      enemy_all_pokes = nil
      partner_all_pokes = nil

      table = GameTable.get_game_table(@player_info.table_id, @player_info.room_id)
      all_users = table.users
      return poke_card if all_users.rindex(@player_info.user_id).nil?
      players = table.get_players
      enemy_player = nil
      #找出牌张数最少的对手
      players.each do |p|
        if (p.player_info.player_role.to_i != @player_info.player_role.to_i and enemy_player.nil?) or
          (p.player_info.player_role.to_i != @player_info.player_role.to_i and
            enemy_player.player_info.poke_cards.length > p.player_info.poke_cards.length)
          enemy_player = p
        end

      end
      enemy_all_pokes = enemy_player.player_info.poke_cards unless enemy_player.nil?
      enemy_pokes_count = enemy_all_pokes.nil? ? 0 : enemy_all_pokes.length
      #last_poke_card 为 nil 或 length 为0， 意为着上手牌是自已出的
      if last_poke_card.nil? or last_poke_card.length == 0

        next_user_id = table.users[(all_users.rindex(@player_info.user_id)+1)%3]
        if next_user_id.nil?
          Rails.logger.debug("[play_card] table.users=>#{table.users.to_json}")
          Rails.logger.debug("[play_card] @player_info.user_id=>#{@player_info.user_id}")
          Rails.logger.debug("[play_card] all_users=>#{all_users.to_json}")
          Rails.logger.debug("[play_card] .next_user_id=>"+next_user_id.to_s)
        else
          next_player = Player.get_player(next_user_id)
          if next_player.player_info.player_role.to_i == @player_info.player_role.to_i
            partner_all_pokes = next_player.player_info.poke_cards
          end
        end
      else
        enemy_all_pokes = nil
      end
      #如果上手牌为自已所出，则enemy_all_pokes 不为空， 要考虑对手牌的情况，last_poke_card = nil
      #如果上手牌为自已所出，且下家为队友，则partner_all_pokes不为空，要考虑下家队友的情况，last_poke_card = nil
      #如果上手牌非自已所出，enemy_all_pokes , partner_all_pokes 都为 nil， 只考虑对手牌张数 enemy_pokes_count, 及上手牌
      #如果上手牌非自己所出，且为队友所出，已排除压队友3张及以上，或牌值大于等于10 的牌
      card = CardUtility.get_larger_card(@player_info.poke_cards, last_poke_card, enemy_all_pokes, partner_all_pokes, enemy_pokes_count)
      poke_card = card.join(",") unless card.nil?
    end
    poke_card
  end

  def release
    Rails.logger.debug("[release] I am not robot. user_id=>"+@player_info.user_id.to_s)
  end

  def can_restore_connection?
    player_connection = PlayerConnectionInfo.from_redis(@player_info.user_id)
    pre_con = player_connection.connections[0]
    Rails.logger.debug("[can_restore_connection?] pre_con=>"+pre_con.to_json)
    last_con = player_connection.connections[1]
    Rails.logger.debug("[can_restore_connection?] last_con=>"+last_con.to_json)
    if last_con.nil?
      if pre_con["break_time"].nil?
        return true
      end
      if (pre_con["begin_time"].to_i - pre_con["break_time"].to_i) > ResultCode::RESTORE_CONNECTION_TIMEOUT
        Rails.logger.debug("[can_restore_connection?] pre_begin - pre_break > timeout")
        return false
      else
        return true
      end
    end
    unless last_con["break_time"].nil?
      Rails.logger.debug("[can_restore_connection?] last_con[break_time].nil")
      return false
    end
    if pre_con["break_time"].nil?
      return true
    end
    if (last_con["begin_time"].to_i - pre_con["break_time"].to_i) > ResultCode::RESTORE_CONNECTION_TIMEOUT
      Rails.logger.debug("[can_restore_connection?] last_begin - last_break > timeout")
      return false
    end
    true
  end

  def is_connection_broken?
    if @player_info.dependence_user.nil? or @player_info.dependence_user.to_i == 0
      return false
    end
    Rails.logger.debug("[is_connection_broken?] player_info=>"+@player_info.to_json)
    player_connection = PlayerConnectionInfo.from_redis(@player_info.user_id.to_s)
    pre_con = player_connection.connections[0]
    last_con = player_connection.connections[1]
    if last_con.nil?
      if pre_con["break_time"].nil?
        return false
      end
      return true
    end
    if last_con["break_time"].nil?
      return false
    end
    true
  end

  def set_dependence_player(user_id)
    @player_info.dependence_user = user_id
    #@player_info.is_tuoguan = 1  unless user_id.to_i == 0
    @player_info.save
    Rails.logger.debug("[set_dependence_player] user_id=>#{@player_info.user_id.to_s}, dependence_user=>#{user_id.to_s}")
  end

  def in_game?
    if @player_info.table_id.nil? or @player_info.table_id.to_i == 0 or @player_info.current_action_seq.nil?
      Rails.logger.debug("[in_game?] table_id=>#{@player_info.table_id}, action_seq=>#{@player_info.current_action_seq}")
      return false
    end
    action_seq = @player_info.current_action_seq.split("_")[2]
    break_period = Time.now.to_i - action_seq.to_i
    if break_period > 120
      Rails.logger.debug("[in_game?] break_period >  120, current_action_seq=>#{@player_info.current_action_seq}")
      Rails.logger.debug("[in_game?] break_period >  120, action_seq=>#{action_seq.to_s}")
      return false
    end
    true
  end

  def set_current_action_finished
    Redis.current.set(@player_info.current_action_seq, 1)
    Redis.current.expire(@player_info.current_action_seq, 120)
    Rails.logger.debug("[set_current_action_finished] action_seq=>"+@player_info.current_action_seq.to_s)
  end

  def set_current_action_seq
    current_action_seq_num = get_current_action_seq_num
    @player_info.current_action_seq = "#{@player_info.user_id.to_s}_#{current_action_seq_num.to_s}_#{Time.now.to_i.to_s}"
    @player_info.save
    Rails.logger.debug("[set_current_action_seq] action_seq=>"+@player_info.current_action_seq.to_s)
  end

  def get_current_action_seq_num
    key = "#{@player_info.user_id}_current_action_seq_num"
    Redis.current.incr(key)
  end

  def clean_current_action_seq_num
    key = "#{@player_info.user_id}_current_action_seq_num"
    Redis.current.set(key, 0)
  end

  def current_action_finished?
    Redis.current.exists(@player_info.current_action_seq)
  end

  def action_finished?(action_seq)
    Redis.current.exists(action_seq)
  end

  def on_turn_on_tuoguan
    @player_info.is_tuoguan = 1
    @player_info.save
    Rails.logger.debug("[on_turn_on_tuoguan] set player=>#{@player_info.user_id.to_s}, tuo_guan=>#{@player_info.is_tuoguan.to_s}")
  end

  def on_cancel_tuoguan
    @player_info.is_tuoguan = 0
    @player_info.play_card_timeout_times = 0
    @player_info.save
    Rails.logger.debug("[on_cancel_tuoguan] set player=>#{@player_info.user_id.to_s}, tuo_guan=>#{@player_info.is_tuoguan.to_s}")
  end

  def set_pause
    @player_info.is_pause = 1
    @player_info.save
  end

  def quit_pause
    @player_info.is_pause =0
    @player_info.save
  end

  def using_props
    return_result = []
    contain_jipaiqi = 0
    str_sql = "select a.* from game_product_items a, user_used_props b
      where a.id = b.game_product_item_id and b.state=1 and b.user_id = #{@player_info.id}"

    used_props = GameProductItem.find_by_sql(str_sql)
    used_props.each do |prop|
      unless prop.expired?(@player_info.id)
        contain_jipaiqi = 1 if prop.item_type.to_i == 3
        return_result.push({:icon_name => prop.feature["icon"], :prop_name => prop.item_name})
      end
    end
    [contain_jipaiqi, return_result]
  end

  def voice_props
    user_vip_level = vip_level_activity
    Rails.logger.debug("[player.get_specify_voice_props], vip_level=>#{user_vip_level}")
    match_item_type = 9900+(user_vip_level - 1)*10
    v_props = GameProductItem.where("item_type<=? and item_type>=9900", match_item_type).order("item_type desc")
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

  end

  def chat_on_game_over(&block)

    using_point = "3-1"
    using_point = "3-0" if @player_info.is_lost.to_i == 1
    v_props = get_specify_voice_props(true, using_point, "desc")

    return if v_props.nil? and v_props.length < 1
    prop = v_props[0]
    prop.take_effect(@player_info.user_id, nil, &block)

  end


  def on_enter_hall(&block)
    Rails.logger.info("Player.on_enter_hall, time=>#{Time.now.to_s}")
    @player_info.location = 90
    @player_info.save
    return if block.nil?

    using_point = "4-2-1"
    v_props = get_specify_voice_props(true, using_point, "asc")
    return if v_props.nil? and v_props.length < 1
    time_span = 0
    v_props.each do |prop|
      EventMachine::add_timer(time_span) do
        prop.take_effect(@player_info.user_id, nil, &block)
      end
      time_span = time_span + 2
    end
  end

  def on_after_shopping(&block)
    using_point = "4-3-2"
    v_props = get_specify_voice_props(true, using_point, "asc")
    return if v_props.nil? and v_props.length < 1
    prop = v_props[0]
    prop.take_effect(@player_info.user_id, nil, &block)
  end

  def on_enter_prop_store(&block)
    using_point = "4-3-1"
    v_props = get_specify_voice_props(true, using_point, "asc")
    return if v_props.nil? and v_props.length < 1
    prop = v_props[0]
    prop.take_effect(@player_info.user_id, nil, &block)
  end

  def on_prepare_sign_out(&block)
    using_point = "4-2-999"
    v_props = get_specify_voice_props(true, using_point, "asc")
    return if v_props.nil? and v_props.length < 1
    prop = v_props[0]
    prop.take_effect(@player_info.user_id, nil, &block)
  end

  def on_changed_avatar(&block)
    using_point = "4-4-1"
    v_props = get_specify_voice_props(true, using_point, "asc")
    return if v_props.nil? and v_props.length < 1
    prop = v_props[0]
    prop.take_effect(@player_info.user_id, nil, &block)
  end

  def get_specify_voice_props(all_under_level, using_point, order_rule)
    vip_level = vip_level_activity
    Rails.logger.debug("[player.get_specify_voice_props], vip_level=>#{vip_level}")
    match_item_type = 9900 + (vip_level - 1) * 10
    op = "="
    op = "<=" if all_under_level
    v_props = GameProductItem.where("item_type#{op}? and item_type>=? and using_point=?",
                                    match_item_type, 9900, using_point).order("item_type #{order_rule}")
  end

  def day_activity_done?
    key = "#{@player_info.user_id}_#{ResultCode::USER_JOIN_DAY_ACTIVITY_KEY}"
    joined_day = Redis.current.get(key)
    return false if joined_day.nil?
    joined_day.to_date == Time.now.to_date

  end

  def set_day_activity_done
    key = "#{@player_info.user_id}_#{ResultCode::USER_JOIN_DAY_ACTIVITY_KEY}"
    Redis.current.set(key, Time.now.to_s)
  end

  def on_login_in
    Rails.logger.debug("[player.on_login_in], day=>#{Time.now.wday}")

    return if day_activity_done?
    day = Time.now.wday
    Rails.logger.debug("[player.on_login_in], day=>#{day}")

    return if day != 4
    a_prop = Activity.find_by_week_date(day)
    return if a_prop.nil?
    a_prop.take_effect(@player_info.id, {:player => self})
  end

  def vip_level_activity
    Rails.logger.debug("[player.vip_level_activity], vip_level=>#{@player_info.vip_level}")
    day = Time.now.wday
    return @player_info.vip_level.to_i if day != 6
    a_prop = Activity.find_by_week_date(day)
    return @player_info.vip_level.to_i if a_prop.nil?
    a_prop.take_effect(@player_info.id)
  end

  def after_grab_lord(next_user_id, &block)
    n_player = Player.get_player(next_user_id)

    n_player.play_card_voice_timing(&block)
  end

  def after_play_card(next_user_id, last_user_id, poke_cards, &block)
    n_player = Player.get_player(next_user_id)
    n_player.play_card_voice_timing(&block)

    l_player = Player.get_player(last_user_id)

    l_player.on_be_hurt(&block) if poke_cards.size > 0

    if @player_info.player_role.to_i == n_player.player_info.player_role.to_i and
      l_player.player_info.player_role.to_i == @player_info.player_role.to_i
      n_player.on_cheer_partner(&block)
    end

  end

  def on_be_hurt(&block)

  end

  def on_cheer_partner(&block)

  end

  def play_card_voice_timing(&block)

  end

  def after_enter_room(&block)

  end

  def before_leave_game(players, &block)

  end

end