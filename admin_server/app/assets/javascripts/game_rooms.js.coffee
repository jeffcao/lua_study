jQuery ->
  $("#game_rooms_user_id").val("14")
  $("#TestBtn").click ()=>
    alert("aa")
    user_id = $("#game_rooms_user_id").val()     7
    user_id = parseInt(user_id)
    user_id = user_id + 1
    $("#game_rooms_user_id").val(user_id)

  $("#TestBtn").click ()=>
    $.ajax({
      type:"POST",
      contentType:"json",
      url:"",
      data:"{channel_id:12}",
      dataType:'json'

           })



