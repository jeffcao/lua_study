LJ @src/ConnectivityPlugin.luag   	4  7'  4 7   > =G  do_network_check__bindadd_timer
Timerself  
 �   Cn4   7> 7% >4 %  4 7 > =4 7 ' ' > 	 T�4
 % >7   T
�7  7>  T�7  7>G  7   T
�7  7>  T�4
 % >G  % 7   T�% 4  >  7 >G  show_network_disconnected&nework_check root node is not nilrootNode"nework_check root node is nilis already dialog showingdismissisShowing network_disconnected_dialog&resume_check network is connected
cclogtsublenstringnetwork_state=> 
printIsNetworkConnectedgetcreateDDZJniHelper
self  Djni_helper ?network_state ;str 0 X   )+     7   % > G  �on_set_network_intentmessageJavajni_helper  #    ,4   > G  endtolua     8 G   key   �  I�"4   7>% 7   T�% 4  >4 7 > 7% > 7	1
 > 71 >4  7> 7% > 7% > 7%	 >	 7%
 >
 7	 >	
 7	 >	
 7	 >	
 7	 >	
 7	1 >	
 7	>	: 0  �G   network_disconnected_dialog	show setOnKeypadsetNoButtonFrameSelectedsetYesButtonFrameSelectedsetNoButtonFrameNormalsetYesButtonFrameNormaltishikuang07_down.pngtishikuang06_down.pngtishikuang07.pngtishikuang06.pngspriteFrameByNamesharedSpriteFrameCacheCCSpriteFrameCache setNoButton setYesButton/网络连接已断开，请设置网络！setMessagecreateYesNoDialog
printroot node is not nilrootNoderoot node is nilcreateDDZJniHelper	


self  Jjni_helper Estr Ddialog 
:cache *yes_normal &no_normal "yes_sel no_sel  9   >+     7   > G   �network_checkself  �  !=1  4 7 % >4 7 % >4 7 % >0  �G  on_network_change_disable on_network_change_availableon_resumeregisterScriptObserverNotificationProxy self  nwck  �  	A1 :  1 : 1 : 1 : G   init_connectivity show_network_disconnected do_network_check network_check5?7AtheClass  
 B    G2   5   4   1 : G   	bindConnectivityPluginGG  