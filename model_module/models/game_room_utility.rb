class GameRoomUtility
  def self.get_room(room_id)
    room = GameRoomInfo.from_redis(room_id)
    if room.nil?
      game_room = GameRoom.all.select{|r| r.id == room_id.to_i}.first
      if game_room.nil?
        return nil
      end
      room = GameRoomInfo.new
      room.room_id = game_room.id
      room.name = game_room.name
      room.base = game_room.ante
      room.max_qualification = game_room.max_qualification
      room.min_qualification = game_room.min_qualification
      room.limit_online_count = game_room.limit_online_count
      room.fake_online_count = game_room.fake_online_count
      room.online_count = 0
      room.room_type = game_room.room_type
      room.state = game_room.status
      room.urls = []
      room.match_seq = 0
      room.match_status = 1
      room.is_forced_kick_match = 0
      if game_room.game_room_url.nil? || game_room.game_room_url.length <1
        room.urls.push("ws://#{ResultCode::DEFAULT_ROOM_RUL}/websocket")
      else
        game_room.game_room_url.each do |url|
          room.urls.push("ws://#{url.domain_name}:#{url.port}/websocket")
        end
      end
      room.save
    end
    room

  end

  def self.get_room_by_type(room_type)
      room_id = ""
      rooms = GameRoom.all
      rooms.each do |room|
        if room.room_type == room_type.to_i
          room_id = room.id
          break
        end
      end
      room_id
  end

  def self.get_all_rooms()
    unless Redis.current.exists(ResultCode::ALL_GAME_ROOMS_REDIS_KEY)
      #rooms = GameRoom.all
      rooms = GameRoom.where(:status=>0).order("room_type desc,id asc")
      room_msg =[]
      rooms.each do |room|
        room_msg.push room.id
      end
      Rails.logger.debug("[get_all_rooms] ALL_GAME_ROOMS=> "+room_msg.to_json)
      Redis.current.set ResultCode::ALL_GAME_ROOMS_REDIS_KEY, room_msg.to_json
    end
    room_ids = JSON.parse(Redis.current.get(ResultCode::ALL_GAME_ROOMS_REDIS_KEY))
    all_rooms = []
    room_ids.each do |id|
      all_rooms.push(get_room(id))
    end
    all_rooms
  end

  #def self.get_one_available_table(room_id, table_id=nil)
  #  room = get_room(room_id)
  #
  #  if room.waiting_tables.length < 10
  #    (10-room.waiting_tables.length).times do |i|
  #      table_id = create_table_id(room_id)
  #      room.tables.push table_id.to_s
  #      room.waiting_tables.push table_id.to_s
  #      table = GameTable.get_game_table(table_id)
  #      table.table_info.room_id = room_id
  #      table.table_info.channel_name = "#{room_id}_#{table_id}"
  #      table.table_info.save
  #    end
  #    room.save
  #  end
  #
  #  table = nil
  #  table_id = table_id.to_s unless table_id.nil?
  #  unless room.waiting_tables.blank?
  #    w_tables = []
  #    room.waiting_tables.each do |tb_id|
  #      tmp_table = GameTable.get_game_table(tb_id)
  #      if GameTable.get_table_users_count("#{room_id}_#{tmp_table.table_info.table_id}") < 3
  #        w_tables.push tmp_table if table_id != tmp_table.table_info.table_id.to_s
  #      else
  #        GameRoomUtility.set_table_invalid(room_id, tmp_table.table_info.table_id)
  #      end
  #    end
  #    tmp_tables = w_tables.shuffle
  #    if table_id.nil? or table_id == "0"
  #      tmp_tables = w_tables.sort { |x, y|
  #        y.users_count <=> x.users_count
  #      }
  #    end
  #
  #    tmp_tables.each do |tb|
  #      Rails.logger.debug("[get_one_available_table] tmp_tables =>"+tmp_tables.length.to_s)
  #      u_count = GameTable.increase_table_users_count("#{room_id}_#{tb.table_info.table_id}")
  #      unless u_count.nil?
  #        table = tb
  #        break
  #      end
  #    end
  #
  #  end
  #
  #  table
  #end

  def self.get_one_available_table(user_id, room_id, table_id=nil)
    room = get_room(room_id)
    room.tables
    if room.waiting_tables.length < 5
      (5-room.waiting_tables.length).times do |i|
        table_id = create_table_id(room_id)
        new_room_table(room_id, table_id)
        set_table_available(room_id, table_id)

        table = GameTable.get_game_table(table_id, room_id)
        table.table_info.room_id = room_id
        table.table_info.channel_name = "#{room_id}_#{table_id}"
        table.table_info.save
      end
      room.save
    end

    table = nil
    table_id = table_id.to_s unless table_id.nil?
    unless room.waiting_tables.blank?
      w_tables = []
      room.waiting_tables.each do |tb_id|
        tmp_table = GameTable.get_game_table(tb_id, room_id)
        if tmp_table.users_count < 3
          w_tables.push tmp_table if table_id != tmp_table.table_info.table_id.to_s
        else
          set_table_invalid(room_id, tmp_table.table_info.table_id)
        end
      end
      tmp_tables = w_tables.shuffle
      #if table_id.nil? or table_id == "0"
        tmp_tables = w_tables.sort { |x, y|
          y.users_count <=> x.users_count
        }
      #end

      tmp_tables.each do |tb|
        Rails.logger.debug("[get_one_available_table] tmp_tables =>"+tmp_tables.length.to_s)
        r = tb.join_user(user_id)
        unless r.nil?
          table = tb
          set_table_invalid(room_id, tb.table_info.table_id)  if tb.users_count > 2
          break
        end
      end

    end

    table
  end

  def self.create_table_id(room_id)
    key = "#{room_id.to_s}_#{ResultCode::TABLES_ID_KEY_SUFFIX}"
    Redis.current.incr(key)
  end


  def self.increase_room_online_count(room_id)
    # key = "#{room_id.to_s}_#{ResultCode::ROOM_ONLINE_COUNT_KEY_SUFFIX}"
    # Redis.current.incr(key)
  end

  def self.decrease_room_online_count(room_id)
    # key = "#{room_id.to_s}_#{ResultCode::ROOM_ONLINE_COUNT_KEY_SUFFIX}"
    # Redis.current.decr(key)
  end

  def self.get_room_online_count(room_id)
    # key = "#{room_id.to_s}_#{ResultCode::ROOM_ONLINE_COUNT_KEY_SUFFIX}"
    # count = Redis.current.get(key)
    # count = 0 if count.nil?
    # count.to_i
    room = get_room(room_id)
    r_count = 0
    r_count = room.real_online_count unless room.nil?
    r_count
  end



  def self.waiting_tables(room_id)
    key = "#{room_id.to_s}_#{ResultCode::WAITING_TABLES_KEY_SUFFIX}"
    result = Redis.current.get(key)
    if result.nil?
      Redis.current.set(key, [].to_json)
      return []
    end
    JSON.parse(result)
  end

  def self.set_table_available(room_id, table_id)
    key = "#{room_id.to_s}_#{ResultCode::WAITING_TABLES_KEY_SUFFIX}"
    while true
      begin
        Redis.current.watch(key)
        result = Redis.current.get(key)
        Redis.current.multi
        Rails.logger.debug("[set_table_available] result=>#{result}")
        unless result.nil?
          arr_result = JSON.parse(result)
          Redis.current.set(key, arr_result.push(table_id.to_i).to_json)
          Rails.logger.debug("[set_table_available] Redis.current.set")
        end
        result = Redis.current.exec
        Rails.logger.debug("[set_table_available] Redis.current.exec")
        return unless result.nil?
      rescue Exception=>e
        Rails.logger.debug("[set_table_available] e=>#{e}, msg=>#{e.message}")
      end
    end

  end

  def self.set_table_invalid(room_id, table_id)
    key = "#{room_id.to_s}_#{ResultCode::WAITING_TABLES_KEY_SUFFIX}"
    while true
      begin
        Redis.current.watch(key)
        result = Redis.current.get(key)
        Redis.current.multi
        Rails.logger.debug("[set_table_invalid] result=>#{result}")
        unless result.nil?
          arr_result = JSON.parse(result)
          if arr_result.include?(table_id.to_i)
            arr_result.delete(table_id.to_i)
            Redis.current.set(key, arr_result.to_json)
          end
        end
        result = Redis.current.exec
        Rails.logger.debug("[set_table_invalid] Redis.current.exec")
        return unless result.nil?
      rescue Exception=>e
        Rails.logger.debug("[set_table_invalid] e=>#{e}, msg=>#{e.message}")
      end
    end
  end


  def self.room_tables(room_id)
    key = "#{room_id.to_s}_#{ResultCode::ROOM_TABLES_KEY_SUFFIX}"
    result = Redis.current.get(key)
    if result.nil?
      Redis.current.set(key, [].to_json)
      return []
    end
    JSON.parse(result)
  end

  def self.new_room_table(room_id, table_id)
    key = "#{room_id.to_s}_#{ResultCode::ROOM_TABLES_KEY_SUFFIX}"
    while true
      begin
        Redis.current.watch(key)
        result = Redis.current.get(key)
        Redis.current.multi
        Rails.logger.debug("[new_room_table] result=>#{result}")
        unless result.nil?
          arr_result =  JSON.parse(result)
          Redis.current.set(key, arr_result.push(table_id).to_json)
          Rails.logger.debug("[new_room_table] Redis.current.set")
        end
        result = Redis.current.exec
        Rails.logger.debug("[new_room_table] Redis.current.exec")
        return unless result.nil?
      rescue Exception=>e
        Rails.logger.debug("[new_room_table] e=>#{e}, msg=>#{e.message}")
      end
    end

  end

  def self.get_room_match_msg(room_id)
    can_join = false
    is_in_match = false
    cur_match_seq = ""
    next_match_seq = ""
    match_ante = ""
    entry_fee = ""
    next_match_s_time = ""
    rule_desc = ""
    bonus_desc = ""
    png_name = ""
    record = GameMatch.where(:room_id => room_id, :status.lt => 3).order_by("match_seq asc")


    first_record = record.first unless record.blank?
    cur_match_seq = first_record.match_seq unless first_record.blank?
    second_record = record.second unless record.nil?

    unless second_record.nil?
      next_match_seq = second_record.match_seq unless second_record.blank?
      #next_match_s_time = second_record.begin_time.to_s
      next_match_s_time = 8.hours.since(second_record.begin_time).to_s  # add for 192.168.0.240
    end
    if !first_record.nil? and first_record.status.to_i == 0
      #next_match_s_time = first_record.begin_time.to_s
      next_match_s_time = 8.hours.since(first_record.begin_time).to_s  # add for 192.168.0.240
    elsif !second_record.nil?
      next_match_s_time = 8.hours.since(second_record.begin_time).to_s  # add for 192.168.0.240
    end

    unless first_record.nil?
      can_join = true if first_record.status.to_i < 2
      is_in_match = true if first_record.status.to_i > 0 and first_record.status.to_i < 3
      match_ante = first_record.match_ante
      entry_fee = first_record.entry_fee
      match_rule = MatchDesc.where(:short_name => first_record.rule_name).first
      rule_desc = match_rule.rule_desc unless match_rule.nil?
      png_name = match_rule.png_name unless match_rule.nil?

      match_bonus = MatchBonusSetting.where(:shot_name => first_record.bonus_name).first
      bonus_desc = match_bonus.bonus_desc unless match_bonus.nil?
    end

    [can_join, entry_fee, match_ante,is_in_match,cur_match_seq,next_match_seq, next_match_s_time, png_name, rule_desc, bonus_desc]

  end

  def self.get_room_match_msg_by_type(room_type)
    can_join = false
    is_in_match = false
    cur_match_seq = ""
    next_match_seq = ""
    match_ante = ""
    entry_fee = ""
    record = GameMatch.where(:room_type => room_type, :status.lt => 3).order_by("match_seq asc")


    first_record = record.first unless record.blank?
    cur_match_seq = first_record.match_seq unless first_record.blank?
    second_record = record.second unless record.nil?
    next_match_seq = second_record.match_seq unless second_record.blank?
    unless first_record.nil?
      can_join = true if first_record.status.to_i < 2
      is_in_match = true if first_record.status.to_i > 0 and first_record.status.to_i < 3
      match_ante = first_record.match_ante
      entry_fee = first_record.entry_fee
    end
    [can_join, entry_fee, match_ante,is_in_match,cur_match_seq,next_match_seq]

  end

  def self.get_room_match_left_time(room, room_id=nil)
    room = get_room(room_id)  if room.nil? and !room_id.nil?
    return 0 if room.nil?

    match_left_time = 0 #20.minutes.since(Time.now).to_i - Time.now.to_i
    if room.room_type.to_i!=1
      record = GameMatch.where(:room_id => room.room_id, :status.lt => 3).order_by("match_seq asc").first
      match_left_time = record.end_time.to_i - Time.now.to_i  unless record.nil?
    end

    match_left_time
  end
end