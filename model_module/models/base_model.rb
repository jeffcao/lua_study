class BaseModel
  #include BaseModelHelper
  include RedisModelAware

  define_dirty_attributes :name, :user_id, :players
  define_json_attributes :players

  attr_accessor :foo

  def redis_key_id
    self.user_id
  end

  def redis_key_id=(val)
    self.user_id = val
  end

end