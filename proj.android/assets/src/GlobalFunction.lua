LJ @src/GlobalFunction.luaö  
)j4  7  % > 7>'è T 7 > 7>'   T 7>'   7> ' I		 7
 >4		 
  >	K÷G  scaleNodeobjectAtIndex
countgetChildrengetChildrenCountsetScalegetTagCCNode	cast
tolua				



node  *scaleFactor  *node $children 
 
 
index child      4   > 4  7> 7  >G  pushScenesharedDirectorCCDirectorcreateGuifanEndScenescene 	 V    	4     7  >   7  > G  endToLuasharedDirectorCCDirector    82  4    >D
 	 >  T	4 7	 
 >BNôH insert
table
pairssrc  fn  result   _ 
v  
 | 
  /'4   >D4 7  	 >BNùG  insert
table
pairsdest  src    _ value   K   -2  4  7   >H 
merge
tablearray  result  Á   ?34   > % 4   >D T 4	  
 >	$	T 	 4
   >
$
BNðH 
pairstostring
table  s  str   _ _v    
  2@%  4   >D 4 	 >%	 $	BNø % $H ],  tostring
pairs[ table  str 	 	 	_ _v    	  1I2     'ÿÿ' I4  7  6 >KùH insert
tablearray  result   index   
  ;Q	) 4    >D 	 >  T	) TBN÷H 
pairsarray  func  result 
 
 
_ obj   f   
0` +    >+  T) T) H           getObjectValueFuc elementValue obj     ~\2  4    >D 6	 >1	 4
 7

 	 >
 
 T4 7 6 >0 BNí0  H insert	some
table 
pairs

array  getObjectValueFuc  newArray   elementIndex _  elementValue search exist  m  i
   T4  74  7  > =   T) T) H 	trimlenstring str   t   m  7  % >   T% T  7  %  >H 	.*%S^%s*()
matchs  from  ¾  ._r2  %   $'   7  ' >  TQ	  T T4 7	 
 > 	  7 
  >
 	  Tê   T
	  7 
 > 4 7	 
 >H subinsert
table	find	(.-)	








str  /pat  /t -fpat *last_end )s $e  $cap  $ á  I  4  7   >	  T  7 ' > 4  7  'ÿÿ>   T 7'   > H sub	findstring							str   char   return_value char_index  X   	4  7% 4   >$>G  tonumbersleep executeosn  
 ¨     T) H 4    > T) H 4   >4 (  'ÿÿ#> T) H ) H tostringnumber	typeÿ					

x      
´  7  % >  T) H ) H :[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?
matchemail   ¤   ! [x»4     7  > 2 (  7 % >:  7 % >:  7 % >:  7 %	 >:
  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 % >:  7 %  >: H pkg_buildpkg_version_codepkg_version_name
appidid
hw_iddisplayhw_displayproducthw_productdevicehw_device
boardhw_boardcpu_abihw_cpu_abimanufacturehw_manufactureversionhw_version
modelhw_model
brandhw_brand	imsihw_imsimachw_mac	imeihw_imeigetStringForKeysharedUserDefaultCCUserDefault					




userDefault Wdevice_info V ò  [%     T4 +  >D  T+ 6TBNù4 %  % $> % $H  	.pnglevel pic is 
cclog
pairsduangong





levels_hanzi levels_pinyin level_hanzi  level   k v   µ  
 $[4   7> 7% >  T4 %  $>4  > 7 > T4 % >  7  >  7	 ) >G  setVisiblesetDisplayFrame)set_level_sprite game_level is=> nilget_level_pic&set_level_sprite game_level is=> 
cclogduangong.pngspriteFrameByNamesharedSpriteFrameCacheCCSpriteFrameCache



sprite  %game_level  %cache  level_frame picname 
  F¨4  +  >D4 %  %	 
 $
>BN÷+  4   > 64 % 4   >%  $>H 	 is tostringweekday for tonumber:kv wkd[
cclog
pairswkd wk_int  
 
 
k v  weekday 
 Ã  0 8 °1   5  1  5  1  5  4  1 : 4  1
 :	 1  5  4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 1  5  1  5  1  5  1  5  1  5   1 ! 5 " 1 # 5 $ 1 % 5 & 3 ' 3( 1) 5* 1+ 5, 3- 1. 5/ 0  G  get_weekday   æææ¥ææä¸ææäºææä¸ææåææäºææå­set_level_sprite get_level_pic   duangongchanggongtianhupinnong	yufulierenzhongnongfunongzhangguishangren	yayixiaocaizhudachaizhuxiaodizhudadizhuzhixiantongpan
zhifuzhongdu
xunfuchengxianghoujueqinwangmingjunrenzhu  ç­å·¥é¿å·¥ä½æ·è´«åæ¸å¤«çäººä¸­åå¯åææåäººè¡å½¹å°è´¢ä¸»å¤§è´¢ä¸»å°å°ä¸»å¤§å°ä¸»ç¥å¿éå¤ç¥åºæ»ç£å·¡æä¸ç¸ä¾¯çµäº²çæåä»ä¸»device_info check_email 
isnan 
sleep 	trim 
split trim_blank is_blank  unique 	some reverse toString 	joinclone_table  combine filter
tableendtolua endtolua_guifan scaleNode        %  ' + ' 1 - 3 > 3 @ G @ I O I Q Z Q \ g \ k i p m  r     ²  ¹ ´ Ò » Ô ï %'/(//levels_hanzi /
levels_pinyin 	wkd   