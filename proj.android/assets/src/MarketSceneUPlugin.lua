LJ @src/MarketSceneUPlugin.lua� J})     T�4 ' '� > T@�  T7�  T �4  7> 4 >5 4 %  $>4  7	+   64
 +	 7		+
 > = 74 '  '	 >T�4 7 7' >% > 7	+  	 6	4	
 +
 7

+ >	 = T�  T�+   T�  T �H � �cellTouchednumberOfCellsCCLayergetChildByTag	cast
toluaaddChildshow_buy_notify__bindinit_item3[MarketSceneUPlugin.create_product_list] a1 =>
printa3createMarketItemcreateCCTableViewCellcellAtIndexCCSizeMakecellSize												






product_list self fn  Ktable  Ka1  Ka2  Kr Ia3 4 � 	$T#  T�0  �4   71 >4  7 4 ' 'r> = 74 '  '# > = ' '��I�	 7
 >K�0  �H G  updateCellAtIndexCCPointMakesetPositionCCSizeMakecreateWithHandlerLuaTableView createLuaEventHandler""#self  %product_list  %h 	t 	
  index  �  	 ,q0  7  7>2  4 7>D�76  T�72	  9	4 77	6		
 >BN�% 4  >D� T	� 
  7	   >	BN�  7  >G  setTabcreateTabinsert
table	kind
pairscommoditytest_process_props
self  -data  -kinds '  k v  first_key   k v   H   Q +     7   + 7> G   ��	namesetTab       self menu  � K�B7   7>4  74  7 %	 $	> = 74  7	 %
 $	
	> = 7' >4	  7
 > 7) > 7 >:::7  T�2  :'  4 7>D
� B
N
� 74	 


'>	 = 71	 >7790  �G   registerScriptTapHandlerccpsetPosition
pairs	tabs	data	nametoggleaddChild!ignoreAnchorPointForPositioncreateWithItemCCMenusetSelectedIndex下addSubItem上CCMenuItemFontcreateCCMenuItemTogglegetRightMenurootNode��	
self  Lkind  Ldata  Lright_menu Gtoggle <menu )len   k v   �  R�U7   7>7 T�G  4 7>DB�	 7>
 7	>	 T
�7
 
 T

�  7
 7	>
:
7
  
 7


7>
7

 7

) >
 7
) >
 7
4 	  > =
T
�7
7
 T
� 7
4 	  > =
7

 7

'  >
7
 
 T�7

 7

) >
 7
) >
BN�:G  setSelectedIndextoggle	nameccpsetPositionsetEnabledsetVisiblesetContent	datacreate_product_listattach_viewgetPositionXgetPositionY	tabs
pairs	lastgetRightMenurootNode				







self  Sname  Sright NE E Ek Bv  By ?x < �   k4  % >  7 % >  7 >4 7   >: G  show_product_list__bindafter_trigger_successshop_prop_list获取商品列表show_progress_message_box/[MarketSceneUPlugin:do_on_trigger_success]
printself   � 
 
 3Zt4   >D)�7  T
�4 77%	 >  T�% :T�7  T
�4 77%	 >  T�% :T�7  T
�4 77%	 >  T�% :T�% :BN�4	  >G  	dump其他宝箱礼包	kind卡	findstring	name
pairsself  4source_data  4, , ,k )v  ) �  9�~4  % >4  7> 7% >4  %  $>) 4 4 7	>  T!�4  >  T�4  %
 4 7	$>4 4 7	% >4  >D�4	 7		
  >	
	  T
