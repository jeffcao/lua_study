# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@dispatcher = null
myself = @
@_all_cards = []


Array.shuffle = (a) ->
  array = a.concat()
  i = array.length
  while i > 0
    j = Math.floor(Math.random()*i);
    t = array[--i]
    array[i] = array[j]
    array[j] = t


  return array

@re_connect = () ->
  myself.dispatcher = new WebSocketRails("#{window.location.host}/websocket")

@re_subscribe_channel = (channel_name, event_name) ->
  game_channel = myself.dispatcher.subscribe(channel_name)
  if event_name.length > 0
    game_channel.bind event_name, (data) ->
      console.log "#{event_name}: #{JSON.stringify(data)}"

@success_response = (resp) ->
  console.log "success: #{JSON.stringify(resp)}"
#  if  resp.game_info?
#      channel_name = resp.game_info.channel_name
#      game_channel = myself.dispatcher.subscribe(channel_name)
#      console.log "channel_name #{channel_name}"
##      game_channel.bind "g.player_join_notify", (data) ->
##        console.log "g.player_join_notify: #{data.game_info}"
#      private_channel_name = "channel_#{resp.game_info.user_id}"
#      console.log "private_channel #{private_channel_name}"
#      private_channel = myself.dispatcher.subscribe(private_channel_name)
#      private_channel.bind "g.game_start", (data) ->
#        console.log "g.game_start: #{JSON.stringify(data)}"



 @failure_response = (resp) ->
  console.log "failure: #{JSON.stringify(resp)}"


jQuery ->

  myself.dispatcher = new WebSocketRails("#{window.location.host}/websocket")

  myself.dispatcher.on_open = (data) ->
    console.log "connection has been established: #{data}"

  myself.dispatcher.bind "test.broadcast", (data) ->
    console.log "test.broadcast: #{JSON.stringify(data)}"

  test_channel = myself.dispatcher.subscribe("test_channel_1")
  test_channel.bind "test.channel", (data) ->
    console.log "test.channel: #{JSON.stringify(data)}"
    #test "test.channel: #{JSON.stringify(data)}"

  myself.dispatcher.bind "user.sign_in", (data) ->
    console.log "user.sign_in: #{JSON.stringify(data)}"
    #divMsg.innerHTML =   "#{divMsg.innerHTML} <br /> event: user.sign_in, data: #{JSON.stringify(data)}";

  my_channel = myself.dispatcher.subscribe("channel1")
  my_channel.bind "channel1.test", (data) ->
    console.log "channel1.test: #{JSON.stringify(data)}"


  myself.dispatcher.on_message = (data) ->
    console.log "on_message: #{JSON.stringify(data)}"

