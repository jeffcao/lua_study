LJ @InitPlayerInfoLayer.luat    4   % > 4  7  % @  InitPlayerInfoLayernewLayerdisplaycreate InitPlayerInfoLayer
print �   $4  % >4 7  @ newInitPlayerInfoLayercreate InitPlayerInfoLayer
printinit_player_info_callback   �   ']4  : 4 7   >: 4 7   >: 4  7>4	 %
  ) % >  7  >:   7 >4 7 4 7>  7 >G  show_player_infocontent_scale_factorGlobalSettingrootNodescaleNodeinit_input_controllerinit_player_info_callbackaddChildInitPlayerInfo.ccbiCCBReaderLoadcreateCCBProxydo_ui_close_btn_clickedon_ui_close_btn_clickeddo_ui_commit_btn_clicked__bindon_ui_commit_btn_clickedinit_player_info_sceneccb



self  (init_player_info_callback  (ccbproxy node  �  !65+  7 7 T�+  77 7+  7 7 7> >T�+  7 7 7+  77 7> >G   �isCheckedsetCheckedf_checkboxtogglem_checkboxself tag  "sender  " �  Q   T�+   7>  T�+   7>+  7) >G   �init_player_info_callbackdismissisShowingbackClickedself key   � ) ��$54  % >% :   7 7 '� ' ) 'e >: 7  7'
 >7  7%	 >  7 7 '� ' ) 'e >:
 7
  7' >7
  7% >  7 7 '� ' ) 'e >: 7  7% >4 7% >: 4 7% >: 7  74 '  ' > =7  74 '} ' > =1 7 7 7 >7 7 7 >7  77 >7  77 >4  7> 74 7 7! %" > = 74 7 7# %" > = 74 7 7 %" > = 74 7 7 %" > = 74 7 7
 %" > = 74 7 7 %" > = 74 7 7 %" > =  7$ ) >  7%  >  7& >  7' 1( >0  �G   setOnKeypadswallowOnKeypadswallowOnTouchsetVisibleclose_btn_menuCCLayerRGBAcommit_btn_menu	cast
toluaaddObjectCCArrayaddChildgender_box_layerregisterScriptTapHandlertoggle ccpsetPosition女f_checkbox男createCheckBoxm_checkboxexample@example.commail_box_layermail_box&密码为8到20位的任意字符pwd_box_layerpassword_box+昵称为不大于10位的任意字符setPlaceHoldersetMaxLengthnick_name_box_layeraddEditboxnick_name_boxkuang_a.pnginput_png0[InitPlayerInfoLayer:init_input_controller]
print									




!!!!!!!!""""""""########$$$$$$$$%%%%%%%%&&&&&&&&''''''''))))****+++--4-55self  �menuCallback Ucmenus I �  4I[4  % >4 77 % > 74 77	>7
  74 77>7 7 74 4 77>  T�) T�) >7 7 74 4 77> T�) T�) >G  f_checkboxgendertonumbersetCheckedtogglem_checkboxnick_namesetTextnick_name_boxuser_idcurrent_userGlobalSettingsetStringCCLabelTTFuser_id_lb	cast
tolua+[InitPlayerInfoLayer:show_player_info]
printself  5user_id_lb 	, �	  q�e!4  % >4 7  7> = 4  >  T�  7 % * (	  >G  4 7  7> = 4  >  T�  7 %	 *	 (
  >G   '  T�  7 %
 *	 (
  >G  4 7  7> = 4  >  T�  7 % '	�)
  (  >G  4  >  T�  7 % *	
 (  >G  7 7 7>  T�' T�'   7 %	 *
 (  >% : 3 4 77:::::	  7 
 >G  complete_user_info
emailpasswordnick_namegenderuser_idcurrent_userGlobalSetting version1.0
retry0更新资料失败failure_msg更新资料...show_progress_message_boxisCheckedtogglem_checkbox$请输入正确的邮箱地址.check_emailW邮箱地址不能为空，否则在您忘记密码时无法从系统获得密码.mail_box密码不能小于8位密码不能为空password_box昵称不能为空show_message_boxis_blankgetTextnick_name_boxtrim_blank3[InitPlayerInfoLayer:do_ui_commit_btn_clicked]
print��						
    !self  rtag  rsender  rnick_name 
hpassword Vmail 9gender #changed_info  �   $�4  % >  7 >  7 >7 ) >G  init_player_info_callbackdismisshide_progress_message_box2[InitPlayerInfoLayer:do_ui_close_btn_clicked]
printself  tag  sender   �  *�
4  % >4 77:4 77:  7 >  7 % * (  >  7	 >7
 ) >G  init_player_info_callbackdismiss更新资料成功show_message_boxhide_progress_message_boxgendernick_namecurrent_userGlobalSetting0[InitPlayerInfoLayer:do_on_trigger_success]
print��
self  data   �  �4  % >  7 >  7 7 * (  >G  failure_msgshow_message_boxhide_progress_message_box0[InitPlayerInfoLayer:do_on_trigger_failure]
print��self  data   �   34 �4   % > 4   % > 4   % > 4  % 1 > 5  1  5  4  1
 :	 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  7  4 > 4  7  4 > 4  7  4 > 0  �G  DialogInterfaceHallServerConnectionPlugin	bindUIControllerPlugin do_on_trigger_failure do_on_trigger_success do_ui_close_btn_clicked do_ui_commit_btn_clicked show_player_info init_input_controller 	ctorcreateInitPlayerInfoLayer  InitPlayerInfoLayer
classsrc.DialogInterface#src.HallServerConnectionPluginsrc.UIControllerPluginrequire	"$Y$[c[e�e�����������������������  