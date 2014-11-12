#encoding: utf-8
require 'logic/message_utility'

class MessageLogic

  include MessageUtility

  def self.on_message_notify(notify_data)
    notify_type = notify_data["notify_type"].to_i
    notify_content = notify_data["content"]
    Rails.logger.info("[on_message_notify], notify_type=>#{notify_type}")
    #notify_type, 1--from bean_competition_room msg, 2--from money_competition_room msg, 3--from tiger
    msg_seq = new_device_msg_seq
    msg_type = 1
    display = 0
    if notify_type == 1
      display = 1
      msg_type = 3
    elsif notify_type == 2
      display = 1
      msg_type = 4
    elsif notify_type == 3
      msg_type = 2
    end
    PublicMsgQueue.create(:msg_seq => msg_seq, :time_stampe => Time.now, :user_id => 0, :display_flag => display,
                          :msg_content => notify_content, :priority => 0, :state => 0, :msg_type => msg_type)

  end

  def self.get_public_notify(user_id, last_msg_seq, player)
    p_messages = nil?
    cur_last_msg_seq = 0
    if last_msg_seq == 0
      last_msg = PublicMsgQueue.last
      last_msg_seq = last_msg.msg_seq - 20 unless last_msg.nil?
    end
    Rails.logger.info("[get_public_notify], last_msg_seq=>#{last_msg_seq}")

    location = player.player_info.location
    Rails.logger.info("[get_public_notify], user.location=>#{location}")
    if location.to_i == 90 or location.to_i == 1
      p_messages = PublicMsgQueue.where(:msg_seq.gt => last_msg_seq, :state => 0).
        in(:user_id => [user_id, 0]).asc(:msg_seq).limit(20)
    elsif  location.to_i == 2
      p_messages = PublicMsgQueue.where(:msg_seq.gt => last_msg_seq, :state => 0, :msg_type.ne => 3).
        in(:user_id => [user_id, 0]).asc(:msg_seq).limit(20)
    elsif  location.to_i == 3
      p_messages = PublicMsgQueue.where(:msg_seq.gt => last_msg_seq, :state => 0, :msg_type.ne => 4).
        in(:user_id => [user_id, 0]).asc(:msg_seq).limit(20)
    end
    p_messages = PublicMsgQueue.where(:msg_seq.gt => last_msg_seq, :state => 0).
      in(:user_id => [user_id, 0]).asc(:msg_seq).limit(20)
    return_messages = []
    unless p_messages.nil?
      p_messages.each do |msg|
        return_messages.push({:msg_seq => msg.msg_seq, :content => msg.msg_content, :start_time => msg.time_stampe,
                              :msg_type => msg.msg_type, :priority => msg.priority, :display_flag => msg.display_flag})
        cur_last_msg_seq = msg.msg_seq
      end
    end
    Rails.logger.debug("[get_public_notify], return_messages=>#{return_messages}")

    Rails.logger.debug("[get_public_notify], user.location=>#{location}")
    cur_last_msg_seq = last_msg_seq if cur_last_msg_seq == 0
    {:last_msg_seq => cur_last_msg_seq, :messages => return_messages}
  end


  def self.get_device_notify(user_id, last_msg_seq)
    p_messages = nil?
    cur_last_msg_seq = 0
    if last_msg_seq == 0
      last_msg = DeviceNotifyQueue.last
      last_msg_seq = last_msg.msg_seq - 20 unless last_msg.nil?
    end
    Rails.logger.info("[get_device_notify] last_msg_seq=>#{last_msg_seq}")
    p_messages = DeviceNotifyQueue.where(:msg_seq.gt => last_msg_seq, :state => 0).
      in(:user_id => [user_id, 0]).asc(:msg_seq).limit(20)
    return_messages = []
    unless p_messages.nil?
      p_messages.each do |msg|
        return_messages.push({:msg_seq => msg.msg_seq, :content => msg.msg_content, :start_time => msg.time_stampe,
                              :priority => msg.priority})
        cur_last_msg_seq = msg.msg_seq
      end
    end
    cur_last_msg_seq = last_msg_seq if cur_last_msg_seq == 0
    {:last_msg_seq => cur_last_msg_seq, :messages => return_messages}
  end


  def self.on_match_msg_notify(notify_data)
    Rails.logger.info("[MessageLogic.on_match_msg_notify]")
    Rails.logger.debug("[MessageLogic.on_match_msg_notify], notify_data=>#{notify_data.to_json}")
    match_seq = notify_data["match_seq"].to_s
    notify_type = notify_data["notify_type"]
    room_id = notify_data["room_id"]
    e_data = {}
    g_e_notify_type = ResultCode::MATCH_G_NOTIFY_START
    room = GameRoomUtility.get_room(room_id)

    can_join, entry_fee, match_ante, is_in_match, cur_match_seq, next_match_seq =
      GameRoomUtility.get_room_match_msg(room.room_id)

    g_e_data = {:room_id => room.room_id, :can_join => can_join, :entry_fee => entry_fee, :match_ante => match_ante,
                :is_in_match => is_in_match, :cur_match_seq => cur_match_seq, :next_match_seq => next_match_seq,
                :notify_type => ResultCode::MATCH_G_NOTIFY_START,:room_type=>room.room_type}

    #online_count = GameRoomUtility.get_room_online_count(room_id) #add by at 2014-04-28
    #if  online_count >= room.limit_online_count.to_i
    #  room_full = true
    #end
    #match_recores = GameMatch.where(:room_id => room_id, :status.lt => 3, :match_seq => match_seq)
    #match_recores = match_recores.first unless match_recores.nil?


    if notify_type.to_i == 1 # 比赛开始

      e_data = {:room_id => room_id, :match_seq => match_seq, :notify_type => ResultCode::MATCH_P_NOTIFY_START,
                :content => ResultCode::MATCH_START_NOTIFY_CONTENT, :title => ResultCode::MATCH_START_NOTIFY_TITLE}
      room.match_seq = match_seq
      room.is_forced_kick_match = 0
      room.match_status = 1
      room.save

      g_e_data[:can_join] = true
      g_e_data[:is_in_match] = true
      g_e_data[:notify_type] = ResultCode::MATCH_G_NOTIFY_START

    elsif notify_type == 2 # 停止报名
      room.match_status = 2
      room.save

      g_e_data[:can_join] = false
      g_e_data[:is_in_match] = true
      g_e_data[:notify_type] = ResultCode::MATCH_G_NOTIFY_STOP_JOIN

    elsif notify_type == 3 # 比赛结束
      e_data = {:room_id => room_id, :match_seq => match_seq, :notify_type => ResultCode::MATCH_P_NOTIFY_END,
                :content => ResultCode::MATCH_END_NOTIFY_CONTENT, :title => ResultCode::MATCH_END_NOTIFY_TITLE}

      room.match_status = 3
      room.is_forced_kick_match = 1
      room.save


      g_e_data[:can_join] = false
      g_e_data[:is_in_match] = false
      g_e_data[:notify_type] = ResultCode::MATCH_G_NOTIFY_END
      game_match_end_list(match_seq, room_id)
    end


    BaseController.trigger_match_notify("ui.routine_notify", g_e_data, "global_channel")
    Rails.logger.debug("[MessageLogic.on_match_msg_notify], e_data=>#{e_data}")

    unless notify_type == 2
      BaseController.trigger_match_notify("ui.routine_notify", e_data, "m_#{match_seq}")
    end
    Rails.logger.debug("[MessageLogic.on_match_msg_notify], g_e_data=>#{g_e_data}")

  end

  def self.game_match_end_list(match_seq, room_id)
    match = GameMatch.where(:match_seq => match_seq).first
    bonus_name = match.bonus_name unless match.nil?
    Rails.logger.debug("[MessageLogic.bonus_name],bonus_name=>#{bonus_name}")
    check_join_match_user(match_seq)
    #get bonus list
    Rails.logger.debug("[MessageLogic.game_match_end_list],match_seq=>#{match_seq}, room_id=>#{room_id}")
    room = GameRoomUtility.get_room(room_id)
    room_type = room.room_type
    if bonus_name.nil?
      bonus = MatchBonusSetting.where(:room_type => room_type).order_by("created_at desc").first
    else
      bonus = MatchBonusSetting.where(:short_name => bonus_name).order_by("created_at desc").first
    end
    rank = ["", bonus.first, bonus.second, bonus.third, bonus.fourth, bonus.fifth, bonus.sixth, bonus.seventh, bonus.eighth, bonus.ninth, bonus.tenth]
    records = MatchMember.where(:match_seq => match_seq).order_by("scores desc,last_win_time asc")
    Rails.logger.debug("[MessageLogic.game_match_end_list],records=>#{records.count()}")
    i = 1

    personal_list = {}
    list = []
    user_id = []
    records.each do |p|
      if p.created_at.to_s == p.updated_at.to_s && p.user_id.to_i >50000
        Rails.logger.debug("user don't playgame")
        Rails.logger.debug("[MessageLogic.game_match_end_list],p.created_at=>#{p.created_at},p.updated_at=>#{p.updated_at}")
        next
      end
      dp_msg = ""
      dp_award_msg = ""
      notify_data = {}
      list_bonus = ""
      match_log_content = ""
      user_id.push(p.user_id)
      user = User.find_by_user_id(p.user_id)
      channel = "#{p.user_id}_hall_channel"
      new_channel = "channel_#{p.user_id}"
      Rails.logger.debug("[MessageLogic.game_match_end_list],channel=>#{channel},new_channel=>#{new_channel}")
      p.status = 1
      p.rank = i
      p.save
      personal_list["#{p.user_id}"]=i
      personal_list["#{p.user_id}_score"] = p.scores
      if i <= 10
        dp_msg = ResultCode::GAME_MATCH_TEXT_ONE
        dp_msg=dp_msg.gsub("nick_name", user.user_profile.nick_name)
        dp_msg=dp_msg.gsub("room_name", room.name)
        dp_msg=dp_msg.gsub("match_name", bonus.match_name)
        Rails.logger.debug("[MessageLogic.game_match_end_list],i=>#{i}")

        dp_award_msg = ResultCode::DP_AWARD_MSG
        dp_award_msg=dp_award_msg.gsub("i", "#{i}")
        dp_award_msg=dp_award_msg.gsub("award", "#{rank[i]}")
        balance = rank[i].to_s.match(/(\d+)/) #截取获奖所得的电话费或者得到的豆子
        money_flag = beans_flag = false
        money_flag, beans_flag = bonus_judge(rank[i])
        Rails.logger.debug("[MessageLogic.game_match_end_list],balance=>#{balance}")

        if room_type.to_i ==3
          match_log_content = ResultCode::GET_MOBILE_LOG
          Rails.logger.debug("[MessageLogic.game_match_end_list],mobile_charge_balance=>#{balance}")
          if money_flag
            user_mobile_source_log(user.user_id,balance[1].to_i,match_seq,i)
            user.user_profile.balance = balance[1].to_i + user.user_profile.balance.to_i
            user.user_profile.total_balance = balance[1].to_i + user.user_profile.total_balance.to_i
            user.user_profile.save
          elsif beans_flag
            user.game_score_info.score = user.game_score_info.score.to_i + balance[1].to_i
            user.game_score_info.save
          end
        elsif room_type.to_i ==2
          match_log_content = ResultCode::GET_BEANS_LOG
          Rails.logger.debug("[MessageLogic.game_match_end_list],beans_balance=>#{balance}")
          if beans_flag
            user.game_score_info.score = user.game_score_info.score.to_i + balance[1].to_i
            user.game_score_info.save
          end
        end
        match_log_content = match_log_content.gsub("nick_name", user.user_profile.nick_name)
        match_log_content = match_log_content.gsub("i", "#{i}")
        match_log_content = match_log_content.gsub("n", "#{balance}")
        if beans_flag
          match_log_content = match_log_content.gsub("元话费","豆子")
        end
        Rails.logger.debug("[MessageLogic.game_match_end_list],match_log_content=>#{match_log_content}")
        log = GameMatchLog.new
        log.user_id = p.user_id
        log.content = match_log_content
        log.update_attributes("match_type" => room_type)
        #log.match_type = room_type
        log.save


        Rails.logger.debug("[MessageLogic.game_match_end_list],dp_msg=>#{dp_msg}")
        Rails.logger.debug("[MessageLogic.game_match_end_list],dp_award_msg=>#{dp_award_msg}")

        notify_data = {balance: user.reload(:lock => true).user_profile.balance, dp_msg: dp_msg, dp_award_msg: dp_award_msg, win_score: p.scores.to_i, notify_type: ResultCode::MATCH_GAME_WIN, nick_name: user.user_profile.nick_name, rank: i, score: user.game_score_info.score}
        Rails.logger.debug("[MessageLogic.game_match_end_list],notify_data=>#{notify_data}")
        EM.add_timer(5) do
          BaseController.trigger_match_notify("ui.routine_notify", notify_data, new_channel)
          BaseController.trigger_match_notify("ui.routine_notify", notify_data, channel)
        end
        push_type = room_type.to_i - 1
        push_content = "#{user.user_profile.nick_name}#{match_log_content}"
        GamePushMessage::Synchronization.publish_match_msg({:user_id => user_id,
                                                            :notify_type => push_type,
                                                            :content => push_content,
                                                            :nick_name => user.user_profile.nick_name
                                                           })
        list_bonus = balance[1].to_i
        #personal_list["#{p.user_id}"]=i
        #personal_list["#{p.user_id}_score"] = p.scores
        type = "bean" if beans_flag == true
        type = "money" if money_flag == true
        list.push({:type=>type,:user_id => p.user_id, :rank => i, :scores => p.scores.to_i, :nick_name => user.user_profile.nick_name, bonus: list_bonus.to_i})

      end
      #personal_list["#{p.user_id}"]=i
      #personal_list["#{p.user_id}_score"] = p.scores
      #p.status = 1
      #p.rank = i
      #p.save
      #list.push({:user_id => p.user_id, :rank => i, :scores => p.scores.to_i, :nick_name => user.user_profile.nick_name, bonus: rank[i]})
      #list.push({:user_id => p.user_id, :rank => i, :scores => p.scores.to_i, :nick_name => user.user_profile.nick_name, bonus: list_bonus.to_i})
      i = i + 1
    end
    Rails.logger.debug("[MessageLogic.game_match_end_list,list]=>#{list}")
    Rails.logger.debug("[MessageLogic.game_match_end_list,user_id]=>#{user_id}")

    EM.add_timer(5) do
      user_id.each do |id|
        Rails.logger.debug("[MessageLogic.game_match_end_list],user_id=>#{id}")

        user = User.find_by_user_id(id)
        channel = "#{id}_hall_channel"
        rank = personal_list["#{id}"]
        win_score = personal_list["#{id}_score"].to_i
        notify_data = {win_score: win_score, notify_type: ResultCode::MATCH_GAME_LIST, :me_score => user.game_score_info.score, :me_rank => rank, :match_rank => list}
        Rails.logger.debug("[MessageLogic.game_match_end_list],notify_data=>#{notify_data}")
        player = Player.get_player(id)
        Rails.logger.debug("[MessageLogic.game_match_end_list],player.player_info.location=>#{player.player_info.location}")
        if !player.nil? and player.player_info.location.to_i== 90
          BaseController.trigger_match_notify("ui.routine_notify", notify_data, channel)
        else
          EM.add_timer(5) do
            player = Player.get_player(player.player_info.user_id)
            Rails.logger.debug("[MessageLogic.game_match_end_list] player.player_info.location=>#{player.player_info.location}")
            if !player.nil? and player.player_info.location.to_i == 90
              BaseController.trigger_match_notify("ui.routine_notify", notify_data, channel)
            else
              repeat_push_notify_data(player, channel,notify_data)
            end
          end
        end
      end
    end

  end

  def self.check_join_match_user(match_seq)
    flag = false
    record  = MatchMember.where(:match_seq=>match_seq).first
    flag = true if record.room_type.to_i == 3
    count = MatchMember.where(:match_seq => match_seq, :user_id.gt => 50000).count
    Rails.logger.debug("[MessageLogic.check_join_match_user,user_count]=>#{count.to_i}")
    join_match_user_count = MatchSystemSetting.first.join_match_user_count unless MatchSystemSetting.first.nil?
    join_match_user_count = join_match_user_count.nil? ? "#{ResultCode::JOIN_MATCH_USER_COUNT}":join_match_user_count
    Rails.logger.debug("[MessageLogic.check_join_match_user,join_match_user_count]=>#{join_match_user_count}")

    if count.to_i < join_match_user_count.to_i && flag
      content = MatchMember.where(:match_seq => match_seq).order_by("scores desc").first
      return if content.nil?
      room_id = content.room_id
      room_type = content.room_type
      max_score = content.scores
      robot_match_score = robot_score(max_score)
      Rails.logger.debug("[MessageLogic.check_join_match_user,room_id]=>#{room_id},max_score=>#{max_score}")
      i = 0
      users = User.where("user_id<50000").limit(10).order("rand()")
      users.each do |user|
        member = MatchMember.new
        member.user_id = user.user_id
        member.match_seq = match_seq
        member.room_id = room_id
        member.room_type = room_type
        member.scores = robot_match_score[i]
        member.save
        i = i + 1
      end
    end

  end

  def self.robot_score(score)
    Rails.logger.debug("[MessageLogic.robot_score,score]=>#{score}")
    return_score = []
    ResultCode::MULTIPLE_SCORE.each do |multiple|
      return_score.push((ResultCode::BASE_SCORE*multiple/ResultCode::SCORE_DIVISOR)*ResultCode::JOIN_MATCH_USER_COUNT + score)
    end
    Rails.logger.debug("[MessageLogic.robot_score,return_score]=>#{return_score}")
    return_score
  end

  def self.bonus_judge(bonus)
    money = "元\\s*"
    beans = "豆\\s*"
    money_flag = false
    beans_flag = false
    m_flag = bonus.match(money)
    money_flag = true unless m_flag.nil?
    b_flag = bonus.match(beans)
    beans_flag = true unless b_flag.nil?
    [money_flag, beans_flag]
  end


  def self.repeat_push_notify_data(player,channel,notify_data, i=nil)
    Rails.logger.debug("[MessageLogic.repeat_push_notify_data] player.player_info.location=>#{player.player_info.location}")

    i = 2 if i.nil?

    if !player.nil? and player.player_info.location.to_i == 90
      BaseController.trigger_match_notify("ui.routine_notify", notify_data, channel)
    else
      EM.add_timer(5) do
        Rails.logger.debug("[MessageLogic.repeat_push_notify_data] player.player_info.location=>#{player.player_info.location}")

        player = Player.get_player(player.player_info.user_id)
        Rails.logger.debug("[MessageLogic.repeat_push_notify_data] player.player_info.location=>#{player.player_info.location}")

        if !player.nil? and player.player_info.location.to_i == 90
          BaseController.trigger_match_notify("ui.routine_notify", notify_data, channel)
        else
          i = i.to_i + 1

          repeat_push_notify_data(player,channel,notify_data, i) if i<6
        end
      end
    end

  end

  def self.user_mobile_source_log(user_id,num,match_seq,rank)
    Rails.logger.debug("user_mobile_source_log user_id=>#{user_id},num=>#{num},match_seq=>#{match_seq}")
    user = User.find_by_user_id(user_id)
    return if user.robot==1
    record = UserMobileSource.new
    record.user_id = user_id
    record.num = num.to_f
    record.source = "#{num}元来源于比赛，比赛ID是#{match_seq},第#{rank}名"
    record.mobile_type = 3
    record.save
  end



end