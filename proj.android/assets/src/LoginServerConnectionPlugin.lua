LJ $@src/LoginServerConnectionPlugin.lua�   Oi4  % >4  % >4 7 77>4 77	:4  %
 7$> 74  7> =4 77:4 77:4  % 4 7$>4 ' :4 ' :7  T�4  % >4 7:7  T�4  % >4 7:4  % >4 7 > T�  7 >G  functiondo_on_login_success	typeA[LoginServerConnectionPlugin.sign_success] on_login_success.get tencent share urltencent_share_urlget sina share urlsina_share_urlneed_init_hall_roomsshow_init_player_info_boxALoginServerConnectionPlugin.sign_success, hall_server_url=> ddz_hall_urlhall_server_urlsystem_settingscm_sim_card_prefixsharedUserDefaultCCUserDefault	save=LoginServerConnectionPlugin.sign_success, login_token=> 
tokenlogin_tokenuser_profileload_from_jsoncurrent_userGlobalSetting2LoginServerConnectionPlugin.sign_success data	dumpX[LoginServerConnectionPlugin.sign_success] updating local user info in login scene.
print					






self  Pdata  Pcur_user @ �   #4  % >4  % >4 7 > T�  7 >G  functiondo_on_login_failure	typefign_failure data	dump0[LoginServerConnectionPlugin.sign_failure].
printself  data   �  
 ?,3  ::4 7 7%  4 7	 
  >4	 7
	   >	 =G  sign_failuresign_success__bindlogin.sign_intriggerlogin_server_websocketGlobalSetting
tokenuser_id version1.0login_type102
retry0self  user_id  user_token  event_data  �  
 >43  ::4 7 7%  4 7	 
  >4	 7
	   >	 =G  sign_failuresign_success__bindlogin.sign_intriggerlogin_server_websocketGlobalSettingpassworduser_id version1.0login_type103
retry0self  username  password  event_data  �   ?<	3  4 >4 7  >4  % >4 7 7%	  4
 7 	  >4
 7	 
  > =G  sign_failuresign_success__bindlogin.sign_uptriggerlogin_server_websocketGlobalSetting6[LoginServerConnectionPlugin.signup] event_data=>	dumpcombine
tabledevice_info sign_type100
retry0	self  event_data device_info  �   bG	3  :::4 >4 7  >4  % >4	 7
 7% 	 4
 7   >
4 7   > =G  sign_failuresign_success__bindlogin.sign_uptriggerlogin_server_websocketGlobalSetting<[LoginServerConnectionPlugin.fast_sign_up] event_data=>	dumpcombine
tabledevice_infogenderpasswordnick_name sign_type101
retry0	self   nick_name   password   gender   event_data device_info  �   ZR	3  ::4 >4 7  >4  % >4 7	 7
%  4	 7
   >	4
 7   >
 =G  do_on_trigger_failuredo_on_trigger_success__bindlogin.forget_passwordtriggerlogin_server_websocketGlobalSetting?[LoginServerConnectionPlugin.forget_password] event_data=>	dumpcombine
tabledevice_info
emailuser_id 
retry0	self  user_id  mail_address  event_data device_info  �   ]4  % >4 7 > T�  7 >G  functiondo_on_websocket_ready	type7[LoginServerConnectionPlugin:on_websocket_ready()]
printself   �  g4  % >4   % >4 +  7> T�+   7>G   �functiondo_on_connection_failure	typefign_failure data	dump;[LoginServerConnectionPlugin.connect_to_login_server].
printself data   �  $De4  % >1 4 7  T�4  % >4 4  778) >:4 74
 7   >:	4 7 7%  >0  �G  connection_error	bindon_websocket_ready__bindon_openlogin_urlsnewWebSocketRailsZ[LoginServerConnectionPlugin:connect_to_login_server()] login_server is nil, init it.login_server_websocketGlobalSetting <[LoginServerConnectionPlugin:connect_to_login_server()]
print	



self  %config  %sign_failure   �   x4  % >4 7  T�4 7 7>4 )  :G  
closelogin_server_websocketGlobalSetting:[LoginServerConnectionPlugin:close_login_websocket()]
printself   �  !-�1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 7   T�4 % >  7 % 7 >0  �G  6LoginServerConnectionPlugin.close_login_websocket1LoginServerConnectionPlugin register cleanup
printregisterCleanup close_login_websocket connect_to_login_server on_websocket_ready forget_password fast_sign_up signup sign_in_by_password sign_in_by_token sign_failure sign_success&.(60A8LCWN_Yrazt}}}~~~��theClass  " Q    �2   5   4   1 : 0  �G   	bind LoginServerConnectionPlugin���  