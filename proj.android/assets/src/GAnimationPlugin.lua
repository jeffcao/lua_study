LJ @src/GAnimationPlugin.lua�   	 4     7  >   7 4 7>4 7>4 7>G  sharedButterFlyButterFlysharedExplosionExplosions_anim_plistResaddSpriteFramesWithFilesharedSpriteFrameCacheCCSpriteFrameCachecache  � 
#m4   7>4   >D	�+  	 7
 >
 7	 >	BN�4  7 (  >4  7> 7	  >G   �addAnimationsharedAnimationCacheCCAnimationCachecreateWithSpriteFramesCCAnimationaddObjectspriteFrameByName
pairscreateCCArray����cache frames  $name  $animFrames   _ 	_v  	frame animation 
 �   !4   7> 7  >4  7 @ createCCAnimateanimationByNamesharedAnimationCacheCCAnimationCachename  animation 	 � 
  54   7>   T�H 4   >D� 7	 >BN�H addObject
pairscreateCCArraytable  array   _ _v   ,    $4   7  @  newSpritedisplay K   / +     7   ) > G   �removeFromParentAndCleanup      self  �	 ,a(
+   7 % >  7  >  7 4 7>4  7> 7%	 >4
  7 >4  71 >4  7  >  7  >0  �G   �runActioncreateWithTwoActionsCCSequence CCCallFunccreateCCAnimatebaozhaanimationByNamesharedAnimationCacheCCAnimationCachecontent_scale_factorGlobalSettingsetScalesetDisplayFramebaoza_1.pngspriteFrameByName				

cache self  -pFrame 'animation anim cb seq  �  
'f4
4     7  > % ' ' ' I�%  % $+   7 >  7 	 >K�4  7  (  >4	  7
> 7 % >G   �baozhaaddAnimationsharedAnimationCacheCCAnimationCachecreateWithSpriteFramesCCAnimationaddObjectspriteFrameByName	.pngbaoza_createCCArray��̙����									
cache animFrames #str "  index frame 	animation 
 �   3@  T�')#4  7> 74 '�'� > =  7   >G  addChildccpsetPositionnewExplosiontarget  z_order  explosion  ,    G4   7  @  newSpritedisplay (    K4   7  @  newButterFly �  S�O4   7> 7% >  7  >  7 4 7>'�: '�:	 ' :
   7 >7 4 7 : 7 4 7 :   7 4 7 ''> =4  7> 7% >4  7 >4  7 >  7 	 >  7 
  7	 >	 =  7 4	 7
   >	'
 >G  __bind"scheduleUpdateWithPriorityLuarandomPositionrunActionCCRepeatForevercreateCCAnimateflyanimationByNamesharedAnimationCacheCCAnimationCacheccpsetPositionheighthalf_h
widthhalf_wgetContentSizeBACK_TIMEback_action_tagaction_tagcontent_scale_factorGlobalSettingsetScalesetDisplayFramehu die 001.pngspriteFrameByNamesharedSpriteFrameCacheCCSpriteFrameCache�


self  Tcache OpFrame KcontentSize 9flyAnimation flyAnimate fly  g  r+     7   4 + +  7 > = G   ��half_hccpsetPositionself b_x  � n�f  7  >  7 >  7 >7    T�7   T�7   T�7  T/�  7 7 >  7 > 	 TI�4 7' >4	  7
7 >4  7 4	 
	 7	
	1 >	 =4 % 7	 %
  % $> 77	 >  7 	 >0 �T$�	 T"�4 7'� >4 7'd >'��4 7'
 >'  T�' 4  7
'	 4
   >
 =	 77
 >	  7 
 >0  �G  ccpCCMoveByrunActionback_action_tagsetTag,0)
