class GameTestController < WebsocketRails::BaseController
  include WebsocketRails::Logging

  def sign_in
    info "sign in user with #{message.to_json}"

    send_message "user.sign_in", {msg: "just for test #{Time.now}"}

    #new_event = WebsocketRails::Event.new("sessions.say_hello", {data:{username:"demo"}})
    #
    #self.connection.dispatcher.send(:dispatch, new_event)

  end

  def say_hello
    info "hello #{message['username']}"
  end

  #def authorize
  #  if check_authentication( message["token"], message["user_id"])
  #    connection_store["authorized"] = true
  #    #trigger authorize success
  #  else
  #    #trigger authorize failure
  #  end
  #end

  def execute_observers(event_name)
    info "event catched ...."
    info "event #{event.name} fired"
    ##["authorize", {id:333, data:{user_id:3233, token:"zzzzzz"}} ]
    #
    #if connection_store["authorized"] == false and event_name != "authorize"
    #  # trigger reject & close websocket connection
    #end
    #
    #return true if connection_store["authorized"]
    #
    #return false if event_name != "authorize"
    #
    #
    #if message["username"] != "edwardzhou"
    #  info "#{connection.inspect}"
    #  return false
    #end

    true
  end

end