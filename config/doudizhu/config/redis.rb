class Redis
  #Redis.current = Redis.new(WebsocketRails.config.redis_options)
  #Rails.logger.debug("Redis init did."+Time.now.to_s)
  def self.current
    @current ||= Redis.new(Redis.syn_option)
  end
  def self.syn_option
    {:host => '127.0.0.1', :port => '6379', :driver => :synchrony}
  end
  #Rails.logger.debug("Redis.current =>"+Redis.current.to_json)
end