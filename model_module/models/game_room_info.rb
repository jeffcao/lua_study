class GameRoomInfo

  include RedisModelAware

  define_dirty_attributes :room_id, :name, :base, :max_qualification, :min_qualification, :limit_online_count,
                          :state, :urls, :fake_online_count, :online_count, :redis_suffix ,:room_type, :match_seq,
                          :match_status, :game_server_id, :is_forced_kick_match
  define_json_attributes  :urls
  attr_accessor :foo

  def redis_key_id
    self.room_id
  end

  def redis_key_id=(val)
    self.room_id = val
  end

  def self.redis_suffix
    ResultCode::ROOM_KEY_SUFFIX
  end

  def waiting_tables
    GameRoomUtility.waiting_tables(self.room_id)
  end

  def tables
    GameRoomUtility.room_tables(self.room_id)
  end

  def on_player_join
    self.game_server_id = Process.pid.to_s
    save

  end

  def real_online_count
    r_count = 0
    unless tables.blank?
      tables.each do |t_id|
        r_table = GameTable.get_game_table(t_id, self.room_id)
        r_count = r_count + r_table.users_count unless r_table.nil?
      end
    end
    r_count
  end

end