LJ @src/PlayerProductsUIPlugin.lua¡  	 *
4  % >7   T7  77 ) >7:   7 >: 7   T7  77 >G  setContentcreate_product_list	catsproduct_listremoveChildrootNodeproduct_view,[PlayerProductsScene:show_product_list]
print
self  data   ù   4  % >  7 % >4 7   >:   7 >G  cate_listshow_product_list__bindafter_trigger_successè·åéå·åè¡¨...show_progress_message_box,[PlayerProductsScene:init_product_list]
printself    	  0P4  % >4 77> T#7  ' 'ÿÿI4  % 7 67$>4  %	 77$>7 6777 T7 6) :
Kç7 77>T  7 >G  init_product_listuse_prop_callbackusing_me8[PlayerProductsScene:after_use_product] prod_id_d=>prop_id8[PlayerProductsScene:after_use_product] prod_id_s=>product_list0prop_count	proptostring,[PlayerProductsScene:after_use_product]
print




self  1data  1  index  Ä  
 8,4  % >:   7 % >  7 7>4 7	   >: G  after_use_product__bindafter_trigger_successprop_iduse_cate åééå·ä½¿ç¨è¯·æ±...show_progress_message_boxuse_prop_callback0[PlayerProductsScene:do_on_trigger_success]
printself  product  use_prop_callback   Ð   -54  % >  7 >4  % 4 7 >$>4 7 > T7 )  :   >G  functionafter_trigger_success	typeI[PlayerProductsScene:do_on_trigger_success] after_trigger_success=> hide_progress_message_box0[PlayerProductsScene:do_on_trigger_success]
printself  data  fn  É  
 +B4  % >  7 >4 7>  T7:   7 7 >4 7 >	 T7  >)  : G  functionafter_trigger_failure	typeshow_message_boxfailure_msgresult_messageis_blankhide_progress_message_box/[MarketSceneUPlugin:do_on_trigger_failure]
print		self  data   Ô  L1 :  1 : 1 : 1 : 1	 : 1 :
 0  G   do_on_trigger_failure do_on_trigger_success show_use_notify after_use_product init_product_list show_product_list'/)=2J?LLtheClass   K    P2   5   4   1 : 0  G   	bindPlayerProductsUIPluginOOO  