LJ @src/MarketSceneUPlugin.lua� J})     T�4 ' 'P > T@�  T7�  T �4  7> 4 >5 4 %  $>4  7	+   64
 +	 7		+
 > = 74 '  '	 >T�4 7 7' >% > 7	+  	 6	4	
 +
 7

+ >	 = T�  T�+   T�  T �H � �cellTouchednumberOfCellsCCLayergetChildByTag	cast
toluaaddChildshow_buy_notify__bindinit_item3[MarketSceneUPlugin.create_product_list] a1 =>
printa3createMarketItemcreateCCTableViewCellcellAtIndexCCSizeMakecellSize												






product_list self fn  Ktable  Ka1  Ka2  Kr Ia3 4 � 	$T#  T�0  �4   71 >4  7 4 ' ',> = 74 '  'F > = ' '��I�	 7
 >K�0  �H G  updateCellAtIndexCCPointMakesetPositionCCSizeMakecreateWithHandlerLuaTableView createLuaEventHandler""#self  $product_list  $h 	t 	
  index  �   
(0  7  7>7  7 >G  setContentrootNodecommoditycreate_product_listself  data  product_view  �   64  % >  7 % >  7 >4 7   >: G  show_product_list__bindafter_trigger_successshop_prop_list获取商品列表show_progress_message_box/[MarketSceneUPlugin:do_on_trigger_success]
printself   �  9�?4  % >4  7> 7% >4  %  $>) 4 4 7	>  T!�4  >  T�4  %
 4 7	$>4 4 7	% >4  >D�4	 7		
  >	
	  T
�		  T
�) T�BN�H 	findstring
pairs,
splitL[MarketSceneUPlugin:is_cm_sim_card] GlobalSetting.cm_sim_card_prefix=> cm_sim_card_prefixGlobalSettingis_blank1[MarketSceneUPlugin:show_buy_notify] imsi=> hw_imsigetStringForKeysharedUserDefaultCCUserDefault([MarketSceneUPlugin:is_cm_sim_card]
print					



self  :imsi .is_cm_sim_card (cm_sim_card_flags   k v  f_index  �   UgR4  % >4 7>  T�  7 % >G    7 >5 4  % 4 4 >$>4   T �:	 4 >:
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


self  Vproduct  V �   'q4  % >7  7) >7  77 ) >)  :   7 % >  7 7	 7
>4 7   >: G  do_on_buy_message__bindafter_trigger_successidcur_productbuy_prop购买道具show_progress_message_boxremoveChildrootNodedismissyes_no_dialog([MarketSceneUPlugin:do_buy_product]
printself    �   /D{4  % >: 4 7> T"�4 >: 7  77	>7  7
4 7   > =7  74 7   > =7  77 >7  7>T�  7 >G  	showaddChildrootNodedo_cancel_buysetNoButtondo_confirm_buy__bindsetYesButtoncontentsetMessagecreateYesNoDialog3yes_no_dialog1result_codetostringcur_buy_data+[MarketSceneUPlugin:do_on_buy_message]
print




self  0notify_msg  0 �   6Q�4  % >7   T�7  7) >7  77 ) >)  :   7 % >4 7	' 4
 7   > =% 7 7% 7 7$4  7> 7 >  7 7 77 7>G  prop_idtrade_numtiming_buy_propmessageJavacreateDDZJniHelpersend_num__sms_contentcur_buy_datasend_sms_hide_progress_message_box__bindadd_timer
Timer 正在发送付款请求...show_progress_message_boxremoveChildrootNodedismissyes_no_dialog([MarketSceneUPlugin:do_confirm_buy]
printself  7msg 'jni_helper  �   �4  % >7  7) >7  77 ) >)  : G  removeChildrootNodedismissyes_no_dialog'[MarketSceneUPlugin:do_cancel_buy]
printself   �   -�4  % >  7 >4  % 4 7 >$>4 7 > T�7 )  :   >G  functionafter_trigger_success	typeH[MarketSceneUPlugin:do_on_trigger_success] after_trigger_success=> hide_progress_message_box/[MarketSceneUPlugin:do_on_trigger_success]
printself  data  fn  �   *�
4  % >  7 >  7 7 >4 7 > T�7 )  :   >G  functionafter_trigger_failure	typefailure_msgshow_message_boxhide_progress_message_box/[MarketSceneUPlugin:do_on_trigger_failure]
print
self  data  fn  �  #	�1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : G   do_on_trigger_failure do_on_trigger_success do_cancel_buy do_confirm_buy do_on_buy_message do_buy_product show_buy_notify is_cm_sim_card init_product_list show_product_list create_product_list%*'4-G6fIph�r���������theClass   �    �4   % > 4   % > 4   % > 4   % > 2  5 4 1 :G   	bindMarketSceneUPlugin
cjsonBackMessageBoxLayerYesNoDialog3MarketItemrequire	�	�json   