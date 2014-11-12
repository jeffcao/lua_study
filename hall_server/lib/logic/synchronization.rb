require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"
require "logic/hall_logic"

module  DdzHallServer
  class Synchronization
    attr_accessor :synchronizing

    def self.publish(event)
      singleton.publish event
    end

    def self.publish_close_user(event)
      singleton.publish_close_user event
    end

    def self.publish_game_msg(event)
      singleton.publish_game_msg event
    end

    def self.publish_tiger_msg(data)
      singleton.publish_tiger_msg data
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

    def self.synchronizing?
      singleton.synchronizing
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

    def publish_game_msg(notify_data)
      fredis_client = EM.reactor_running? ? redis : ruby_redis
      Rails.logger.debug("[Synchronization.publish] fredis_client=>"+fredis_client.to_json)
      Fiber.new do
        #event.server_token = server_token
        fredis_client.publish "game.push_message_notify", notify_data.to_json
      end.resume
    end

    def publish_close_user(notify_data)
      fredis_client = EM.reactor_running? ? redis : ruby_redis
      Rails.logger.debug("[Synchronization.publish] fredis_client=>"+fredis_client.to_json)
      Rails.logger.debug("[game.test_close_user] fredis_client=>")

      Fiber.new do
        #event.server_token = server_token
        fredis_client.publish "game.test_close_user", notify_data.to_json
      end.resume
    end

    def publish_tiger_msg(notify_data)
      fredis_client = EM.reactor_running? ? redis : ruby_redis
      Rails.logger.debug("[Synchronization.publish] fredis_client=>"+fredis_client.to_json)
      Fiber.new do
        #event.server_token = server_token
        fredis_client.publish "game.push_message_notify", notify_data.to_json
      end.resume
    end


    def server_token
      @server_token
    end

    def synchronize!
      unless @synchronizing
        #synchro = Fiber.new do
        #  #Dir[File.expand_path("../lib/hall_logic.rb", __FILE__)].each do |file|
        #  #  require file
        #  #end
        #  fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
        #  fiber_redis.subscribe "game.transaction_notify" do |on|
        #    Rails.logger.debug("game.transaction_notify")
        #    on.message do |channel, encoded_event|
        #      data = JSON.parse(encoded_event)
        #      Rails.logger.debug("[game.transaction_notify] user_id=>#{data["user_id"]}, notify_type=>#{data["notify_type"]}")
        #      ::HallLogic.do_transaction_notify(data)
        #    end
        #  end
        #end

        synchro_test = Fiber.new do

          fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
          fiber_redis.subscribe "game.test_close_user" do |on|
            Rails.logger.debug("game.test_close_user")
            on.message do |channel, encoded_event|
              Rails.logger.debug("[game.test_close_user] encoded_event=>#{encoded_event.to_json}")
              data = JSON.parse(encoded_event)
              ::HallLogic.on_test_user_close(data)
            end
          end
        end

        #synchro_unicom = Fiber.new do
        #  fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
        #  fiber_redis.subscribe "game.unicom_code" do |on|
        #    Rails.logger.debug("game.unicom_code")
        #    on.message do |channel, encoded_event|
        #      Rails.logger.debug("[game.unicom_code] encoded_event=>#{encoded_event.to_json}")
        #      data = JSON.parse(encoded_event)
        #      ::HallLogic.unicom_code(data)
        #    end
        #  end
        #
        #end

        @synchronizing = true

        #EM.next_tick { synchro.resume }
        EM.next_tick { synchro_test.resume }

        trap('TERM') do
          shutdown!
        end
        trap('INT') do
          shutdown!
        end
        trap('QUIT') do
          shutdown!
        end
      end
    end

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