�		  T
�) T�BN�H 	findstring
pairs,
splitL[MarketSceneUPlugin:is_cm_sim_card] GlobalSetting.cm_sim_card_prefix=> cm_sim_card_prefixGlobalSettingis_blank1[MarketSceneUPlugin:show_buy_notify] imsi=> hw_imsigetStringForKeysharedUserDefaultCCUserDefault([MarketSceneUPlugin:is_cm_sim_card]
print					



self  :imsi .is_cm_sim_card (cm_sim_card_flags   k v  f_index  �   Ug�4  % >4 7>  T�  7 % >G    7 >5 4  % 4 4 >$>4   T �:	 4 >:
 % 5 4 7	 7% $5 4 7	 7% 7	 7% $5 4  % 4 $>7
  74 >7
  74 7   > =7
  74 7   > =7  77
 ''>7
  7>G  	showaddChildrootNodedo_cancel_buysetNoButtondo_buy_product__bindsetYesButtonsetMessage;[MarketSceneUPlugin:show_buy_notify] notify content=> B元人民币）
点击确认按钮确认购买，中国移动rmb 点（即消费
priceC
道具数量：1
服务提供商：新中南
资费说明：
	namecontentU尊敬的客户，您即将购买的是
游戏名：我爱斗地主
道具名：createYesNoDialog3yes_no_dialogcur_producttostring;[MarketSceneUPlugin:show_buy_notify] is_cm_sim_card=> is_cm_sim_card3此道具无消息代码，无法完成购买.show_back_message_boxconsume_codeis_blank)[MarketSceneUPlugin:show_buy_notify]
print							


self  Vproduct  V �   '�4  % >7  7) >7  77 ) >)  :   7 % >  7 7	 7
>4 7   >: G  do_on_buy_message__bindafter_trigger_successidcur_productbuy_prop购买道具show_progress_message_boxremoveChildrootNodedismissyes_no_dialog([MarketSceneUPlugin:do_buy_product]
printself    �   /D�4  % >: 4 7> T"�4 >: 7  77	>7  7
4 7   > =7  74 7   > =7  77 >7  7>T�  7 >G  	showaddChildrootNodedo_cancel_buysetNoButtondo_confirm_buy__bindsetYesButtoncontentsetMessagecreateYesNoDialog3yes_no_dialog1result_codetostringcur_buy_data+[MarketSceneUPlugin:do_on_buy_message]
print




self  0notify_msg  0 �   .I�4  % >7   T�7  7) >7  77 ) >)  :   7 % >% 7	 7
% 7	 7$4  7> 7 >  7 7	 77	 7>G  prop_idtrade_numtiming_buy_propmessageJavacreateDDZJniHelpersend_num__sms_contentcur_buy_datasend_sms_ 正在发送付款请求...show_progress_message_boxremoveChildrootNodedismissyes_no_dialog([MarketSceneUPlugin:do_confirm_buy]
printself  /msg jni_helper  �   �4  % >7  7) >7  77 ) >)  : G  removeChildrootNodedismissyes_no_dialog'[MarketSceneUPlugin:do_cancel_buy]
printself   �   -�4  % >  7 >4  % 4 7 >$>4 7 > T�7 )  :   >G  functionafter_trigger_success	typeH[MarketSceneUPlugin:do_on_trigger_success] after_trigger_success=> hide_progress_message_box/[MarketSceneUPlugin:do_on_trigger_success]
printself  data  fn  �  
 1�4  % >  7 >4 7>  T�7:   7 7 >4 7 >	 T�7 )  :   >G  functionafter_trigger_failure	typeshow_message_boxfailure_msgresult_messageis_blankhide_progress_message_box/[MarketSceneUPlugin:do_on_trigger_failure]
print		self  data  fn  �  *	�1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 0  �G   do_on_trigger_failure do_on_trigger_success do_cancel_buy do_confirm_buy do_on_buy_message do_buy_product show_buy_notify is_cm_sim_card test_process_props init_product_list setTab createTab show_product_list create_product_list%7'J9_Libsk�u����������������theClass   �   . �4   % > 4   % > 4   % > 4   % > 2  5 4 1 :0  �G   	bindMarketSceneUPlugin
cjsonBackMessageBoxLayerYesNoDialog3MarketItemrequire              	  	   json   