x,y:(!执行飞回动作，时间:
cclog CCCallFunccreateWithTwoActionsCCSequenceBACK_TIMEcreateCCDelayTimerandom	mathaction_tagstopActionByTaghalf_hhalf_wnumberOfRunningActionsgetPositionYgetPositionX ��				




self  ox ky hactions eb_x delay b_action 
x y xdirection action  U   
�4  4 7' >4 7'�> ? random	mathccpself   g    �4   7  3 % > G  fly  hu die 001.pnghu die 002.png
shareGAnimationPlugin -    �4   7  @  newSpritedisplay '    �4   7  @  newInsects � 	 /V�4   7> 7% >  7  >  7 4 7>'x : '�:	   7
 >7 4 7 :   7 4 7 ''> =  7 4 7   >' >G  
creep__bind"scheduleUpdateWithPriorityLuaccpsetPosition
widthhalf_wgetContentSizeaction_tagINSECT_DELAYcontent_scale_factorGlobalSettingsetScalesetDisplayFramechong zi01.pngspriteFrameByNamesharedSpriteFrameCacheCCSpriteFrameCache�			





self  0cache +pFrame 'contentSize  �  (�  7  >	  T�  7 >  7  >G  runActionrightScreenActionnumberOfRunningActions self  actions 
action  c  �+     7   4 +  7 ''> = G   �half_wccpsetPosition�self  � *��7   7    7 >  7 ' >  7 >4  77 >4  71	 >2 ;;;;;4	 
	 7		4	 7
 > =	0  �H	 tabletoarrayGAnimationPluginCCSequence CCCallFuncINSECT_DELAYcreateCCDelayTimeaddTurncreepByXhalf_w��	self  +d_x (o_x &creepToDx "turnRight creepToOx delay reset anims 
action  �  #_�4  7 >! !4 %  $>2  '  ' I	�4	 7		
   7  > =	K�4  74	 7
 > =H tabletoarrayGAnimationPlugincreateCCSequenceaddCreepinsert
tabletimes is
cclogabs	math
								
self  $x  $direction times creeps 
 
 
i seq  �  )l�%  	  T�% T�'��4 7 >4  7( >4  7( 4 	'
  > =4  7	 	 >4
  7		 
 >	 77
 >H action_tagsetTagCCSpawncreateWithTwoActionsCCSequenceccpCCMoveBycreateCCDelayTimegetAnimateGAnimationPlugincreep_rightcreep_left����
									





self  *direction  *name (animate 	delay move 	seq action  �  2�%  	  T�% 4 7 > 77 >H action_tagsetTaggetAnimateGAnimationPluginup_rightup_leftself  direction  name animate  �  E��%  4 7 >2 4  7' >;4  7'  4 '	 '
  > =;4  7(  >;4  7'  4 '	
 '
  > =;4  7' > < 4  74 7 > =4	  7
 	 >	 T� 7>  77	 >H action_tagsetTagreversecreateWithTwoActionsCCSpawntabletoarrayCCSequenceccpCCMoveBycreateCCDelayTimegetAnimateGAnimationPluginturn_right������������				self  Fdirection  Fname Danimate @anims 'seq action  �    ��3   4 7  % >3 4 7 % >3 4 7 % >3 4 7 %	 >3
 4 7 % >G  up_right  chong zi08.pngchong zi09.pngchong zi08.pngup_left  chong zi04.pngchong zi03.pngchong zi04.pngcreep_right  chong zi10.pngchong zi11.pngcreep_left  chong zi01.pngchong zi02.pngturn_right
shareGAnimationPlugin  chong zi04.pngchong zi03.pngchong zi06.pngchong zi07.pngchong zi08.png					turn_right_frames creep_left_frames creep_right_frames up_left_frames up_right_frames  �  2 T� �2   5   4    7  > 4  1 :4  1 :4  1 :4  1
 :	4 % 1 >5 4 1 :4 1 :4 1 :4 % 1 >5 1 5 4 1 :4 1 :4 1 :4 1 :4 % 1  >5 1! 5" 4 1# :4 1% :$4 1' :&4 1) :(4 1+ :*4 1- :,4 1/ :.4 11 :00  �G   sharedInsects addTurn 
addUp addCreep creepByX rightScreenAction 
creep createInsects  Insects sharedButterFly randomPosition fly createButterFly  ButterFly explode sharedExplosion 	ctor Explosion
class tabletoarray getAnimate 
share sharedAnimationsharedSpriteFrameCacheCCSpriteFrameCacheGAnimationPlugin       
         "  $ $ & $ & ( 2 ( 4 > 4 @ E @ G G I G I M K O d O f � f � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � cache N  