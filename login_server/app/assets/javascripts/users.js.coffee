# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@dispatcher = null
myself = @

@success_response = (resp) ->
  console.log "success: #{JSON.stringify(resp)}"

@failure_response = (resp) ->
  console.log "failure: #{JSON.stringify(resp)}"

jQuery ->
  myself.dispatcher = new WebSocketRails("#{window.location.host}/websocket")

  myself.dispatcher.on_open = (data) ->
    console.log "connection has been established: #{JSON.stringify(data)}"

  myself.dispatcher.bind("connection_closed", (data) ->
    console.log "connection has been closed: #{JSON.stringify(data)}"
  )

  myself.dispatcher.bind "sessions.new_login", (data) ->
    console.log "sessions.new_login: #{JSON.stringify(data)}"

  myself.dispatcher.bind "sessions.user_logout", (data) ->
    console.log "sessions.user_logout: #{JSON.stringify(data)}"

  myself.dispatcher.bind "aaa", (data) ->
    console.log "session.sign_inaa: #{JSON.stringify(data)}"

  myself.dispatcher.bind "g.grab_lord_notify", (data) ->
    console.log "g.grab_lord_notify: #{JSON.stringify(data)}"

  myself.dispatcher.bind "g.game_start", (data) ->
    console.log "g.game_start: #{JSON.stringify(data)}"

  myself.dispatcher.on_message = (data) ->
    console.log "on_message: #{JSON.stringify(data)}"

  channel = myself.dispatcher.subscribe("1_1171")
  channel.bind "g.player_join_notify", (data) ->
    console.log "g.player_join_notify: #{JSON.stringify(data)}"

  myself.dispatcher.on_message = (data) ->
    console.log "on_message: #{JSON.stringify(data)}"
    console.log "jquery-> #{@}"


console.log "outside -> #{@}"
