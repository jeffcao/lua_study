module WebsocketRails

  class Channel
    def subscribe(connection)
      info "#{connection} subscribed to channel #{name}"
      @subscribers << connection unless @subscribers.include?(connection)
    end
  end


  module ConnectionAdapters

    class WebSocket
     def send(message)
        #Rails.logger.debug "[WebSocket.send] message: #{message}"
        @connection.send message
      end
    end

    class Base
      attr_accessor :ping_count

      def on_message(encoded_data)
        event = Event.new_from_json( encoded_data, self )
        if event.name =~ /client_ack$/
          Rails.logger.debug("[WebsocketRails.on_message] client_ack=>"+event.serialize)
          @resend_timers ||= {}
          Rails.logger.debug("[WebsocketRails.on_message] @resend_timers=>"+@resend_timers.to_json)
          srv_seq_id = event.data.blank? ? nil : event.data["__srv_seq_id"].to_i
          unless srv_seq_id.blank?
            timer = @resend_timers[srv_seq_id]
            Rails.logger.debug("[WebsocketRails.on_message] timer => #{timer.to_json}")
            if timer
              timer.cancel
              @resend_timers.delete(srv_seq_id)
            end
          end
        else
          if true || event.encoded_name !~ /(websocket_rails)/
            #EM.next_tick {
            #  trigger Event.new("server_ack", {data:{ack_id: event.id}})
            #}
            trigger Event.new("server_ack", {data:{ack_id: event.id}})
          end
          dispatch event
        end
      end

      def trigger(event)
        # Uncomment when implementing history queueing with redis
        #enqueue event
        #unless flush_scheduled
        #  EM.next_tick { flush; flush_scheduled = false }
        #  flush_scheduled = true
        #end
        if (event.encoded_name !~ /(websocket_rails)|(client_connected)|(client_disconnected)|(client_error)|(server_ack)/)
          event.data ||= {}
          event.data["__srv_seq_id"] ||= rand(0x1000000)

          resend_times = 0
          resend_timer = EventMachine::PeriodicTimer.new(2) do
              resend_times += 1
              timer_cancel = false
              event.data["__srv_resend"] = resend_times
              Rails.logger.debug("[trigger]_#{event.encoded_name}_event.serialize#{event.serialize}")
              send "[#{event.serialize}]"
              if timer_cancel or resend_times >= 5
                resend_timer.cancel
                @resend_timers.delete( event.data["__srv_seq_id"] )
              end
          end
            @resend_timers ||= {}
            Rails.logger.debug("[WebsocketRails.trigger] @resend_timers=>"+@resend_timers.to_json)
            @resend_timers[ event.data["__srv_seq_id"] ] = resend_timer
        end

        send "[#{event.serialize}]"
      end

      private
      def start_ping_timer
        @pong = true
        @ping_count = 0
        @ping_timer = EM::PeriodicTimer.new(WebsocketRails.config.ping_period) do
          if pong == true
            self.pong = false
            self.ping_count = 0
            ping = Event.new_on_ping self
            EM.next_tick{ trigger ping }
          else
            self.ping_count = self.ping_count + 1
            if self.ping_count > 2
              @ping_timer.cancel
              if not NotifyController.blank? and NotifyController.respond_to?(:event_ddz_socked_closed)
                NotifyController.event_ddz_socked_closed  self
              end
              on_error({connection_closed:true, error: "No pong message from client: #{self}"})
            else
              logger.debug "ping timeout, next #{self.ping_count} ping try."
              ping = Event.new_on_ping self
              EM.next_tick{ trigger ping }
            end

          end
        end
      end

    end
  end

  class Dispatcher

    private
    def route(event)
      actions = []
      event_map.routes_for event do |controller_class, method|
        actions << Fiber.new do
          begin
            #logger.info "new event comming..."
            #BaseController.class_variable_get("@@observers").clear if BaseController.class_variable_defined?("@@observers")
            log_event(event) do
              controller = controller_factory.new_for_event(event, controller_class, method)

              event_abort = false
              if controller.respond_to?(:execute_observers)
                event_abort = controller.send(:execute_observers, event.name) == false
              end

              if controller.respond_to?(method)
                controller.send(method) unless event_abort
              else
                raise EventRoutingError.new(event, controller, method)
              end
            end
          rescue Exception => ex
            Rails.logger.debug("[WebsocketRails.trigger], Exception, event.encoded_name=>#{event.encoded_name}")
            event.success = false
            event.data["er_msg"] = extract_exception_data ex if event.data.respond_to?("[]")
            event.trigger
          end
        end
      end
      execute actions
    end


  end

  class ConnectionManager

    private

    def open_connection(request)
      connection = ConnectionAdapters.establish_connection(request, dispatcher)

      assign_connection_id connection
      register_user_connection connection
      connections[connection.id] = connection
      Redis.current.set(ResultCode::SERVER_CONNECTIONS_COUNT_KEY,connections.count) if ResultCode.const_defined?("SERVER_CONNECTIONS_COUNT_KEY")
      info "Connection opened: #{connection}"
      connection.rack_response
    end

    def close_connection(connection)
      WebsocketRails.channel_manager.unsubscribe connection
      destroy_user_connection connection
      connections.delete connection.id
      Redis.current.set(ResultCode::SERVER_CONNECTIONS_COUNT_KEY,connections.count) if ResultCode.const_defined?("SERVER_CONNECTIONS_COUNT_KEY")
      info "Connection closed: #{connection}"
      connection = nil
    end
    public :close_connection

  end

  module Logging
    class << self
      def log_event_start(event)
        message = "Started Event: #{event.encoded_name}\n"
        message << "#{colorize(:cyan, "Name:")} #{event.encoded_name}\n"
        message << "#{colorize(:cyan, "Data:")} #{event.data.inspect}\n" if event.encoded_name !~ /client_disconnected/
        message << "#{colorize(:cyan, "Connection:")} #{event.connection}\n\n"  if event.encoded_name !~ /client_disconnected/
        info message
      end

    end

  end

end