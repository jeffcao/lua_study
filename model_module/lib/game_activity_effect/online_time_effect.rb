#encoding: utf-8
class UserOnlineTime
  def self.user_online_get_beans
    activity = Activity.find_by_activity_type(1)
    result = []
    unless activity.nil?
      result = JSON.parse(activity.activity_content)
    end
    tmp_result = result.dup
    time = Array.new
    tmp_result.each_with_index do |value, index|
      next if value[1].nil?
      tmp_index = result.key(value[1])
      time = time.push(tmp_index)
    end
    Rails.logger.debug("[user_online_get_beans]  time=>#{time.to_json}, result=#{result.to_json}")
    [time, result]
  end


  #def self.user_online_time(user_id, time=nil, key)
  #  logger.debug("[user_online_time]  user_id=>#{user_id}, id=#{id}")
  #  online_time, beans = UserOnlineTime.user_online_get_beans
  #  bean = 0
  #  unless online_time.nil?
  #    bean = beans["#{time}"].to_i
  #  end
  #  Rails.logger.debug("[user_online_time] time=>#{time},bean=>#{bean}")
  #  return if time.nil? or bean==0
  #  id = online_time.find_index(time)
  #  notify_data = {:user_id => user_id, :id => id, :bean => bean, :time => time, :key => key}
  #  EventMachine.add_timer(time) do
  #    fredis_client = EM.reactor_running? ? redis : ruby_redis
  #    Rails.logger.debug("[Synchronization.publish] fredis_client=>"+fredis_client.to_json)
  #    Fiber.new do
  #      #event.server_token = server_token
  #      fredis_client.publish "game.user_online_time", notify_data.to_json
  #    end.resume
  #  end
  #end
  #
  #def self.subscribe_user_online_time
  #  online_time, beans = UserOnlineTime.user_online_get_beans
  #  synchro = Fiber.new do
  #    fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
  #    fiber_redis.subscribe "game.user_online_time" do |on|
  #      Rails.logger.debug("game.user_online_time")
  #      on.message do |channel, encoded_event|
  #        data = JSON.parse(encoded_event)
  #        time = data["time"]
  #        user_id = data["user_id"]
  #        id = data["id"].to_i
  #        bean = data["bean"].to_i
  #        key = data["key"]
  #        return if key != Redis.current.get("#{user_id}_online_name")
  #        notify_data = {:user_id => user_id, :time => time, :bean => bean}
  #        Rails.logger.debug("[game.user_online_time] user_id=>#{user_id}, id=>#{id}, bean=>#{bean}")
  #        unless @@connections["#{user_id}"].nil?
  #          user = User.find_by_user_id(user_id)
  #          user.game_score_info.score = user.game_score_info.score + bean.to_i
  #          user.game_score_info.save
  #          Redis.current.set "#{user_id}_online_count",id
  #          WebsocketRails.channel["channel_#{user_id}"].trigger("online_time", notify_data)
  #          return if id == 9     #当天赠送都已经赠送完成
  #          id = id + 1
  #          Redis.current.set "#{user_id}_online_time",online_time["#{id}"]
  #          user_online_time(user_id, online_time["#{id}"])
  #        end
  #      end
  #    end
  #  end
  #end

  #def self.set_user_redis(user_id)     #设定用户redis的建值
  #  time = 1
  #  Rails.logger.debug("[game.set_user_redis] user_id=>#{user_id}")
  #  if Redis.current.exists("#{user_id}_online_time")
  #    time = Redis.current.get("#{user_id}_online_time")
  #    key = Redis.current.get("#{user_id}_online_name")
  #  else
  #    Redis.current.set "#{user_id}_online_time", 1
  #    key = Redis.current.set "#{user_id}_online_name", "#{user_id}#{Guid.new.hexdigest}"
  #  end
  #
  #  [time, key]
  #end

  def self.user_online_time(user_id)
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
        get_beans = result[user.user_profile.online_time.to_s]
        notify_data = {user_id: user_id, online_time: user.user_profile.online_time, beans: get_beans}
        next_time = 3
        user.game_score_info.score = user.game_score_info.score + get_beans.to_i
        flag = true
      end
    else
      Rails.logger.debug("[UserOnlineTime => user_login_time]time2=>#{user.user_profile.last_active_at}")
      if Time.now.to_i-login_time.to_i > user.user_profile.online_time*60
        get_beans = result[user.user_profile.online_time.to_s]
        user.game_score_info.score = user.game_score_info.score + get_beans.to_i
        notify_data = {user_id: user_id, online_time: user.user_profile.online_time, beans: get_beans}
        Rails.logger.debug("[UserOnlineTime => data=>#{notify_data.to_json}")
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
      user.game_score_info.save
    end












    #if user.user_profile.online_time.nil? and !user.user_profile.last_active_at.nil?
    #  Rails.logger.debug("[UserOnlineTime => user_online_time] user_online_time=>#{user.user_profile.online_time}")
    #  Rails.logger.debug("[UserOnlineTime => user_online_time] last_active_at=>#{user.user_profile.last_active_at}")
    #  notify_data
    #  return
    #end
    #if user.user_profile.last_active_at.nil? or user.user_profile.last_active_at.to_s[0, 10] != Time.now.to_s[0, 10]
    #  Rails.logger.debug("[UserOnlineTime => user_online_time] Time_now=>#{Time.now}")
    #  user.user_profile.last_active_at = Time.now
    #  user.user_profile.online_time = 1
    #  user.user_profile.save
    #elsif Time.now > (user.user_profile.online_time+3).minutes.since(user.user_profile.last_active_at)
    #  user.user_profile.last_active_at = Time.now
    #  user.user_profile.online_time = 1
    #
    #elsif Time.now > 1.minutes.ago(user.user_profile.online_time.minutes.since(user.user_profile.last_active_at)) and Time
    #.now < (1+user.user_profile.online_time).minutes.since(user.user_profile.last_active_at)
    #  #增加豆子 修改最后挥动时间 修改在线时间
    #  user.user_profile.last_active_at = Time.now
    #  index = time.find_index(user.user_profile.online_time.to_s)
    #  if index.to_i == 9
    #    user.user_profile.online_time = nil
    #  else
    #    notify_data = {user_id: user_id, online_time: user.user_profile.online_time, beans: result[user.user_profile.online_time.to_s]}
    #    user.game_score_info.score = user.game_score_info.score + result[user.user_profile.online_time.to_s]
    #
    #    Rails.logger.debug("[UserOnlineTime => user_online_time] notify_data=>#{notify_data.to_json}")
    #    next_index = index.to_i + 1
    #    user.user_profile.online_time = time[next_index].to_i
    #    online_time_index = time[next_index].to_i
    #    online_time_index = time[index.to_i]
    #  end
    #  #user.game_score_info.score = user.game_score_info.score + result[online_time_index.to_s]
    #  #user.game_score_info.score = user.game_score_info.score + result[time[index].to_s]
    #  user.game_score_info.save
    #end
    #user.user_profile.save
    if notify_data.size > 0
      notify_data.merge!(score: user.reload(:lock => true).game_score_info.score, game_level: user.reload(:lock => true).game_level)
    end
    notify_data
  end

end
