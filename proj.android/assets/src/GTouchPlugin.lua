LJ @src/GTouchPlugin.lua� 	  ">	4  %    > T�  7 4   > ? T� T�  7 4   > ? T�  7 4   > ? G  onTouchEndedonTouchMoved
movedccponTouchBegan
began*GTouchPlugin touch event:%s,x:%d,y:%d
cclog	self  #eventType  #x  #y  # �   S'��7    '��' I�7   67	 7>	 7
 >  T	�4 %	 > T�T�4 %	 >K�H not in rectin rect
cclogcontainsPointboundingBoxcard_sprite_all_cards			self   loc   result   index poke_card  �  +�"2  2  4  7 >D�7	 7>	  T�4 7	 
 >BN�7  7>7   T�7 7	7
  T�) T�) 4 74   	 > H lastPlayCardslide_cardCardUtilityg_user_iduser_idlastPlayerisVisibleplay_card_menuinsert
tablegetTagcard_sprite_all_cards
pairs�				










self  ,result *checked_cards )  _ poke_card  is_self_play is_last_card_self 	 N   2  7  >:  ) H getCardIndex
beginself  loc   �  48  7   >4 % 7  >  T�7  T�G  7 	  T�:   7 7  >: G  move_checklast_check
beginbegin:%d, cur_check:%d
ccloggetCardIndex����					
self  loc  cur_check  �  G�E T�G    T�   T� 4  '� '� '� >4  '� '� '	� >7   '��'	 I+�7 
 6
   T�
  T�7 7>  T�7 7 >7 7'�>T�7 7> T
�7 7 >7 7'�>K�G  setTagsetColorgetTagcard_sprite_all_cards	ccc3��					




self  Hstart  Hend_p  Hs Ce ?white 7red 2, , ,index *poke_card ' �  {�e(  7  > '   T#�4 7 >D�7  T	�	  7 
 >BN�4  >D�7  T�	  7 
 >BN�7  7) >  7 >T2�7   '��' I,�7  67		 7
>	 7
 >  T	�7  T�	  7 
 >T�	  7 
 >	  7 >7 	 7  7
 >


 '   
 T
�)
 T�)
 >T�K�4 7 >D�7		 7>  T�7		 74
 '� '� '� >
 =7		 7'
�>BN�'��5 '��5 G  last_check
beginsetTag	ccc3setColorgetTaggetPickedPokeCardscontainsPointboundingBoxcard_spriteplayDealCardEffectsetEnabledmenu_item_reselectpickPokeCardunpickPokeCardpicked_all_cards
pairsgetCheckedCards�			



    !!!!!!"""""""""#####  &&''(self  |loc  |checked_cards x
 
 
_ poke_card  
 
 
_ poke_card  - - -index +poke_card (,  _ poke_card   � 
  >�
2  4  7 >D�7  T�4 7 	 >BN�H insert
tablepicked_all_cards
pairs	self  poke_cards   _ poke_card   � 
 
-�7   T�4 % 7$>7 74  7(  4 '  7		 		> = =) : G  y_ratioccpcreateCCMoveByrunActioncard_sprite
index[pickPokeCard] pick 
cclogpicked��������<self  poke_card   � 
 
-�7   T�4 % 7$>7 74  7(  4 '  7		 		> = =) : G  y_ratioccpcreateCCMoveByrunActioncard_sprite
index[unpickPokeCard] unpick 
cclogpicked������������self  poke_card   � 
  9�4   >D�  7 	 >BN�G  unpickPokeCard
pairsself  poke_cards    _ poke_card   � 
  9�4   >D�  7 	 >BN�G  pickPokeCard
pairsself  poke_cards    _ poke_card   �  *�'��:  '��: 1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 0  �G   pickPokeCards unpickPokeCards unpickPokeCard pickPokeCard getPickedPokeCards onTouchEnded move_check onTouchMoved onTouchBegan getCheckedCards getCardIndex onTouchlast_check
begin-2/@5[B�b������������theClass   B    �2   5   4   1 : 0  �G   	bindGTouchPlugin���  