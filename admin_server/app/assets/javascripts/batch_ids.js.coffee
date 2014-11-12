@on_login_success = (data,testStatus,jqXHR) ->
  $("#user_count").val(data.user_count)
  $("#online_count").val(data.online_count)
  $("#room_count").val(data.room_count)
  $("#online_room").val(data.online_room)

@on_request_erro = (jqXHR,testStatus,errorThrown) ->
  console.log(testStatus)
  alert(testStatus)

jQuery ->
  $("#btnRefresh").click ()=>
  #  $("#user_id").val("50001")
    $.ajax({
           url:"http://192.168.0.208:3000/my_test/login.json", dataType:"json", success: on_login_success, error: on_request_erro })



