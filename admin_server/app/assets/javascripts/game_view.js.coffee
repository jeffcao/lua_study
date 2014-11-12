# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@on_login_success = (data,testStatus,jqXHR) ->
  $("#user_count").val(data.user_count)
  $("#online_count").val(data.online_count)
  $("#room_count").val(data.room_count)
  $("#online_room").val(data.online_room)
  $("#table_count").val(data.table_count)

@tui_song = (data,testStatus,jqXHR) ->
  $("#tuisong").html(data)

@product_success = (data,testStatus,jqXHR) ->
  value = data.split(",")
  v_return = for i,v of value
    x = v.split("#")
    name = "ka_#{x[0]}"
    $("##{x[0]}").prop("checked",true)
    $("##{name}").val(x[1])

@on_request_erro = (jqXHR,testStatus,errorThrown) ->
  console.log(testStatus)
  alert(testStatus)

jQuery ->
  $("#btnRefresh").click ()=>
    $.ajax({
      url:"view", success: on_login_success, error: on_request_erro })


  $("#test").change ()=>
    $("input").prop("checked",false)
    $("input[name^='ka']").val(0)
    #$("input").val(0)
    value = $("#test").val()
    if value > 0
     $.ajax({
           url:"product_item?product_id=#{value}", success: product_success, error: on_request_erro })

#  $("#tx").click ()=>
#    #$("#ts_id").val(123456)
#    value = $("#tx").attr("id")
#    alert(value)
#    $.ajax({
#           url:"tuisong", success: tui_song, error: on_request_erro
#           })


#    $("#tuisong tr td").remove()



  $("#TablelistRefresh").click ()=>
    location.reload()

  $("#RoomlistRefresh").click ()=>
    location.reload()

