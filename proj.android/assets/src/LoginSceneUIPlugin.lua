LJ @src/LoginSceneUIPlugin.lua� +Q4   7  % ' > 74 '  '  '  > =4  7 > 74 '� ' > = 74	 '  (  > = 7
4 +  7+  > =H  �do_user_id_selected__bindregisterScriptTapHandlerccpsetAnchorPointCCSizeMakesetContentSizeCCMenuItemLabel	ccc3setColordefaultcreateCCLabelTTF����								self lb_text  ,menu_lb $menu_item  � *��2% :    7 7 '� '# ) 'e > 7' >  7 7 '� '# ) 'f > 7' >1 4 77	 %
 >4 77 %
 >7  74 	 7>	 7%
 > =7	  74 	 7>	 7%
 > =7  74 '	� '
( > =7	  74 '	� '
( > =4 77 %
 >4  74	 
	 7		>	 =5 7  74	 '
� 4   >	 =7  74	 
	 7		>	
	 7		% >	 =7  74	 '
� 4   >	 =7  74	 '
  ( >	 =4 
  T�4 4 >D
�7  7  >'�>B
N
�7  7 (	 >7  7!4	 '
 7  7">7#>	 =7  7!4	 '
  7  7">7#>	 =4$ 4% 7&%	' >4% 7&
  T�  7( 4	% 7	&	7	)	>0  �G  user_idsetUserInfo4[LoginScene:init_input_controll()] current_usercurrent_userGlobalSetting	dumpheightgetContentSizesetPosition$alignItemsVerticallyWithPaddingaddChilduser_id_list_menu
pairsccpsetAnchorPointsetContentSizeuser_id_list_layeruser_idssharedUserDefaultCCUserDefaultget_all_user_idsUserInfouser_id_list_spriteCCSizeMakesetPreferredSizekuang_a.pngspriteFrameByNamesharedSpriteFrameCacheCCSpriteFrameCachesetSpriteFrameuser_bg_spriteCCScale9Spritepwd_bg_sprite	cast
tolua forget_password_layersetMaxLengthregister_account_layeraddEditboxxiankuang02.pnginput_png.��������
            !!!!!!!!!!!""""""""$$$%%%%&&&&&&&&%%)))))**************+++++++++++++-----....//////22self  �account_box �pwd_box �createUserIdMenue �pwd_bg_sprite �user_bg_sprite �user_id_list_sprite -u9  _index _user_id   � 	  %e9
7   7) >4 4  % ) > = 4 7 % >4 7 7>%	 > 7
>4 %  $>  7  >G  setUserInfo1[LoginScene:do_user_id_selected()] user id: getStringCCLabelTTFgetLabelCCMenuItemLabel	cast
toluacallback sender	dump
printsetVisibleuser_id_list_layer				
self  &tag  &sender  &user_id_item user_id_label user_id 
 �   6lE4  % >4  74  7> >4 7>  T�G  4 7	7
  7'e >% >4 7	7  7'f >% >
  T� 7 >
  T	�4 7>  T� 74 >G  user_token_charslogin_tokensetTextforget_password_layerCCEditBoxgetChildByTagregister_account_layer	cast
toluauser_idis_blanksharedUserDefaultCCUserDefaultload_by_idUserInfo[LoginScene:setUserInfo()]
print

self  7user_id  7user *user_id_txt user_pwd_txt 	 �   2X
4  % >7  7>  T	�4  % >7  7) >T�4  % >7  7) >G  7[LoginScene:onShowUsersBtnClick] set layer visiblesetVisible9[LoginScene:onShowUsersBtnClick] set layer invisibleisVisibleuser_id_list_layer%[LoginScene:onShowUsersBtnClick]
print
self  tag  sender   �   $d4  % >4  7> 74 > =G  createRegisterScenepushScenesharedDirectorCCDirector"go to register in login scene
printself  tag  sender   �   $i4  % >4  7> 74 > =G  createForgetPasswordScenepushScenesharedDirectorCCDirector"go to register in login scene
printself  tag  sender   �   o4  % >  7 % >  7 >G  signup注册用户...show_progress_message_box)[LoginScene:onKuaisuLoginBtnClick()]
printself   �  Z�u4  % >4 77  7'e >% >4 77  7'f >% >% % 
  T� 7	> 
  T� 7	> 4
  >  T�4
  >  T� 	  T� '  T�4  % >  7 %	 >G    7 %	 >4  T�4  74	 
	 7		>	
 >5   7 	 4
 7

>T�  7 	 
 >G  sign_in_by_passwordlogin_tokensign_in_by_token	usersharedUserDefaultCCUserDefaultload_by_idUserInfouser_token_chars登录大厅服务器...show_progress_message_box,请输入正确的账号，密码信息show_message_box-请输入正确的账号，密码信息.is_blankgetTextforget_password_layerCCEditBoxgetChildByTagregister_account_layer	cast
tolua#[LoginScene:onLoginBtnClick()]
print
				self  [tag  [sender  [user_id_txt Nuser_pwd_txt 	Euser_id Duser_pwd C �   �4  % >  7 >4 7
  T�4 7 7>4 )  :  7 >G  do_connect_hall_server
closehall_server_websocketGlobalSettinghide_progress_message_box'[LoginScene:do_on_login_success()]
printself   �   �4  >4  7> 7 >  7 >G  close_login_websocketreplaceScenesharedDirectorCCDirectorcreateHallSceneself  game  s   �  7  >  7 % >G  登录失败show_message_boxhide_progress_message_boxself  	 A   �  7  >G  hide_progress_message_boxself   �   �4  % >  7 >  7 % >G  连接服务器失败show_message_boxhide_progress_message_box,[LoginScene:do_on_connection_failure()]
printself   �   �4  % >  7 >  7 % >G   连接大厅服务器失败show_message_boxhide_progress_message_box8[LoginScene:do_on_connection_hall_server_failure()]
printself   �   
*�4  > 7 > 7>G  	showsetMessagecreateYesNoDialog2self  message  dialogScene  �  +�1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : G   show_message )do_on_connection_hall_server_failure do_on_connection_failure do_on_websocket_ready do_on_login_failure enter_hall do_on_login_success do_ui_login_clicked do_ui_fast_game_clicked !do_ui_forget_pwd_btn_clicked do_ui_register_clicked do_ui_show_ids_clicked setUserInfo do_user_id_selected init_input_controll4@6RB_Ueajfpl�r���������������theClass    C    �2   5   4   1 : G   	bindLoginSceneUIPlugin��  