class PlayerConnectionInfo
  include RedisModelAware
  define_dirty_attributes :user_id, :game_server_id,:connections

  define_json_attributes :connections

  def redis_key_id
    self.user_id
  end

  def redis_key_id=(val)
    self.user_id = val
  end

  def self.redis_suffix
    ResultCode::USER_CONNECTION_INFO_SUFFIX
  end
end