#encoding: utf-8

require 'result_code'
require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"


class SystemController
  @@sync_timing = false
  def self.init_game_cache

    Redis.current.flushdb
    Rails.logger.debug("[init_game_cache] flushdb ok.")
    Redis.current.flushall
    Rails.logger.debug("[init_game_cache] flushall ok.")

    if ActiveRecord::Base.connection.table_exists?("system_settings")
      Rails.logger.debug("start init system settings.")
      if UserId.first.nil?
        first_id = UserId.new
        first_id.next_id = 50000
        first_id.save
      end
      settings = SystemSetting.where(["enabled=? and flag=?", 1, 1])
      set = {}
      settings.each do |s|
        set = set.merge({:"#{s.setting_name}" => s.setting_value})
      end

      Redis.current.set "system_settings", set.to_json

      init_rooms_cache
      release_all_robots
      Rails.logger.debug("SetupGameEnvironment.rb did."+Time.now.to_s)
    end
  end

  def self.create_robots
    robots = User.all.select { |u| u.user_id >= 40000 and u.user_id <50000 }
    if robots.length == 0
      (40000..49999).each do |i|
        user = User.new
        user.password_salt = Guid.new.hexdigest
        user.user_id = i
        user.nick_name = user.user_id
        user.robot = 1
        user.busy = 0
        user.save
        user.game_score_info||user.build_game_score_info
        user.game_score_info.score = 2000
        user.game_score_info.save
        user.user_profile|| user.build_user_profile
        user.user_profile.user_id = user.id
        user.user_profile.nick_name = user.user_id
        user.user_profile.save
      end
    end
  end

  def self.init_robots_name
    male_name =["那一刻风情","卡布其诺","MT归来","重楼" ,"苍穹狮狂","关羽也斗地主","发哥","酷酷步文","莼爷们","秋风萧瑟","龙御苍海","书书","输了唱征服","取个名字好难","左手心写着爱","致命天舞","上帝的左眸","紫睛枫","瞬间空白","爱已荒凉","苏堤春晓","最美不过初见","找个好人嫁了","嗜血成性","笑看宇内","紫明","有你才快乐","屌丝先森","花恋蝶恋花","地主总动员","南飞的候鸟"]
    female_name = ["挽如歌","轻燕飞舞","糖果の罐子","梦中的邂逅","冰蓝梵焰","孤月晓星辰","把心晒太阳","拿贞操换真钞","冰若相思","玲玲","木偶芷水","黑夜彩虹","流氓兔","天使芊芊","寂寞乘虚而入","罂粟花开","猪宝宝^ǒ^","24K纯疯","冷色调","陌然浅笑°","Amy","夏汐","戒不掉de爱","Sansan","樱珞雪","如歌亦如梦","乱世°妖娆","旋格格","堇色流年","我爱姚明","落花伊人"]
    male_avatar = [1, 2, 3, 4, 5, 6]
    female_avatar = [50, 51, 52, 53]
    male_robots = User.where(:robot=>1).select{ |u| u.user_profile.gender ==1 }
    female_robots = User.where(:robot=>1).select{ |u| u.user_profile.gender ==2 }
    male_robots.each_with_index do |u, index|
      u.nick_name = male_name[index%31]
      u.robot = 2 if index > 30
      u.save
      u.user_profile.nick_name = u.nick_name
      u.user_profile.avatar = male_avatar[index%6]
      u.user_profile.save
    end
    female_robots.each_with_index do |u, index|
      u.nick_name = female_name[index%31]
      u.robot = 2 if index > 30
      u.save
      u.user_profile.nick_name = u.nick_name
      u.user_profile.avatar = female_avatar[index%3]
      u.user_profile.save
    end
  end

  def self.create_device_players
    robots = User.all.select { |u| u.user_id >= 90101 and u.user_id <=90200 }
    if robots.length == 0
      (90101..92000).each do |i|
        user = User.new
        user.password_salt = Guid.new.hexdigest
        user.password_digest = Digest::MD5.hexdigest("12345678" << user.password_salt)
        user.user_id = i
        user.nick_name = user.user_id
        user.robot = 0
        user.busy = 0
        user.save
        user.game_score_info||user.build_game_score_info
        user.game_score_info.score = 400000
        user.game_score_info.save
        user.user_profile|| user.build_user_profile
        user.user_profile.user_id = user.id
        user.user_profile.nick_name = user.user_id
        user.user_profile.save
      end
    end
  end

  def self.create_game_room(name, server_domain, server_port, base=100, min=500,
      max=20000, fake_online_count=100, limit_count=1000)
    room = GameRoom.new
    room.name = name
    room.ante = base
    room.max_qualification = max
    room.min_qualification = min
    room.fake_online_count = fake_online_count
    room.limit_online_count = limit_count
    room.status = 0
    room.save
    game_room_url = GameRoomUrl.new
    game_room_url.game_room_id = room.id
    game_room_url.status = 0
    game_room_url.domain_name = server_domain
    game_room_url.port = server_port
    game_room_url.save

  end
  def self.clear_game_room_cache(room_id)
    Redis.current.del("#{room_id}_#{ResultCode::ROOM_KEY_SUFFIX}")
  end

  def self.clear_player_info_cache(user_id)
    Redis.current.del("#{user_id}_#{ResultCode::USER_STATE_KEY_SUFFIX}")
  end

  def self.clear_table_info_cache(table_id)
    Redis.current.del("#{table_id}_#{ResultCode::TABLE_KEY_SUFFIX}")
  end

  def self.clear_all_waiting_tables(room_id)
    Redis.current.del("#{room_id}_#{ResultCode::WAITING_TABLES_KEY_SUFFIX}")
  end

  def self.init_rooms_cache
    rooms = GameRoom.all
    room_msg =[]
    unless Redis.current.exists(ResultCode::ALL_GAME_ROOMS_REDIS_KEY)
      rooms = GameRoom.all
      room_msg =[]
      rooms.each do |room|
        room_msg.push room.id
      end
      Rails.logger.debug("[init_rooms_cache] ALL_GAME_ROOMS=> "+room_msg.to_json)
      Redis.current.set ResultCode::ALL_GAME_ROOMS_REDIS_KEY, room_msg.to_json
    end
  end

  def self.release_all_robots
    busy_robots = User.where(:robot => 1, :busy => 1)
    busy_robots.each do |robot|
      robot.busy = 0
      robot.save
    end
  end

  def self.begin_timing_sync
    Fiber.new {
      synchronize!
    }.resume
    Rails.logger.debug("Beginning game.timing_notify sync.")
  end
  def self.publish(message)
    #Fiber.new do
    #  #event.server_token = server_token
    #  Redis.current.publish "game.timing_notify", message
    #end.resume
    Redis.current.publish "game.timing_notify", message.to_json
  end
  def self.synchronize!
    Rails.logger.debug "[self.synchronize] @@sync_timing => #{@@sync_timing}"
    unless @@sync_timing
      synchro = Fiber.new do
        Rails.logger.debug "start redis subscribing"
        #fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
        Redis.current.subscribe "game.timing_notify" do |on|
          Rails.logger.debug("on subscribed: game.timing_notify")
          on.message do |channel, encoded_event|
            Rails.logger.debug "[system_controller.game.timing_notify] channel => #{channel} , encoded_event => #{encoded_event}"
          end
        end

        info "Beginning Game Synchronization"
      end
      @@sync_timing = true
      #EM.next_tick { synchro.resume }
      synchro.resume
    end

  end
end