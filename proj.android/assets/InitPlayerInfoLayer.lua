LJ @InitPlayerInfoLayer.luat    4   % > 4  7  % @  InitPlayerInfoLayernewLayerdisplaycreate InitPlayerInfoLayer
print �   $4  % >4 7  @ newInitPlayerInfoLayercreate InitPlayerInfoLayer
printinit_player_info_callback   �   ']4  : 4 7   >: 4 7   >: 4  7>4	 %
  ) % >  7  >:   7 >4 7 4 7>  7 >G  show_player_infocontent_scale_factorGlobalSettingrootNodescaleNodeinit_input_controllerinit_player_info_callbackaddChildInitPlayerInfo.ccbiCCBReaderLoadcreateCCBProxydo_ui_close_btn_clickedon_ui_close_btn_clickeddo_ui_commit_btn_clicked__bindon_ui_commit_btn_clickedinit_player_info_sceneccb



self  (init_player_info_callback  (ccbproxy node  �  !6/+  7 7 T�+  77 7+  7 7 7> >T�+  7 7 7+  77 7> >G   �isCheckedsetCheckedf_checkboxtogglem_checkboxself tag  "sender  " �  J   T�+   7>  T�+   7>+  7) >G   �init_player_info_callbackdismissisShowingbackClickedself key   � " ��$.4  % >% :   7 7 '� ' ) 'e >:   7 7 '� ' ) 'e >: 4
 7% >:	 4
 7% >: 7	  74 '  ' > =7  74 '} ' > =1 7	 7 7 >7 7 7 >7  77	 >7  77 >4  7> 74 77 % > = 74 77 % > = 74 77 % > = 74 77 % > = 74 77	 % > = 74 77 % > =  7 ) >  7  >  7 >  7  1! >0  �G   setOnKeypadswallowOnKeypadswallowOnTouchsetVisibleclose_btn_menuCCLayerRGBAcommit_btn_menu	cast
toluaaddObjectCCArrayaddChildgender_box_layerregisterScriptTapHandlertoggle ccpsetPosition女f_checkbox男createCheckBoxm_checkboxpwd_box_layerpassword_boxnick_name_box_layeraddEditboxnick_name_boxkuang_a.pnginput_png0[InitPlayerInfoLayer:init_input_controller]
print								        """"####$$$&&-&..self  �menuCallback 3[menus A �  4IT4  % >4 77 % > 74 77	>7
  74 77>7 7 74 4 77>  T�) T�) >7 7 74 4 77> T�) T�) >G  f_checkboxgendertonumbersetCheckedtogglem_checkboxnick_namesetTextnick_name_boxuser_idcurrent_userGlobalSettingsetStringCCLabelTTFuser_id_lb	cast
tolua+[InitPlayerInfoLayer:show_player_info]
printself  5user_id_lb 	, � 
  @�^4  % >4 7  7> = 4  >  T�  7 % >G  4 7  7> = 4  >  T�  7 %	 >G  7
 7 7>  T�' T�'   7 % >% : 3 4 77::::  7 	 >G  complete_user_infopasswordnick_namegenderuser_idcurrent_userGlobalSetting version1.0
retry0更新资料失败failure_msg更新资料...show_progress_message_boxisCheckedtogglem_checkbox密码不能为空password_box昵称不能为空show_message_boxis_blankgetTextnick_name_boxtrim_blank3[InitPlayerInfoLayer:do_ui_commit_btn_clicked]
print				
self  Atag  Asender  Anick_name 
7password 'gender changed_info  �   $t4  % >  7 >  7 >7 ) >G  init_player_info_callbackdismisshide_progress_message_box2[InitPlayerInfoLayer:do_ui_close_btn_clicked]
printself  tag  sender   �   ({
4  % >4 77:4 77:  7 >  7 % >  7	 >7
 ) >G  init_player_info_callbackdismiss更新资料成功show_message_boxhide_progress_message_boxgendernick_namecurrent_userGlobalSetting0[InitPlayerInfoLayer:do_on_trigger_success]
print
self  data   �   �4  % >  7 >  7 7 >G  failure_msgshow_message_boxhide_progress_message_box0[InitPlayerInfoLayer:do_on_trigger_failure]
printself  data   �   23 �4   % > 4   % > 4   % > 4  % 1 > 5  1  5  4  1
 :	 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  7  4 > 4  7  4 > 4  7  4 > G  DialogInterfaceHallServerConnectionPlugin	bindUIControllerPlugin do_on_trigger_failure do_on_trigger_success do_ui_close_btn_clicked do_ui_commit_btn_clicked show_player_info init_input_controller 	ctorcreateInitPlayerInfoLayer  InitPlayerInfoLayer
classsrc.DialogInterface#src.HallServerConnectionPluginsrc.UIControllerPluginrequire	"$R$T\T^r^tyt{�{����������������  