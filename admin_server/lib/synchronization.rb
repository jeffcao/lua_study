require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"

module  DdzAdminServer
  class Synchronization

    def self.publish(event)
      singleton.publish event
    end

    def self.synchronize!
      singleton.synchronize!
    end

    def self.shutdown!
      singleton.shutdown!
    end

    def self.singleton
      @singleton ||= new
    end

    #include Logging

    def redis
      @redis ||= Redis.new(WebsocketRails.config.redis_options)
    end

    def ruby_redis
      @ruby_redis ||= begin
        redis_options = WebsocketRails.config.redis_options.merge(:driver => :ruby)
        Redis.new(redis_options)
      end
    end

    def publish(notify_data)
      fredis_client = EM.reactor_running? ? redis : ruby_redis
      Rails.logger.debug("[Synchronization.publish] fredis_client=>"+fredis_client.to_json)
      Fiber.new do
        #event.server_token = server_token
        fredis_client.publish "game.timing_notify", notify_data.to_json
      end.resume
    end



    def server_token
      @server_token
    end

    #def synchronize!
    #  unless @synchronizing
    #    synchro = Fiber.new do
    #      fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
    #      fiber_redis.subscribe "game.timing_notify" do |on|
    #        Rails.logger.debug("game.timing_notify")
    #        on.message do |channel, encoded_event|
    #          data = JSON.parse(encoded_event)
    #          Rails.logger.debug("[game.timing_notify] user_id=>#{data["user_id"]}, notify_type=>#{data["notify_type"]}")
    #          GameLogic.on_player_timing(data)
    #        end
    #      end
    #    end
    #
    #    @synchronizing = true
    #
    #    EM.next_tick { synchro.resume }
    #
    #    trap('TERM') do
    #      shutdown!
    #    end
    #    trap('INT') do
    #      shutdown!
    #    end
    #    trap('QUIT') do
    #      shutdown!
    #    end
    #  end
    #end

    def shutdown!
      #remove_server(server_token)
    end

    def generate_unique_token
      begin
        token = SecureRandom.urlsafe_base64
      end while redis.sismember("game.timing_notify_servers", token)

      token
    end

    #def register_server(token)
    #  Fiber.new do
    #    redis.sadd "game.timing_notify_servers", token
    #    info "Server Registered: #{token}"
    #  end.resume
    #end
    #
    #def remove_server(token)
    #  Fiber.new do
    #    redis.srem "game.timing_notify_servers", token
    #    info "Server Removed: #{token}"
    #    EM.stop
    #  end.resume
    #end
  end
end


