LJ @src/UIControllerPlugin.lua�   K�4   7> 74 7>4  77 >4  7	4
 	 
 >	 > 74	 '
  '  >	 = 74	 '
  '  >	 = 7%	 '
 > 7%	 '
 > 74	 '
  '  '  >	 =  T� 74	 >T� 74	 > 74	 > 74	 >H kKeyboardReturnTypeDonesetReturnType kEditBoxInputModeSingleLinesetInputModekEditBoxInputFlagSensitivekEditBoxInputFlagPasswordsetInputFlag	ccc3setFontColorsetFontdefaultsetPlaceholderFontsetAnchorPointccpsetPositionCCSizeMakecreateCCEditBoxinput_pngcreateWithSpriteFrameNameCCScale9Spritecommon2_plistResaddSpriteFramesWithFilesharedSpriteFrameCacheCCSpriteFrameCache					







self  Lwidth  Lheight  Lis_password  Lcache Gscale9_2 
=editbox2 	4 �   D  7  	 
 >:  77 '	  
 >7 H addChildcreateEditboxeditboxself  layer  width  height  is_password  tag   �  D�"4   7>  T�4 % >4  7>4  7>' '
 ' I�4
 7
	
%
 	 >
4 
 > 7
 >  T�4 % > 7 >K�4  7 (	  > 7	 %
 >4  7	 >	 74
 
 7

 >
 =G  CCRepeatForeverrunActionCCAnimateprogressaddAnimationcreateWithSpriteFramesCCAnimationaddObjectframe should not be nilspriteFrameByNameload%02d.pngformatstringcreateCCArraysharedAnimationCacheCCAnimationCacheframe cache is null
printsharedSpriteFrameCacheCCSpriteFrameCache��̙����				




	self  Elayer  Esprite  EframeCache @animationCache 	7frames 3  i image_file frame 	anim animate 
	 m   !=4  % >) H ,[UIControllerPlugin:msg_layer_on_touch]
printself  eventType  x  y   B   B:  G  msg_box_containerself  msg_box_container   �
  %��F+7    T�7 :  4  7> 74 7>7  7>4 %	 7
%	 7
>4  74 '	  '
  '  '  > = 7'	d > 7)	 > 74	 7
   >	)
 ' �) >4  7>	 74
   >
 =	 7
 '�'d >	 7)
 >	 74
 (  (  >
 =	 74
 7
7>
 =4 	 7%
 >4	  
	 7		 %! ' >		 7
"	4# '� '� '� > =
 7
	 '�>
	 7
	4 (  (  > =
	 7
	4 > =
 7
$4   > =
 7
 '  >
 7
4 '  (  > =
 7
4 '  > =
H setPreferredSize	ccc3setColordefaultCCLabelTTFcue_a.pngcreateWithSpriteFrameNameCCScale9SpritesetPositionccpsetAnchorPoint!ignoreAnchorPointForPositionaddChildCCSizeMakesetContentSizeCCLayeron_msg_layer_touched__bindregisterScriptTouchHandlersetTouchEnabledsetOpacity	ccc4createCCLayerColorheightwin_size.height:
widthwin_size.width: 
printgetContentSizedialog_plistResaddSpriteFramesWithFilesharedSpriteFrameCacheCCSpriteFrameCacherootNodemsg_box_container����



       !!!!!!!#######$$$$$%%%%%%%&&&&&&&*self  �message  �msg_width  �msg_height  �cache 
�win_size 	�msg_layer ycontent_layer cmsg_sprite &=msg_lb 6 �   's  7  % '  '  >7  7 '  '�>4  4 7>G  content_scale_factorGlobalSettingscaleNodeaddChildrootNodecreate_message_layerself  msg_layer  �   !z7   7'�>7   7 ) >)  G  removeChildgetChildByTagrootNodeself  msg_layer  �   !�+   7     7  '�> +  7  7  ) >)   G   �removeChildgetChildByTagmsg_box_containerself msg_layer 	 �
 	 V�  T�'J  T�'2   7     >7  7 '  '	�>4  4 7>4 7' 1 >0  �G   add_timer
Timercontent_scale_factorGlobalSettingscaleNodeaddChildmsg_box_containercreate_message_layerself   message   msg_width   msg_height   msg_layer  �  :��  T�'^  T�'I   7     > 7'd >4  7> 7	 '
�'�> 74	 '
  (  >	 = 74	 '
 >	 =7  7	 '
  '�>4	  4	
 7		>  7 	 
 >G  create_progress_animationcontent_scale_factorGlobalSettingscaleNodemsg_box_containersetPositionccpsetAnchorPointaddChildcreateCCSpritegetChildByTagcreate_message_layer����							self  ;message  ;msg_width  ;msg_height  ;msg_layer .content_layer *progress_sprite & �   .�	7    T�4 %   7 >4 % 7  >7   7'�>7   7 ) >* :  G  removeChildgetChildByTagself.msg_box_container => __cnameself.__cname => 
printmsg_box_container	self  msg_layer  �  "o�4  74 7>'
  T�% 7$  T�74 7>	  T�% T�%  T�%	  $ T �%
  % $H 	.pngtouxiang00_00fmgender0avatartonumbercurrent_userGlobalSettingself  #cur_user  avatar_png_index avatar_png_index_gender avatar_png  �  	 .�4 7 >:  7   7 >7   74 7   > =7  77  ''>7   7>G  	showreorderChild$do_back_message_box_btn_clicked__bindsetNoButtonsetMessagerootNodecreateBackMessageBoxLayerback_message_boxself  message   �   	 �4  % >7 7) >G  dismissrootNode9[MarketSceneUPlugin:do_back_message_box_btn_clicked]
printself  
tag  
sender  
 �  
 "1�4  % >7   T	�4  % >7  77>T�  7 7>7   T�7   T�  7 >4	 7   >: G  __bindafter_trigger_successdisplay_player_infoget_user_profilecontentshow_back_message_box<[MarketSceneUPlugin:matket_scene:show_back_message_box]matket_scene-[MarketSceneUPlugin:do_back_message_box]
print			




self  #data  # �  +�1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : G   do_on_buy_produce_message $do_back_message_box_btn_clicked show_back_message_box get_player_avatar_png_name hide_progress_message_box show_progress_message_box show_message_box unload_untouched_layer load_untouched_layer create_message_layer set_message_box_contener on_msg_layer_touched create_progress_animation addEditbox createEditbox6;8?=lAsnyu�{�������������theClass    s   	
 �4   % > 2   5  4  1 : G   	bindUIControllerPluginsrc.WebsocketRails.Timerrequire��  