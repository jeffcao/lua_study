LJ "@src/LoginHallConnectionPlugin.lua� 	 "4  % >4   % >4 )  :4 +  7> T�+   7>G   �function)do_on_connection_hall_server_failure	typehall_server_websocketGlobalSettingconnection_failure data	dump4[LoginHallConnectionPlugin.connection_failure].
printself data   �  'D4  % >1 4 7  T�4  % >4 4  7% 4 7	%
 $) >:4 74 7   >:4 7 7%  >0  �G  connection_error	bind#on_hall_server_websocket_ready__bindon_open/websockethall_server_url
ws://newWebSocketRails`[LoginHallConnectionPlugin:connect_to_hall_server()] hall_server_websocket is nil, init it.hall_server_websocketGlobalSetting 9[LoginHallConnectionPlugin:connect_to_hall_server()]
print
self  (connection_failure # � 
  13 4  77:4  77:4  7:4  7 7%	  4
 7   >4
 7 	  > =G  on_trigger_failureenter_hall__bindui.check_connectiontriggerhall_server_websocketrun_env
tokenlogin_token version1.0user_idcurrent_userGlobalSettingself  event_data  �   $  7  >  7 % >G  )与大厅服务器连接认证失败show_message_boxhide_progress_message_boxself  	 �   *4  % >4 7 > T�  7 >G  function&do_on_hall_server_websocket_ready	typeA[LoginHallConnectionPlugin:on_hall_server_websocket_ready()]
printself   �   24  % >  7 >4 7   >: G  enter_hall__bindafter_trigger_success!check_connection_hall_serverB[LoginHallConnectionPlugin:do_on_hall_server_websocket_ready]
printself   �  
 +84  % >4  % >  7 % >4 7  T�  7 >T�  7	 >G  do_on_websocket_readyconnect_to_hall_serverhall_server_websocketGlobalSetting进入大厅...show_progress_message_box<[LoginHallConnectionPlugin:enter_game_room] room_info: 	dump+[LoginHallConnectionPlugin:enter_hall]
printself  room_info   �  B1 :  1 : 1 : 1 : 1	 : 1 :
 G   do_connect_hall_server &do_on_hall_server_websocket_ready #on_hall_server_websocket_ready %on_check_hall_connection_failure !check_connection_hall_server connect_to_hall_server$ ,&2.?4BtheClass   I    F2   5   4   1 : G   	bindLoginHallConnectionPluginFF  