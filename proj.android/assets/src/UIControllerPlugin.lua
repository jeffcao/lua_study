LJ @src/UIControllerPlugin.luaÞ  " o´4   7> 74 7> 74 7>)  7   T4  77	 > T	4
 % >4  77	 > 4  74 	 
 >	 > 74	 '
  '  >	 = 74	 '
  '  >	 = 7%	 '
 > 7%	 '
 > 74	 '
ÿ 'ÿ 'ÿ >	 = 74	 '
ÿ 'ÿ 'ÿ >	 =  T 74	 >T 74	 > 74	 > 74	 > 7%	  > 7%	! >H  setTextkKeyboardReturnTypeDonesetReturnType kEditBoxInputModeSingleLinesetInputModekEditBoxInputFlagSensitivekEditBoxInputFlagPasswordsetInputFlagsetFontColor	ccc3setPlaceholderFontColorsetFontdefaultsetPlaceholderFontsetAnchorPointccpsetPositionCCSizeMakeCCEditBoxcreate!load 9sprite from direct dir
ccloginput_pngcreateWithSpriteFrameNameCCScale9Spritedirectcommon3_plistcommon2_plistResaddSpriteFramesWithFilesharedSpriteFrameCacheCCSpriteFrameCache			





self  pwidth  pheight  pis_password  pcache kscale9_2 `editbox2 D ©   D'  7  	 
 >:  77 '	  
 >7 H addChildcreateEditboxeditboxself  layer  width  height  is_password  tag     D·-4   7>  T4 % >4  7>4  7>' '
 ' I4
 7
	
%
 	 >
4 
 > 7
 >  T4 % > 7 >Kê4  7 (	  > 7	 %
 >4  7	 >	 74
 
 7

 >
 =G  CCRepeatForeverrunActionCCAnimateprogressaddAnimationcreateWithSpriteFramesCCAnimationaddObjectframe should not be nilspriteFrameByNameload%02d.pngformatstringcreateCCArraysharedAnimationCacheCCAnimationCacheframe cache is null
printsharedSpriteFrameCacheCCSpriteFrameCacheµæÌ³¦ý				




	self  Elayer  Esprite  EframeCache @animationCache 	7frames 3  i image_file frame 	anim animate 
	 Ç   5H7    T7   7>4 %  > H ,[UIControllerPlugin:msg_layer_on_touch]
printisShowing network_disconnected_dialogself  eventType  x  y  is_dialog  B   N:  G  msg_box_containerself  msg_box_container   è  2ÙôR@  T2  7 774  7> 7>7   T  T7: 7   T7 : 4  7	>	 7
4
 7

>	 7
4
 7

>7 	 7>4	 %
 7% 7>	4	 
	 7		4 '  '  '  '  > =		 7
	'd >
	 7
	) >
	 7
	4 7   >) ' ü) >
4
 
 7

>
4 %  %  $>
 7 
4!   > =	 7"	
 'ç'd >
 7#
) >
 7$
4% (  (  > =
 7&
4% 77> =4'  7(%) >* T4'  7(%+ > 4,  7 %- ' > 7.4/ 'C ' ' > =* T	 7.4/ 'ÿ 'ÿ 'ÿ > =T
0 T 7.4/ 'ÿ '  '  > =
 7"
 'ç'> 7$4% (  (  > = 7&4% > = 714!   > =
 7"
 '  > 7$4% '  (  > = 7&4% '  > =H	 setPreferredSizewarning	ccc3setColordefaultCCLabelTTFcue_a.pngprogresstanchukuang.pngcreateWithSpriteFrameNameCCScale9SpritesetPositionccpsetAnchorPoint!ignoreAnchorPointForPositionaddChildCCSizeMakesetContentSize, msg_height: msg_width: 
cclogCCLayeron_msg_layer_touched__bindregisterScriptTouchHandlersetTouchEnabledsetOpacity	ccc4createCCLayerColorheightwin_size.height:
widthwin_size.width: 
printgetContentSizecommon3_plistdialog_plistResaddSpriteFramesWithFilesharedSpriteFrameCacheCCSpriteFrameCacherootNodemsg_box_containergetRunningScenesharedDirectorCCDirector	typemsg_heightmsg_widthÿ




       !!!!!!!######$$$$%%%%%%%&&&&&&&&&((((())******,,,,,,,........//000000000112222222244444455555556666666888888899999:::::::;;;;;;;?self  Úmessage  Úparams  Úmsg_width Õmsg_height Ôtype Órunning_scene Ìcache ¼win_size ®msg_layer content_layer msg_sprite -[msg_lb L ê   &  7  % 3 >7  7 '  '>4  4 7>G  content_scale_factorGlobalSettingscaleNodeaddChildrootNode msg_width msg_height create_message_layerself  msg_layer     !7   7'>7   7 ) >)  G  removeChildgetChildByTagrootNodeself  msg_layer  v   &¡  T2  % :   7   >G  show_message_boxok	typeself  message  params      !µ+   7     7  '> +  7  7  ) >)   G   removeChildgetChildByTagmsg_box_containerself msg_layer 	 ß >§4  %  $>4 7 > 4  %  $>  T2  7  T 7  T'F 7  T'è7  T%	 	  7
 
 2 :::>7	 
	 7		  '>	4	 
 4 7>	4	 7		'
 1 >	0  G   add_timer
Timercontent_scale_factorGlobalSettingscaleNodeaddChildmsg_box_containercreate_message_layerwarning	typez_ordermsg_heightmsg_widthset w to lenstringshow_message_box 
cclog
								






self  ?message  ?params  ?w 3msg_width 'msg_height #z_order type msg_layer  Õ  lÏ¿4  % 7 $>4 7 '   T  7 >  T'^  T'I   T'è  7  3 ::	> 7
'd >4  7>	 7
 'ç'è>	 74
 '  (  >
 =	 74
 ' >
 =4 7
 7	
'>	%
 >5 4 	 74
 >
 =4  %	 
 >7 	 7
  '>4  %	 7
 >4 74	 7		
 >4 	 4
 7

>	  7 
  >G  create_progress_animationcontent_scale_factorscaleNodeinsert
table4show_progress_message_box, msg_box_container=> msg_box_container,show_progress_message_box, msg_layer=> msg_lbCCLabelTTF	cast
toluasetPositionccpsetAnchorPointaddChildcreateCCSpritegetChildByTagmsg_heightmsg_width 	typeprogresscreate_message_layerhide_progress_message_boxhall_cur_message_boxGlobalSetting__cname-show_progress_message_box, class name=> 
printÿ(							



self  mmessage  mmsg_width  mmsg_height  mz_order  mmsg_layer Ncontent_layer Jprogress_sprite F (    ï+   +  > G   cb_fn  <Zå+ 7  7'>,  +    T4 % +  >+ 7  7+  ) >4 74 7' >+  , + 7  7'>,     T+    T	+ '
  T4	 7
( 1 >+    T/   + )  : 0  G    add_timer
Timerhall_cur_message_boxGlobalSettingremove
tableremoveChild-hide_progress_message_box, msg_layer => 
printgetChildByTagmsg_box_containerÍ³ææÌÿ									



msg_layer self count cb_fn  = ¿  BÞ4  % 7 $>7   T4  % 7 >7  7'>' 1   >0 0  G   getChildByTag:hide_progress_message_box, self.msg_box_container => msg_box_container__cname-hide_progress_message_box, class name=> 
printself  msg_layer count remove_box    /|þ4  74 7>'
  T% 7$  T74 7>	  T% T4 7>	 T% 4 7>	 T% T%	 
 T%  $ T %  % $H 	.pngtouxiang00_00fmgender	00_f	00_m0avatartonumbercurrent_userGlobalSettingÊÌ							



self  0cur_user -avatar_png_index !avatar_png_index_gender avatar_png  ­  	 .4 7 >:  7   7 >7   74 7   > =7  77  ''>7   7>G  	showreorderChild$do_back_message_box_btn_clicked__bindsetNoButtonsetMessagerootNodecreateBackMessageBoxLayerback_message_boxself  message      	 4  % >7 7) >G  dismissrootNode9[MarketSceneUPlugin:do_back_message_box_btn_clicked]
printself  
tag  
sender  
   
 "14  % >7   T	4  % >7  77>T  7 7>7   T7   T  7 >4	 7   >: G  __bindafter_trigger_successdisplay_player_infoget_user_profilecontentshow_back_message_box<[MarketSceneUPlugin:matket_scene:show_back_message_box]matket_scene-[MarketSceneUPlugin:do_back_message_box]
print			




self  #data  #    $¼+   7     7  '>    T+  7  7  ) >)   G  removeChildgetChildByTagrootNodescene msg_layer  Ã  $\Ä   T 4   >+  7 7>+  7 7> 7 > +  7 7> 7 >  T+ >) H 	
containsPointconvertToNodeSpacegetParentboundingBoxmsg_lbccp
ended											

msg_layer remove_layer eventType  %x  %y  %mloc bd  ´ GÈª/4   7> 7>  T7  T4 % >0 64 7 > 2  5  'F '%	 T4
 
 7	 2 :::>	4
 	 4 7>
1
 1 	 7	) >	 7	 ) ' ü) >7 7	  '>4 7' 
 >0  G  G  add_timer
TimeraddChildregisterScriptTouchHandlersetTouchEnabled  content_scale_factorGlobalSettingscaleNodemsg_heightmsg_width	type create_notify_message_layerwarningokparamslenstringFshow_server_notify the running scene is null or has not root node
cclogrootNodegetRunningScenesharedDirectorCCDirector
	
())))*******,,,,,,,.....///self  Hmessage  Htype  Hscene @w 1msg_width .msg_height -z_order ,type )msg_layer !remove_layer on_msg_layer_touched    &§Û'  T2  7 774  7> 74	 7		> 74	 7		>7	  7
>4 %	 7
% 7>4 	 74
 '  '  '  '  >
 =
 7	'd >	4	 
	 7		>		 7
	4   > =
 7
	 'ç'd >
	 7
	) >
	 7
	4 (  (  > =
	 7
	4 77> =
4
 
 7

% >
4  7 %  ' > 7!4" 'C ' ' > =# T 7!4" 'ÿ '  '  > =	 7	 'ç'> 74 (  (  > = 74 > =
 7$
4   > =	 7	
 '  >
 7
4 '  (  > =
 7
4 '  > =:%H msg_lbsetPreferredSizewarning	ccc3setColordefaultCCLabelTTFtanchukuang.pngcreateWithSpriteFrameNameCCScale9SpritesetPositionccpsetAnchorPoint!ignoreAnchorPointForPositionaddChildCCSizeMakesetContentSizeCCLayersetOpacity	ccc4createCCLayerColorheightwin_size.height:
widthwin_size.width: 
printgetContentSizerootNodecommon3_plistdialog_plistResaddSpriteFramesWithFilesharedSpriteFrameCacheCCSpriteFrameCache	typemsg_heightmsg_widthÿ



!!!!!!!"""""#######$$$$$$$%&self   message   params   msg_width msg_height type cache win_size msg_layer wcontent_layer omsg_sprite &Imsg_lb B    2S4  %  $>4 4 7% >4 76  T7  T4  %  $>G  4  7	> 7
>  T7  T4  % >G  4  77>4 7)  9G  showIntroduceBcheck_tech_msg the running scene is null or has not root noderootNodegetRunningScenesharedDirectorCCDirectordo not introduce moment contentGlobalSetting.teach_msg=>teach_msgGlobalSetting	dumpcheck_tech_msg 
cclog					


self  3moment  3teach %scene  ¿ & (\1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1! :  1# :" 1% :$ 0  G   check_tech_msg  create_notify_message_layer show_server_notify do_on_buy_produce_message $do_back_message_box_btn_clicked show_back_message_box get_player_avatar_png_name hide_progress_message_box show_progress_message_box show_message_box show_message_box_suc unload_untouched_layer load_untouched_layer create_message_layer set_message_box_contener on_msg_layer_touched create_progress_animation addEditbox createEditbox   & " A ( G C K I  M        ¶ ¢ × º ÷ Ù ù #T%}VtheClass  )    
 4   % > 2   5  4  1 : 0  G   	bindUIControllerPluginsrc.WebsocketRails.Timerrequire         