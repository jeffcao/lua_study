LJ #@src/HallServerConnectionPlugin.lua�   '4  % >4  % >4  % 4 7 >$>4 7 > T�  7  >G  functiondo_on_trigger_success	typeM[HallServerConnectionPlugin.on_trigger_success] do_on_trigger_success=> on_trigger_success data	dump5[HallServerConnectionPlugin.on_trigger_success].
printself  data   �    4  % >4  % >4 7 > T�  7  >G  functiondo_on_trigger_failure	typeon_trigger_failure data	dump5[HallServerConnectionPlugin.on_trigger_failure].
printself  data   �   )% :  3 4 77:4 77:4 7:  7	 %
  >G  check_connectioncall_server_methodrun_env version1.0
tokenlogin_tokenuser_idcurrent_userGlobalSetting#与服务器连接认证失败failure_msgself  event_data  �   "#% :  3 4 77:  7 %  >G  get_roomcall_server_methoduser_idcurrent_userGlobalSetting version1.0
retry0获取房间列表失败failure_msgself  event_data  �   	*% :  3   7 %  >G  get_activitycall_server_method version1.0
retry0获取今日活动失败failure_msgself  
event_data  �   "0% :  3 4 77:  7 %  >G  get_user_profilecall_server_methoduser_idcurrent_userGlobalSetting version1.0
retry0获取玩家信息失败failure_msgself  event_data  �   7% :    7 %  >G  complete_user_infocall_server_method更新玩家信息失败failure_msgself  	changed_info  	 �  
 8=% :  3 4 77:::  7 %	  >G  reset_passwordcall_server_methodnewpasswordoldpassworduser_idcurrent_userGlobalSetting version1.0
retry0更改密码失败failure_msgself  old_pwd  new_pwd  event_data 
 �   D% :    7 %  >G  request_enter_roomcall_server_method请求房间失败failure_msgself  	enter_info  	 �   "I% :  3 4 77:  7 %  >G  fast_begin_gamecall_server_methoduser_idcurrent_userGlobalSetting version1.0
retry0请求房间失败failure_msgself  event_data  �   -O% :  2 4 77::  7 %  >G  feedbackcall_server_methodcontentuser_idcurrent_userGlobalSetting保存反馈信息失败failure_msgself  content  event_data 	 �   "U% :  3 4 77:  7 %  >G  shop_prop_listcall_server_methoduser_idcurrent_userGlobalSetting version1.0prop_type
retry0获取商品列表失败failure_msgself  event_data  �  	 0\% :  3 4 77::  7 %  >G  buy_propcall_server_method version1.0prop_iduser_idcurrent_userGlobalSetting购买道具失败failure_msgself  product_id  event_data 	 �  
 <c% :  3 4 77:::  7 %	  >G  timing_buy_propcall_server_method version1.0trade_idprop_iduser_idcurrent_userGlobalSetting购买道具失败failure_msgself  trad_seq  product_id  event_data 
 �   "j% :  3 4 77:  7 %  >G  cate_listcall_server_methoduser_idcurrent_userGlobalSetting version1.0
retry0获取道具列表失败failure_msgself  event_data  �  	 0q% :  3 4 77::  7 %  >G  use_catecall_server_methodprop_iduser_idcurrent_userGlobalSetting version1.0
retry0使用道具失败failure_msgself  product_id  event_data 	 �   4x4  7 7%  $ 4 7 	  >4 7	 
  > =G  on_trigger_failureon_trigger_success__bindui.triggerhall_server_websocketGlobalSettingself  method_name  pass_data   �  	 %�4  % >4  % >4 7 > T	�4  % 7 $>  7  >G  __cname.HallServerConnectionPlugin, class name=> functiondo_on_buy_produce_message	type#on_buy_product_message, data=>	dump:[HallServerConnectionPlugin:on_buy_product_message()]
