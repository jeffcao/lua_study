LJ @src/GServerMsgPlugin.lua   m|
24   % >7   T	4 7>: 7  77 >77  T4	 %
 >G    7  >  7  >  7 7>7'   T'  :  7  ) >  7 7 'ÿÿ>  7 7 'ÿÿ>  7 7 'ÿÿ>77 7 T  7 7 ' >  7 ' )  >T77 7 T
  7 7 ' >  7 ' )  >  7 >4	 % >  7 ) >7  7 >G  onServerStartGamesetHasGamingStarted%onServerStartGame gaming to trueplayDeliverCardsEffectstartPrevUserAlarmprev_userstartNextUserAlarmnext_usernext_user_idnext_user_lord_valueprev_user_lord_valueself_user_lord_valueupdateLordValueshowGrabLordMenulord_valuegrab_lordplayersupdatePlayersdrawPokeCardsreset_all'[game_start] not my cards, return.
cclogg_user_iduser_idrootNode	initnewCardRoboter2card_roboter[game_start] data -> 	dump



"""""#####$$$$$$%%%%%'''''(((((+++...////111112self  ndata  n W   G4   % > +     7  > G   	exitdo not auto ready
cclogself  á  0??4  % >7  T(4  % 7 >7   T4 % >  7 >  7 7>  7	 ' 1
 >7  7) >7  7) >T4 % >  7 7>0  G  updatePlayersä¸è¬çjoin notifymenu_huanzhuosetVisiblemenu_ready startSelfUserAlarmreset_allstopUserAlarmæµå±çjoin notify
cclog_has_gaming_started_has_gaming_started:playersonServerPlayerJoin
printself  1data  1 À   .V4  % 7$>4 7 >4 7> T4 % >  7 >T
4 % >7	  T  7
 7	>G  updatePlayersplayers/å¶ä»ç¨æ·è¢«è¸¢åºæ¿é´ï¼å·æ°çé¢	exitè¢«è¸¢åºæ¿é´
cclogg_user_idtonumberuser_idonServerLeave 
printself   data    º 	 & ¿dM4  % >% 4 % >  7 >  7 7>77	  T 2  7	 :
4 7% >4 77  >7 :'  :7:  7  >  7 ) >  7 77>T  7 7 7 7>  7 7 7 7>  7 7 7 7>7'    T7 7
 T7 7T	7 7
 T7 7T7 74 %  $>  7   ) >7!7	  T2  7	 :
7:7:  7"  >TH7'   T%  7 7 'ÿÿ>  7 7 'ÿÿ>  7 7 'ÿÿ>77 7
 T  7# ' )  >T  7$ ' )  >  7 77>T7!7 7
 T  7 7 ' >  7# ' )  >T7!7 7
 T
  7 7 ' >  7$ ' )  >  7% ) >G  setHasGamingStartedstartPrevUserAlarmstartNextUserAlarmshowGrabLordMenunext_user_idplayGrabLordEffectgrab_lord: value is prev_lord_user_idnext_usernext_user_lord_valueprev_userprev_user_lord_valueself_userself_user_lord_valueupdateLordValuelord_valueshowLordCardsshowPlayCardMenuonServerStartGamegrab_lordpoke_cards_all_cards_idscombine
table,lord_cards
splituser_idg_user_idlord_user_idplayersupdatePlayershideGetLordMenu%hide the get lord menu firstly! 
cclog[onServerGrabLordNotify] onServerGrabLordNotify
print				  !!!!"""####$$$&&((((()))))....0112233444445555777778888899999;;;;;<<<<<<>>>>>@@@@@@CCCCCDDDDDEEEEEEFFFFFGGGGGHHHHHLLLLMself  Àdata  Àlog_prefix »new_data loard_ids prev ,uvalue tnew_data !
 ã  Bü´n4  % >4  % >  7 7>  7 >7 
  T7 77	 T  7
 7 ) >  7
 7 ) >  7
 7 ) >4 7	>2  4 7% >4  >D4
 7

	 >

 '   T4 7 4 7
 > =BNî4 %  $>4  % >4 7 >7 7 T7 :T7  7 T7  :4 %! 7" 77	 7		7
  7

7#  >4 %$ 7%$>7#  T4 %& >  7'  >7(  7 >7)   T|)  7#  T/4  %* 
  7	+ >	%
, 7-  7.> =4 %/ >  70 )	 >  71 	 )
 >7" 72	  T	  7+ >  T  73 )	 >  74 '	 )
  >  7
 7	 )
 >G  7 7 T 4 %5 >7   76 	 >  7+ >  T%  70 )	 >77   T  78 7	7 >)  :7   7
 7	 )
 >T4 %9 >7    7: 	 >  7; '	 )
  >  7
 7	 )
 >7<'  T '   T  7= 7	<7
>
  T
)
 T)
 >T4 %? >  7@ >  7A >G  updatePlayerPokeCounts	exit#is not playing, return to hallgenderplayCardTipspoke_card_countstartPrevUserAlarmdoNextUserPlayCardis next user play cardreset_cardlastCarddoPrevUserPlayCardis prev user play cardstartNextUserAlarmdoTuoguantuo_guandoChupaishowPlayCardMenu$hide play card menu firstlynot isVisibleplay_card_menu, is menu show?isTuoguan(hide play is self card, is tuoguan?_is_playingcard_roboterplayCardEffectplayCardEffect not selfcard_type[onPlayCard] card.type => g_user_idself_user0ids, self:%d,prev:%d,next:%d,g:%d,player:%dnext_user
ownerprev_usergetCardCardUtility [onPlayCard] poke_cards => '[onPlayCard] poke_cards.length => 
ccloggetCardByIdPokeCardinsert
table	trimstring
pairs,poke_cards
splittonumbernext_user_lord_valueprev_user_lord_valueself_user_lord_valueupdatePlayerBuchuplayer_iduser_idlastPlayerupdateTuoguanplayersretrievePlayers [onServerPlayCard] data => 	dumponServerPlayCard
print					




  """""""""""#####$$$%%%&&&&(((((***+...000000000002223333444445555555556666?????AAAAABEEEEFFFGIIIIKKKKKMMMMOOOPPPPQQVVVVVWYYYZ\\\\^^^^^`````bbbbbbbbccccccccccdfffgggkkknself  data  the_player_id )Ýpoke_cards Üpoke_card_ids Ø  _ poke_card_id  tmp_id card µplayer 0z °   -<¥4  % >) : 4 % >  7 ) >  7  >  7 7 ) >7	   T  7 7	 7
) >7   T  7 7 7
) >7  7 >G  card_roboternext_useruser_idprev_userg_user_iddoGetUserProfileIfNeedshowGameOversetHasGamingStarted%onServerGameOver gaming to false
cclog_is_playingonServerGameOver
print						self  .data  . ¼ 	 
 >·4  % >)  77   T7 7 T7 T
7   T7 7 T7 T7   7 7	  >G  msgdisplayChatMessageself_liaotianprev_liaotianprev_usernext_liaotiannext_useruser_idonServerChatMessage
print
self   message   layer id  þ  ,¾1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 0  G   onServerChatMessage onServerGameOver onServerPlayCard onServerGrabLordNotify onServerLeave onServerPlayerJoin onServerStartGame5  L 8 Z O ª ] ­ -=0>>theClass   M    Å2   5   4   1 : 0  G   	bindGServerMsgPlugin   E EE  