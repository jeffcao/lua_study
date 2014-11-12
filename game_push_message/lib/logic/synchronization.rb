require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"
require "logic/message_logic"


module GamePushMessage
  class Synchronization
    attr_accessor :synchronizing

    def self.publish(event)
      singleton.publish event
    end

    def self.publish_match_msg(data)
      singleton.publish_match_msg data
    end

    def self.synchronize!
      singleton.synchronize! unless singleton.synchronizing
    end

    def self.shutdown!
      singleton.shutdown!
    end

    def self.singleton
      @singleton ||= new
    end

    def self.synchronizing?
      Rails.logger.info("[synchronizing.synchronizing?], synchronizing=>#{singleton.synchronizing}")
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

    def publish_match_msg(notify_data)
      fredis_client = EM.reactor_running? ? redis : ruby_redis
      Rails.logger.debug("[Synchronization.publish] fredis_client=>"+fredis_client.to_json)
      Fiber.new do
        #event.server_token = server_token
        fredis_client.publish "game.push_message_notify", notify_data.to_json
      end.resume

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

    def synchronize!
      unless @synchronizing
        synchro = Fiber.new do

          fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
          fiber_redis.subscribe("game.push_message_notify") do |on|
            Rails.logger.info("game.push_message_notify")
            on.message do |channel, encoded_event|
              Rails.logger.info("game.push_message_notify.on.message, data=>#{encoded_event.to_json}")
              begin
                data = JSON.parse(encoded_event)
                Rails.logger.debug("[game.push_message_notify.on.message] user_id=>#{data["user_id"]}, notify_type=>#{data["notify_type"]}")
                ::MessageLogic.on_message_notify(data)
              rescue  Exception => erMsg
                Rails.logger.error("[game.push_message_notify.on.message], error=>#{erMsg}")
              end
            end
          end
        end

        synchro2 = Fiber.new do

          fiber_redis = Redis.connect(WebsocketRails.config.redis_options)
          fiber_redis.subscribe("game.match_msg_notify") do |on|
            on.message do |channel, encoded_event|
              Rails.logger.info("[game.match_msg_notify.on.message], data=>#{encoded_event.to_json}")
              begin
                data = JSON.parse(encoded_event)
                Rails.logger.debug("[game.match_msg_notify.on.message], notify_type=>#{data["notify_type"]}")
                ::MessageLogic.on_match_msg_notify(data)
              rescue  Exception => erMsg
                Rails.logger.error("[game.match_msg_notify.on.message], error=>#{erMsg}")
              end
            end
          end
        end

        @synchronizing = true

        EM.next_tick { synchro.resume }
        EM.next_tick { synchro2.resume }

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

  end
end