printself  data   �   �4  % >  7 >4 7 > T�  7 >G  functiondo_on_websocket_ready	typeinit_channel6[HallServerConnectionPlugin:on_websocket_ready()]
printself   �  �4  % >4   % >4 +  7> T�+   7>G   �functiondo_on_connection_failure	typeconnection_failure data	dump5[HallServerConnectionPlugin.connection_failure].
printself data   �  'D�4  % >1 4 7  T�4  % >4 4  7% 4 7	%
 $) >:4 74 7   >:4 7 7%  >0  �G  connection_error	bindon_websocket_ready__bindon_open/websockethall_server_url
ws://newWebSocketRailsa[HallServerConnectionPlugin:connect_to_hall_server()] hall_server_websocket is nil, init it.hall_server_websocketGlobalSetting :[HallServerConnectionPlugin:connect_to_hall_server()]
print	



self  (connection_failure # v  	�4  % >+   7  >G   �on_buy_product_messageui.buy_prop  aaaa
printself data  
 �  'C�4  % >4 77% $4  %  $>4 77)  94 7 7
 >:	 7	  7% 1 >  7 4 7% >0  �G  ui.restore_connectioninitSocket ui.buy_prop	bindsubscribehall_channelchannelshall_server_websocket@[HallServerConnectionPlugin:init_channel()] channel_name=> _hall_channeluser_idcurrent_userGlobalSetting0[HallServerConnectionPlugin:init_channel()]
print
self  (user_channel_name 	 �   �  7  % '�>4 % >  7 % >G  socket: reopeningupdateSocket1HallServerConnectionPlugin onSocketReopening
print3正在恢复与服务器的连接，请稍候.show_progress_message_boxself   �   �4  % >  7 >  7 % >G   socket: reopened, restoringupdateSocketrestoreConnection0HallServerConnectionPlugin onSocketReopened
printself   �   �  7  >  7 % >4 % >  7 >G  	exit2HallServerConnectionPlugin onSocketReopenFail
print$恢复与服务器连接失败.show_message_boxhide_progress_message_boxself   �   �  7  >  7 % >4 % >  7 >G  	exit3HallServerConnectionPlugin onSocketRestoreFail
print$恢复与服务器连接失败.show_message_boxhide_progress_message_boxself   �   �  7  >4 % >  7 % >  7 >G  init_channelsocket: restoredupdateSocket0HallServerConnectionPlugin onSocketRestored
printhide_progress_message_boxself  data   r   �4  % >  7 ) >G  op_websocket(HallServerConnectionPlugin:on_pause
printself  	 >   � +     7   ) > G   �op_websocket      self  � 
�4  % >4 7(  1 >0  �G   add_timer
Timer)HallServerConnectionPlugin:on_resume
print����self   �   
�4  % >4 7 7 >G  pause_eventhall_server_websocketGlobalSetting,HallServerConnectionPlugin:op_websocket
printself  pause   �   �4  % >4 7  T�4 7 7>4 )  :G  
closehall_server_websocketGlobalSetting8[HallServerConnectionPlugin:close_hall_websocket()]
printself   � < >J�1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1! :  1# :" 1% :$ 1' :& 1) :( 1+ :* 1- :, 1/ :. 11 :0 13 :2 15 :4 17 :6 19 :8 1; :: 0  �G   close_hall_websocket op_websocket on_resume on_pause onSocketRestored onSocketRestoreFail onSocketReopenFail onSocketReopened onSocketReopening init_channel connect_to_hall_server on_websocket_ready on_buy_product_message call_server_method use_cate cate_list timing_buy_prop buy_prop shop_prop_list feedback fast_begin_game request_enter_room reset_password complete_user_info get_user_profile get_today_activity get_all_rooms check_connection on_trigger_failure on_trigger_success
"($/*51<7A>GCMITO[Vb]idpkxr�z����������Ŀ��������������theClass  ? t   
 �4   % > 2  5 4 1 :0  �G   	bindHallServerConnectionPlugin
cjsonrequire���json   