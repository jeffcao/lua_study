#encoding: utf-8
require "logic/synchronization"
require "game_table.rb"
require "logic/hall_logic"

class GameHallController < BaseController
  include BaseHelper
  include GameHallHelper
  include MobileChargeHelper
  include BuyPropHelper

  def get_room #用户大厅获取房间
    user_id = message["user_id"].to_s
    push_game_prop(user_id)
    #tiger_message = send_tiger_message(user_id)
    #unless tiger_message.nil?
    #  channel_name = "#{user_id}_hall_channel"
    #  tiger_message.each do |msg|
    #     notify_data = msg.data.merge({:notify_data=>ResultCode::TIGER_MESSAGE})
    #     WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
    #  end
    #
    #end

    #count, beans = continue_login_get_beans(user_id)
    user = User.find_by_user_id(user_id)
    sign_up_get_charge_message(user)

    #if beans.to_i > 0
    #  #user = User.find_by_user_id(user_id)
    #  notify_data = {:user_id => user_id, :score => user.reload(:lock => true).game_score_info.score, :beans => beans, :notify_type => ResultCode::CONTINUE_LOGIN_GET_BEANS, :continue_login => user.user_profile.consecutive}
    #  channel_name = "#{user_id}_hall_channel"
    #  WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
    #end

    @@connections[user_id] = connection
    notify_id = get_notify_id(message[:user_id])
    id = redis_key_pro(user_id, event.id)
    all_rooms = GameRoomUtility.get_all_rooms
    msg = []
    Rails.logger.debug("[get_room] all_rooms=>#{all_rooms}")
    show_matches = judge_show_match(user_id,"show_matches")
    show_match_beans = judge_show_match(user_id,"show_match_beans")
    all_rooms.each do |room|
      Rails.logger.debug("[user.user_profile.payment] payment=>#{user.user_profile.payment}")

      if !show_matches and room.room_type.to_i == 3
       next
      end

      if !show_match_beans and room.room_type.to_i == 2
        next
      end

      Rails.logger.debug("[get_room] user.appid=>#{user.appid},user.version=>#{user.version},room.room_type=>#{room.room_type}")
      if (user.appid.to_i ==ResultCode::CMCC_APPID_A || user.appid.to_i ==ResultCode::CMCC_APPID )&& user.version.to_s < ResultCode::CMCC_VERSION && room.room_type.to_i > 1
        next
      end
      can_join, entry_fee, match_ante, is_in_match, cur_match_seq, next_match_seq, next_match_s_time, png_name, rule_desc, bonus_desc = GameRoomUtility.get_room_match_msg(room.room_id)
      message = {:room_id => room.room_id,
                 :ante => room.base,
                 :name => room.name,
                 :min_qualification => room.min_qualification,
                 :max_qualification => room.max_qualification,
                 :status => room.state,
                 :fake_online_count => room.fake_online_count,
                 :limit_online_count => room.limit_online_count,
                 :online_count => room.online_count,
                 :urls => room.urls,
                 :notify_id => notify_id,
                 :room_type => room.room_type,
                 :can_join => can_join,
                 :entry_fee => entry_fee,
                 :match_ante => match_ante,
                 :is_in_match => is_in_match,
                 :cur_match_seq => cur_match_seq,
                 :next_match_seq => next_match_seq,
                 :next_match_s_time => next_match_s_time,
                 :png_name => png_name,
                 :rule_desc => rule_desc,
                 :bonus_desc => bonus_desc
      }
      msg.push(message)
    end
    redis_key_value(id, msg)

    if message[:retry] == ResultCode::CONNECTION_RETRY_BEGIN
      trigger_success(:room => msg)
    elsif Redis.current.exists(id)
      msg = Redis.current.get(id)
      trigger_success(msg)
    end

    player = Player.get_player(user_id)
    day_act_key = "#{user_id}_#{Time.now.to_s.gsub!("-","")[0,8]}"
    if Redis.current.exists(day_act_key) && Redis.current.get(day_act_key).to_i ==0
      player.on_enter_hall do |text, voice, u_id|
        channel_name = "#{u_id}_hall_channel"
        notify_data = {:user_id => u_id, :text => text, :voice => voice, :notify_type => ResultCode::PROP_VOICE}
        WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
      end
      Redis.current.set(day_act_key,1)
    else
      player.on_enter_hall
    end
  end

  def sign_out
    user_id = message[:user_id]
    user = get_user(user_id)
    if Redis.current.exists(user.login_token)
      Redis.current.del(user.login_token)
    end
    trigger_success()
  end

  def request_enter_room
    room_id = message["room_id"]
    user_id = message["user_id"]
    player = Player.get_player(user_id)
    Rails.logger.debug("[request_enter_room] room_id=>#{room_id} ")

    if player.in_game?
      instances = HallLogic.get_game_server_instances
      Rails.logger.debug("[request_enter_room] instances: "+instances.to_json)
      server_id = instances[rand(0..instances.length-1)]
      Rails.logger.debug("[request_enter_room] server_id: "+server_id)
      table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
      alive_player_id = table.get_alive_player_id
      unless alive_player_id.nil?
        alive_player = Player.get_player(alive_player_id)
        server_id = alive_player.player_info.game_server_id
        Rails.logger.debug("[request_enter_room] alive_player.game_server_id: "+server_id)
      end

      DdzHallServer::Synchronization.publish({:user_id => user_id,
                                              :notify_type => GameTable::GameTimingNotifyType::KICK_USER,
                                              :server_id => server_id
                                             })
    end

    room = GameRoomUtility.get_room(room_id)
    failure_msg = nil
    failure_msg = {:result_code => ResultCode::ROOM_NOT_FOUND} if room.nil?
    #进入房间时做判断
    Rails.logger.debug("[request_enter_room]room_type=>#{room.room_type}")

    unless room.nil?
      if room.room_type.to_i!=1 and (room.match_status.to_i==0 or room.match_status.to_i>=3)
        failure_msg = {:result_code => ResultCode::ROOM_NO_ENTRY}
      end

      if room.room_type.to_i!=1 #判断用户是否报名
        record = GameMatch.where(:room_id => room_id, :status.lt => 3).order_by("match_seq asc")
        if record.count!=0
          match_seq = record.first.match_seq
          member_record = MatchMember.where(:user_id => user_id, :match_seq => match_seq)
          if member_record.count ==0
            failure_msg = {:result_code => ResultCode::ROOM_NO_ENTRY}
          end
        else
          failure_msg = {:result_code => ResultCode::ROOM_NO_ENTRY}
        end

      end
      ##需要加个如果是活动房间的话 先判断用户是否报名
    end
    player = Player.get_player(user_id) if failure_msg.nil?
    failure_msg = {:result_code => ResultCode::USER_NOT_FOUND} if player.nil?

    check_result = nil
    check_result, result_msg = check_room_available(room, player) if failure_msg.nil?
    failure_msg = {:result_code => check_result, :result_message => result_msg} unless check_result.nil?

    if failure_msg.nil?
      visit_room_count(room_id, user_id)
      User.record_user_game_teach(user_id, "enter_room")

      e_data = {:room_id => room_id, :room_name =>room.name, :user_id => user_id, :urls => room.urls}

      DdzHallServer::Synchronization.publish({:user_id => user_id,
                                              :notify_type => GameTable::GameTimingNotifyType::ENTER_ROOM_TYPE,
                                              :room_id => room_id,
                                              :nick_name => player.player_info.nick_name
                                             })
      trigger_success(e_data)
      Rails.logger.debug("[on_player_request_room] return data: "+e_data.to_json)
    else
      #controller.trigger_failure(failure_msg)
      trigger_failure(failure_msg)
      Rails.logger.debug("[on_player_request_room] return data: "+failure_msg.to_json)
    end

  end

  def fast_request_enter_room
    user_id = message["user_id"]
    player = Player.get_player(user_id)
    available_room = nil

    failure_msg = {:result_code => ResultCode::USER_NOT_FOUND} if player.nil?

    if failure_msg.nil?
      rooms = GameRoomUtility.get_all_rooms()
      begin
        tmp_rooms = rooms.sort { |x, y|
          y.max_qualification.to_i <=> x.max_qualification.to_i
        }
      rescue Exception => e
        Rails.logger.debug("[fast_request_enter_room] room.sort failed. rooms=>#{rooms.to_json}")
        raise "[fast_request_enter_room] room.sort failed"
      end
      result_msg = ""
      if tmp_rooms.blank?
        check_result = ResultCode::ROOM_NOT_FOUND
      else
        tmp_rooms.each do |room|
          if room.room_type.to_i!=1
            next
          end
          check_result, result_msg = check_room_available(room, player)
          available_room = room if check_result.nil?
          break unless available_room.nil?
        end
      end

      failure_msg = {:result_code => check_result, :result_message => result_msg} if available_room.nil?
    end

    unless failure_msg.nil?
      #controller.trigger_failure(failure_msg)
      trigger_failure(failure_msg)
      Rails.logger.debug("[fast_begin_game] return data: "+failure_msg.to_json)
    else
      e_data = {:room_id => available_room.room_id,:room_name =>available_room.name, :user_id => user_id, :urls => available_room.urls}
      #controller.trigger_success(e_data)
      visit_room_count(available_room.room_id, user_id)
      User.record_user_game_teach(user_id, "enter_room")


      DdzHallServer::Synchronization.publish({:user_id => user_id,
                                              :notify_type => GameTable::GameTimingNotifyType::ENTER_ROOM_TYPE,
                                              :room_id => available_room.room_id,
                                              :nick_name => player.player_info.nick_name
                                             })
      trigger_success(e_data)
      Rails.logger.debug("[fast_begin_game] return data: "+e_data.to_json)
    end

  end

  def check_room_available(room, player)
    online_count = GameRoomUtility.get_room_online_count(room.room_id)
    result = nil
    msg = nil
    result = ResultCode::ROOM_MAINTENANCE if room.state == 1
    if result.nil? and online_count >= room.limit_online_count.to_i and room.limit_online_count.to_i > 0
      result = ResultCode::ROOM_FULL
    end

    user = User.find_by_user_id(player.player_info.user_id)
    if user.game_score_info.reload(:lock => true).score < room.min_qualification.to_i && result.nil?
      result = ResultCode::UN_MATCH_QUALIFICATION
    end
    #进入房间时做判断

    #if room.match_status.to_i==0 or room.match_status.to_i>=3
    #  result == ResultCode::ROOM_NO_ENTRY
    #end

    if result == ResultCode::ROOM_MAINTENANCE
      msg = ResultCode::ROOM_MAINTENANCE
    elsif result == ResultCode::ROOM_FULL
      msg = ResultCode::ROOM_IS_FULL
    elsif result == ResultCode::UN_MATCH_QUALIFICATION
      msg = ResultCode::BEANS_IS_NOT_ENOUGH
    elsif result == ResultCode::ROOM_NO_ENTRY
      msg = ResultCode::ROOM_IS_NOT_ENTRY
    end
    [result, msg]
  end

  def on_client_error
    logger.error "[on_client_error] #{event.connection} got error: " + (message.blank? ? "empty" : message.to_json)
  end

  def feedback
    result_code = ResultCode::SUCCESS
    user_id = message[:user_id]
    Rails.logger.debug("[feedback] user_id: "+"#{message[:user_id]}")
    if user_id.nil?
      trigger_failure()
      return
    end
    name = nick_name(message[:content])
    unless name.nil?
      trigger_failure({:result_code => ResultCode::HAVE_BAN_WORD, :result_message => ResultCode::HAVE_BAD_WORD_WARN_F})
      return
    end

    user = User.find_by_user_id(user_id)
    feedback = Feedback.new
    feedback.user_id = user_id
    feedback.brand = user.brand
    feedback.model = user.model
    feedback.display = user.display
    feedback.os_release = user.os_release
    feedback.content = message[:content]
    feedback.manufactory = user.manufactory
    Rails.logger.debug("[feedback] content: "+"#{message[:content]}")
    feedback.save
    msg = {:result_code => result_code,
           :user_id => user_id
    }
    trigger_success(msg)
  end

  def share_weibo
    return if message[:weibo].nil?
    weibo = message[:weibo]
    weibo = weibo.downcase
    record = ShareWeibo.find_by_weibo_type(weibo)
    result_code = ResultCode::SUCCESS
    url = nil
    unless record.nil?
      url = record.url+"?appkey=" + record.appkey + "&title=" + record.title + "&ralateUid=" + record.ralate_uid
    end
    msg = {:result_code => result_code,
           :url => url
    }
    trigger_success(msg)
  end


  def user_online_time_get_beans
    #user_id = message[:user_id]
    #msg = UserOnlineTime.user_online_time(user_id)
    trigger_failure({result_code: 1,msg: "功能已经取消"})
    #trigger_success(msg)

  end

  def get_day_activity
    result_code = ResultCode::SUCCESS
    week = Time.now.wday
    activity = Activity.find_by_week_date(week)
    unless activity.nil?
      msg = {result_code: result_code, week: week, content: activity.activity_content, name: activity.activity_name, object: activity.activity_object}
      trigger_success(msg)
    else
      msg = {result_code: ResultCode::NO_ACTIVITY}
      trigger_failure(msg)
    end
  end

  def visit_room_count(room_id, user_id)
    return if room_id.nil? or user_id.nil?
    flag = VisitRoomCount.find_by_game_room_id_and_user_id(room_id, user_id)
    if flag.nil?
      count = VisitRoomCount.new
      count.game_room_id = room_id
      count.user_id = user_id
      count.date = Time.now.strftime("%Y-%m-%d")
      count.count = 1
      count.save
    else
      flag.count = flag.count + 1
      flag.save
    end
  end

  def ui_visit_count
    logger.info("[ui_visit_count], about=>#{message[:about].to_s}")
    message.each_with_index do |index|
      key = index[0]
      value = index[1]
      time_count = 0
      time = value.to_s.split("-")
      click_count = time.size - 1
      time.each do |value|
        time_count = time_count + value.to_i/1000
      end
      logger.info("[ui_visit_count], key=>#{key},value=>#{value}")
      record = UiManage.find_by_content(key)
      next if record.nil?
      logger.info("[ui_visit_count], time_count=>#{time_count},click_count=>#{click_count}")


      id = record.id
      ui_count = VisitUiCount.find_by_id(id)|| VisitUiCount.new
      ui_count.ui_id = id
      ui_count.click_count = click_count
      ui_count.time_count = time_count
      ui_count.save


    end


    #second = message[:second].to_i
    #return if id.nil? or second.nil?
    #return if UiManage.find(id).nil?
    #record = VisitUiCount.find_by_ui_id(id)
    #if record.nil?
    #  count = VisitUiCount.new
    #  count.ui_id = id
    #  count.click_count = 1
    #  count.time_count = second + count.time_count
    #  count.save
    #else
    #  record.click_count = record.click_count + 1
    #  record.time_count = record.time_count + second
    #  record.save
    #end
  end

  def prepare_sign_out
    user_id = message[:user_id]
    logger.info("[prepare_sign_out], user_id=>#{user_id}")

    player = Player.get_player(user_id)
    player.on_prepare_sign_out do |text, voice, u_id|
      channel_name = "#{u_id}_hall_channel"
      notify_data = {:user_id => u_id, :text => text, :voice => voice, :notify_type => ResultCode::PROP_VOICE}
      WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
    end
  end

  def self.broadcast_message(event_name, message, options={})
    #WebsocketRails::BaseController.send_message(event_name,message)
    Rails.logger.info("#{message}")
    Rails.logger.info("#{@@connections.class}")

    Rails.logger.info("broadcast_message=>size =>#{@@connections.size}")
    options.merge! :data => message, :id => options[:id]
    event = WebsocketRails::Event.new(event_name, options)

    @@connections.each do |key, value|
      Rails.logger.info("broadcast_message_channel=>#{value}")
      value.trigger event
    end


  end

  def get_salary
    return if message[:user_id].nil?
    user_id = message[:user_id]

    salary = [0, 1200, 3500, 7000, 13000]
    Rails.logger.info("get_salary_user_id#{user_id}")
    user = User.find_by_user_id(user_id)
    if user.vip_level.to_i == 0
      return
    end
    date = Time.now.strftime("%Y-%m-%d")
    record = GetSalary.find_by_user_id_and_date(user_id, date)
    level = user.vip_level
    if record.nil?
      user.game_score_info.score = user.game_score_info.score + salary[level]
      user.game_score_info.save
      record = GetSalary.new
      record.user_id = user_id
      record.date = date
      record.save
      msg = {:result_code => ResultCode::SUCCESS, :salary => salary[level]}
    else
      msg = {:result_code => ResultCode::GET_SALARY_REPEAT}
    end
    Rails.logger.info("get_salary_msg#{msg.to_json}")
    trigger_success(msg)
  end

  def get_system_message
    #0=>消息显示后自动消失
    #1=>消息成滚动循环形式在手机屏幕上显示
    #3=>消息显示后需要用户点后消失
    if message[:time].nil? or message[:time].to_i==0
      result_code = ResultCode::SYSTEM_MESSAGE_NULL
      trigger_failure({:result_code => result_code, :message_time => Time.now.to_s})
      return
    end


    time = message[:time]
    result_code = ResultCode::SUCCESS
    Rails.logger.info("get_system_message_time#{time}")

    return_message = []
    messages = SystemMessage.where("created_at>?", time.to_time)
    Rails.logger.info("get_system_message_messages#{messages.size}")


    messages.each do |msg|
      tmp_msg = {}
      tmp_msg = {:content => msg["content"], :message_type => msg["message_type"]}
      Rails.logger.info("get_system_message_tmp_msg#{tmp_msg}")
      return_message.push(tmp_msg)
    end

    Rails.logger.info("get_system_message_return_message#{return_message}")

    if return_message.blank?
      result_code = ResultCode::SYSTEM_MESSAGE_NULL
      trigger_failure({:result_code => result_code, :message_time => Time.now.to_s})
    else
      trigger_success({:result_code => result_code, :system_message => return_message, :message_time => Time.now.to_s})
    end

  end

  def push_game_prop(user_id)
    key = "#{user_id}_push_prop"
    push_flag = judge_show_prop(user_id,"push_props")
    if push_flag == false
      return
    end
    if Redis.current.exists(key)
      prop_flag = Redis.current.get(key)
      if prop_flag.to_i == 1
        return
      end
    else
      Redis.current.set(key, 0)
    end
    #unless connection_store["ad_#{user_id}"].nil?
    #  if connection_store["ad_#{user_id}"].to_i != 0
    #     return
    #  end
    #else
    #  return
    #end
    #connection_store["ad_#{user_id}"] = 1
    Redis.current.set(key, 1)
    user = User.find_by_user_id(user_id)
    num = rand(0..100)
    if user.user_profile.first_buy.to_i != 1
      prop = GameProduct.find_by_product_name(ResultCode::SHOUCHONGDALIBAO)
      content = {title: ""}
    elsif num <=20
      prop = GameProduct.find_by_product_name(ResultCode::HUSHENKA)
      content = {title: ResultCode::GAME_OVER_PUSH_HUSHENKA}
    elsif num<=60
      prop = GameProduct.find_by_product_name(ResultCode::SHUANGBEIJIFENKA)
      content = {title: ResultCode::GAME_OVER_PUSH_SHUANGBEIJIFENKA}
    else
      prop = GameProduct.find_by_product_name(ResultCode::JIPAIQI)
      content = {title: ResultCode::GAME_OVER_PUSH_JIPAIQI}

    end
    consume_code = prop.prop_consume_code.nil? ? "" : prop.prop_consume_code.consume_code

    unless prop.nil?
      notify_data = {note: prop.note, icon: prop.icon, rmb: prop.price.to_f/100, price: prop.price, consume_code: consume_code, name: prop.product_name, prop_note: prop.note, id: prop.id, notify_type: ResultCode::PUSH_GAME_PROP} unless prop.nil?
      notify_data.merge!(content)
      channel = user_id + "_hall_channel"

      WebsocketRails[channel].trigger("ui.routine_notify", notify_data)
    end
  end

  def slot_machine
    user_id = message[:user_id]
    user = User.find_by_user_id(user_id)
    num = ""
    content = nil
    if user.game_score_info.reload(:lock => true).score < 100000
      notify_data = {result_code: ResultCode::NO_ENOUGH_BEANS}
      trigger_failure(notify_data)
      return
    else
      user.game_score_info.reload(:lock => true).score = user.game_score_info.reload(:lock => true).score-100000
      user.game_score_info.save
      num = rand(1..1000)
    end
    Rails.logger.info("slot_machine_num=>#{num}")


    if (user.total_consume.to_f > 10.0 and user.prize==0) or num < 2
      Rails.logger.info("slot_machine_total_consume=>#{total_consume}")
      if user.prize == 0
        user.prize = 1
        user.save
      end
      user.user_profile.balance = user.user_profile.balance + 10
      user.user_profile.total_balance = user.user_profile.total_balance.to_i + 10
      user.user_profile.save
      notify_data = {content: ResultCode::MOBILE_CHARGES, result_code: ResultCode::SUCCESS}
      content = ResultCode::PUBLISH_TIGER_CHARGES_MSG
    elsif num<113
      user.game_score_info.score = user.game_score_info.score + 300000
      user.game_score_info.save
      content = ResultCode::PUBLISH_TIGER_TWO_PRIZE_MSG
      notify_data = {content: ResultCode::TWO_PRIZE, result_code: ResultCode::SUCCESS, score: user.game_score_info.reload(:lock => true).score}
    elsif num < 224
      content = ResultCode::PUBLISH_TIGER_THREE_PRIZE_MSG
      prop = GameProduct.find_by_product_name(ResultCode::JIPAIQI)
      record = UserProductItemCount.find_by_user_id_and_game_product_item_id(user.id, prop.id)
      if record.nil?
        record = UserProductItemCount.new
        record.user_id = user.id
        record.game_product_item_id = prop.id
        record.item_count = 1
        record.save
      else
        record.item_count = 1 + record.item_count
        record.save
      end
      notify_data = {content: ResultCode::THREE_PRIZE, result_code: ResultCode::SUCCESS, score: user.game_score_info.reload(:lock => true).score}
    else
      notify_data = {content: ResultCode::CONSOLATION_PRIZE, result_code: ResultCode::SUCCESS, score: user.game_score_info.reload(:lock => true).score}
      user.game_score_info.reload(:lock => true).score = user.game_score_info.reload(:lock => true).score+50000
      user.game_score_info.save
    end

    unless content.nil?
      content = content.gsub("xxx", user.user_profile.nick_name)
      DdzHallServer::Synchronization.publish_tiger_msg({:user_id => user_id,
                                                        :notify_type => 3,
                                                        :content => content,
                                                        :nick_name => user.user_profile.nick_name
                                                       })
    end

    Rails.logger.info("slot_machine_notify_data=>#{notify_data}")
    log_record = SlotMachineLog.new
    log_record.user_id = user.id
    log_record.content = notify_data[:content]
    log_record.save
    player = Player.get_player(user_id)
    unless player.nil?
      if player.player_info.location.to_i != 90
        tiger_message = SendTigerMessage.new
        tiger_message.user_id = user_id
        tiger_message.data = notify_data
        tiger_message.save
      end
    end
    trigger_success(notify_data)

  end

  def get_match_list
    matches = MatchDesc.where("state" => 1)
    message = []

    matches.each do |match|
      can_join, entry_fee, match_ante, is_in_match, cur_match_seq, next_match_seq = GameRoomUtility.get_room_match_msg_by_type(match.match_type)
      room_id = GameRoomUtility.get_room_by_type(match.match_type)
      tmp_msg = {room_id: room_id,
                 name: match.name,
                 short_desc: match.short_desc,
                 match_type: match.match_type,
                 description: match.description,
                 rule_desc: match.rule_desc,
                 begin_date: match.begin_date,
                 end_date: match.end_date,
                 image_id: match.image_id,
                 :can_join => can_join,
                 :entry_fee => entry_fee,
                 :match_ante => match_ante,
                 :is_in_match => is_in_match,
                 :cur_match_seq => cur_match_seq,
                 :next_match_seq => next_match_seq}
      if !can_join && next_match_seq.blank?
        next
      end
      message.push(tmp_msg)

    end
    trigger_success({result_code: ResultCode::SUCCESS, match: message})
  end

  def join_match
    user_id = message[:user_id]
    user = User.find_by_user_id(user_id)
    match_seq = message[:match_seq]
    game_match = GameMatch.where("match_seq" => match_seq).first
    time = 0

    unless game_match.nil?
      if game_match.status.to_i>1
        trigger_failure({result_code: ResultCode::GAME_MATCH_IS_NULL})
        return
      end
      if game_match.begin_time > Time.now
        time = game_match.begin_time.to_i - Time.now.to_i
      end
      room_id = game_match.room_id
      room = GameRoomUtility.get_room(room_id)
      online_count = GameRoomUtility.get_room_online_count(room_id)
      if  online_count >= room.limit_online_count.to_i
        trigger_failure({result_code: ResultCode::ROOM_FULL})
        return
      end
      Rails.logger.info("join_match——game_match.entry_fee=>#{game_match.entry_fee}")
      if  user.game_score_info.score < game_match.entry_fee.to_i
        trigger_failure({result_code: ResultCode::NO_ENOUGH_BEANS})
        return
      end

    end

    if game_match.nil?
      trigger_failure({result_code: ResultCode::GAME_MATCH_IS_NULL})
      return
    end
    #record = MatchMember.find_by_user_id_and_match_seq_and_status(user_id, match_seq, 0)
    record = MatchMember.where("user_id" => user_id, "match_seq" => match_seq, :status.lt => "2").first
    if record.nil?
      user.game_score_info.score = user.game_score_info.score - game_match.entry_fee.to_i
      user.game_score_info.save
      record = MatchMember.new
      record.user_id = user_id
      record.room_id = game_match.room_id
      record.room_type = room.room_type
      record.match_seq = match_seq
      record.scores = 0
      record.status = 0
      record.save
    else
      trigger_failure({result_code: ResultCode::USER_ALREADY_JOIN})
      return
    end
    joined_match = user_get_match_seq(user_id)
    trigger_success({result_code: ResultCode::SUCCESS, score: user.game_score_info.reload(:lock => true).score, joined_match: joined_match, time: time})
  end

  def user_get_match_seq(user_id)
    joined_match = []
    match_seqs = MatchMember.where(:user_id => user_id, :status => 0)
    unless match_seqs.nil?
      match_seqs.each do |seqs|
        joined_match.push(seqs.match_seq)
      end
    end
    joined_match
  end

  def send_tiger_message(user_id)
    records = nil
    records = SendTigerMessage.where("user_id" => user_id, "status" => 0)
    records
  end

  def game_match_log
    msg = []
    user_id = message[:user_id]
    room_type = message[:room_type]
    Rails.logger.debug("[game_match_log],user_id=>#{user_id},room_type=>#{room_type}")

    records = GameMatchLog.where("user_id" => user_id, "match_type" => room_type).order_by("created_at desc").limit(10)
    records.each do |record|
      msg.push({date: record.created_at, content: record.content})
    end
    Rails.logger.debug("[game_match_log],msg=>#{msg}")

    trigger_success({result_code: ResultCode::SUCCESS, content: msg})

  end

  def self.test_close_user(user_id,type)
    Rails.logger.debug("GameHallController.test_close_user, user_id=> #{user_id},type=>#{type}")
    u_con = @@connections[user_id.to_s]
    #if u_con != nil then
    #  u_con.on_error({connection_closed:true, error:"test_close_user=#{user_id}"})
    #end
    unless u_con.nil?
      Rails.logger.debug("enter if ")
      if type == "err"
        u_con.on_error({connection_closed:true, error:"on_error_test_close_user=#{user_id}"})
      else
        Rails.logger.debug("GameHallController.on_close_user")
        u_con.on_close({connection_closed:true, error:"on_close_test_close_user=#{user_id}"})
      end

    end

  end

  def get_room_match_list
    Rails.logger.info("GameHallController.get_room_match_list")
    room_id = message[:room_id]
    user_id = message[:user_id]
    Rails.logger.info("GameHallController.get_room_match_list, room_id=>#{room_id}, user_id=>#{user_id}")
    match_list = []
    rule_info = {}
    bonus_info = {}
    room_full = false

    room = GameRoomUtility.get_room(room_id)
    online_count = GameRoomUtility.get_room_online_count(room_id)
    if  online_count >= room.limit_online_count.to_i
      room_full = true
    end
    Rails.logger.info("GameHallController.get_room_match_list, online_count=>#{online_count}, room_full=>#{room_full}")

    max_tomorrow_seq = Time.now.strftime("%Y%m%d").to_i*1000+999
    match_recores = GameMatch.where(:room_id => room_id, :status.lt => 3, :match_seq.lt => max_tomorrow_seq).order_by("match_seq asc")
    Rails.logger.info("GameHallController.get_room_match_list, match_recores.count=>#{match_recores.count}")

    match_recores.each do |record|
      can_join = false
      is_in_match = false
      p_is_joined = false
      match_state = 10

      can_join = true if record.status.to_i < 2
      is_in_match = true if record.status.to_i > 0 and record.status.to_i < 3
      p_is_joined = MatchMember.where(:user_id => user_id, :match_seq => record.match_seq, :status => 0).exists?

      match_state = "10"  if can_join and !is_in_match and !room_full
      match_state = "11"  if can_join and !is_in_match and room_full
      match_state = "20"  if can_join and is_in_match and !room_full
      match_state = "21"  if can_join and is_in_match and room_full
      match_state = "30"  if !can_join and is_in_match


      begin_time = record.begin_time.strftime("%H:%M")
      begin_time = 8.hours.since(record.begin_time).strftime("%H:%M")  #add for 192.168.0.240
      Rails.logger.debug("GameHallController.get_room_match_list, rule_name=>#{record.rule_name}")

      match_rule = MatchDesc.where(:short_name => record.rule_name).first
      rule_info[record.rule_name] = match_rule.rule_desc unless match_rule.nil?

      match_info = {:can_join => can_join, :is_in_match => is_in_match, :match_seq => record.match_seq, :png_name => match_rule.png_name,
                  :entry_fee => record.entry_fee, :begin_time => begin_time, :rule_name => record.rule_name, :bonus_name=> record.bonus_name,
                  :match_state => match_state, :p_is_joined => p_is_joined}
      Rails.logger.debug("GameHallController.get_room_match_list, match_info=>#{match_info}")

      match_list.push(match_info)
      Rails.logger.debug("GameHallController.get_room_match_list, record.bonus_name=>#{record.bonus_name}")

      match_bonus = MatchBonusSetting.where(:short_name => record.bonus_name).first
      bonus_info[record.bonus_name] = match_bonus.bonus_desc unless match_bonus.nil?

    end
    notify_data = {:match_list => match_list, :rule_info => rule_info, :bonus_info => bonus_info}
    Rails.logger.debug("GameHallController.get_room_match_list, notify_data=>#{notify_data}")
    trigger_success(notify_data)

  end

  
  def judge_show_match(user_id,action)
    flag = false #do not show match
    Rails.logger.debug("[GameShopPropHelper.judge_show_match], user_id:#{user_id}")
    user = User.find_by_user_id(user_id)
    user_profile = user.user_profile
    payment = user_profile.payment
    Rails.logger.debug("[GameShopPropHelper.judge_show_match], payment:#{payment}")
    if payment.nil?
      flag = false
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

  def sign_up_get_charge_message(user)
    return if user.nil?

    Rails.logger.debug("[push_sign_up_get_charge_message], sign_up_get_charge:#{user.user_profile.sign_up_get_charge}")

    if user.user_profile.sign_up_get_charge.to_i == 0
      content = ResultCode::SIGN_UP_GET_CHARGE
      notify_data = {:user_id=>user.user_id,:content=>content,:notify_type=>ResultCode::SIGN_UP_GET_CHARGE_MESSAGE}
      Rails.logger.debug("[push_sign_up_get_charge_message], notify_data:#{notify_data}")

      channel_name = "#{user.user_id}_hall_channel"
      Rails.logger.debug("[push_sign_up_get_charge_message], channel_name:#{channel_name}")

      WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
      user.user_profile.sign_up_get_charge = 1
      user.user_profile.save

      if user.user_id.to_s.length > 5 and (user.version.blank? or user.version < "2.2.0")
        channel_name = "#{user.user_id}_hall_channel"
        msg_text = "请下载安装最新版本，否则退出游戏后可能无法再次登录."
        notify_data = {:user_id => user.user_id, :content => msg_text, :notify_type => ResultCode::SIGN_UP_GET_CHARGE_MESSAGE}
        EventMachine::Timer.new(3) do
          WebsocketRails[channel_name].trigger("ui.routine_notify", notify_data)
        end

      end
    end

  end



end
