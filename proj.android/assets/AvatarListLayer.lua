LJ @AvatarListLayer.lua@    4   7  % @  AvatarListLayernewLayerdisplay E   	4  7  @ newAvatarListLayeravatar_callback   �   "N4  : 4 7   >: 4  7>4 %  ) %	 >4 7 % >:
   7  >: 4 7
 4 7>G  content_scale_factorGlobalSettingscaleNodeavatar_callbackaddChildCCLayer	cast
toluarootNodeAvatarList.ccbiCCBReaderLoadcreateCCBProxydo_ui_avatar_btn_clicked__bindon_ui_avatar_btn_clickedavatar_list_sceneccb				
self  #avatar_callback  #ccbproxy node  �  
94  % >  7 % >3 4 77: :  7	  >G  complete_user_infoavataruser_idcurrent_userGlobalSetting version1.0
retry0更新头像..show_progress_message_box/[AvatarListLayer:do_ui_avatar_btn_clicked]
print�self  tag  sender  changed_info  �   $4  % >  7 >4 7 > T�7  >G  functionavatar_callback	typehide_progress_message_box,[AvatarListLayer:do_on_trigger_success]
printself  data   �   ".4  % >  7 >  7 7 >4 7 > T�7  >G  functionafter_trigger_failure	typefailure_msgshow_message_boxhide_progress_message_box,[AvatarListLayer:do_on_trigger_failure]
printself  data   �   #$ :4   % > 4   % > 4  % 1 > 5  1  5  4  1	 : 4  1 :
 4  1 : 4  1 : 4  7  4 > 4  7  4 > 0  �G  UIControllerPlugin	bindHallServerConnectionPlugin do_on_trigger_failure do_on_trigger_success do_ui_avatar_btn_clicked 	ctorcreateAvatarListLayer  AvatarListLayer
classsrc.UIControllerPlugin#src.HallServerConnectionPluginrequire	"$,$.5.7777888888  