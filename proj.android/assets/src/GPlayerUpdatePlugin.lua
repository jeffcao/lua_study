LJ @src/GPlayerUpdatePlugin.luaÚ  	 5  T  7   >  7 >  7 >  7 >  7 >  7 >  7 >  7 >  7 >G  updatePlayerLevelsupdatePlayerAvatarsupdatePlayerPokeCountsupdatePlayerRolesupdatePlayerStatesupdatePlayerNamesupdateTuoguanupdateReadyretrievePlayers			


self   player_list    ¾   1@)  7    T7 4 7  7>6  7  7 7 >)  7   T7 4 7 7>6  7  7 7	 >)  7
   T7 4 7
 7>6  7  7 7 >G  next_level_spritenext_level_layernext_userprev_level_spriteprev_level_layerprev_userself_level_spriteself_level_layerupdatePlayerLeveluser_idtostring
usersself_user						self  2info 0 Ê   M'  T7   T	 7) >4  7 >T 7) >G  set_level_spritesetVisiblegame_levelself  info  player_level_layer  player_level_sprite     1907    T7  7	  T7  7'   T4 % >7  7>  T4 % >7  7) >T4	 7 %
 >7  7>  T4 % >7  7) >G  hide tuoguanis not tuoguan status	dumpsetVisibleshow tuoguanisVisiblemenu_tuoguanis tuoguan status
cclogpoke_card_counttuo_guanself_user						


self  2 ¾   @  7  7 7 >  7  7 7 >  7  7 7 >G  next_user_namenext_userprev_user_nameprev_userself_user_nameself_userupdatePlayerNameself      =F  T7  7 >T 7% >G  setStringnick_nameself  player  player_name_ui  player_name  ×   'O  7  7 7 >  7  7 7 >  7  7 7 >  7 7 7 >  7 7 7	 >  7 7 7
 >G  next_user_prepareprev_user_prepareself_user_prepareupdatePlayerPreparenext_user_statenext_userprev_user_stateprev_userself_user_stateself_userupdatePlayerStateself    é  VY  TS4   T7	  T7  7>  T7  7) >7  7) >  7 >4   T74  7>  T14   T.7	  T+4 %	 >7  7) >  7
 >7  7>7  7>4 %  % 	 %
 $
>7  7>  T
	 T	 T4 % >  7 >G  stop user alarm), alarm position:(getPositionYgetPositionX
alarmreset_allRæå¡å¨èªå¨åå¤ï¼è¦éèæ¸¸æç»æå¯¹è¯æ¡ï¼å¹¶resetææçç
ccloggame_over_layerstopUserAlarmmenu_huanzhuosetVisibleisVisiblemenu_ready
stateself_userÈ			




self  Wplayer  Wplayer_state_ui  Wx :y  Ç  4q  T7 	  T7	 T 7) >T	 7>  T 7) >G  isVisiblesetVisiblepoke_card_count
state self  player  player_ui   Í   y  7  7 7 ) >  7  7 7 ) >  7  7 7 ) >G  next_user_rolenext_userprev_user_roleprev_userself_user_roleself_userupdatePlayerRoleself   Á  I  T7   T7 7  T 7) >G  4 % 7 $>4  7> 7% >4  7> 7%	 >7 7  T 7
 >T 7
 > 74 7> 74 '	  (
  > =7 7  T 7 > 7) >G  setFlipXccpsetAnchorPointcontent_scale_factorGlobalSettingsetScalesetDisplayFramerole_lord.pngrole_farmer.pngspriteFrameByNamesharedSpriteFrameCacheCCSpriteFrameCache.[updatePlayerRole] player.player_role => 
cclogsetVisibleROLE_FARMERplayer_roleÿ								self  Jplayer  Jrole_ui  Jflip_x  JfarmerFrame .lordFrame &   
   7  7 7 7 >  7  7 7 7 >  7  7 7 7	 >G  next_user_card_tagnext_user_poke_countnext_userprev_user_card_tagprev_user_poke_countprev_userself_user_card_tagself_user_poke_countself_userupdatePlayerPokeCountself   ¬   $a  T7 '   T 7>  T 7) > 7% 7 $>T 7>  T 7) > 7% >G  setStringsetVisibleisVisiblepoke_card_count



self  %player  %player_poke_count_ui  %player_card_tag_ui  %   
 ¬  7  7 7 7 >  7  7 7 7 >  7  7 7 7	 >G  next_user_avatar_bgnext_user_avatarnext_userprev_user_avatar_bgprev_user_avatarprev_userself_user_avatar_bgself_user_avatarself_userupdatePlayerAvatarself   ¹   6{²)    T 7 >  T 7) > 7 >  T$ 7) >T 7 >  T 7) > 7 >  T 7) >4 7 >  7 > 7 >G  setSelectedSpriteFramesetNormalSpriteFramegetUserAvatarFrameAvatarsetVisibleisVisible




self  7player  7player_avatar_ui  7player_avatar_bg  7avatarFrame 5  	  @Ì	  T 7 ) >G  4  7> 7 7% > = 7 ) >G  info_buchu.pngspriteFrameByNamesetDisplayFramesharedSpriteFrameCacheCCSpriteFrameCachesetVisible	self  buchu_ui  bBuchu  frameCache  >   ×7   7@ isVisiblemenu_tuoguanself    " $0Ù1 :  1 : 1 : 1 : 1	 : 1 :
 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1 : 1! :  0  G   isTuoguan updatePlayerBuchu updatePlayerAvatar updatePlayerAvatars updatePlayerPokeCount updatePlayerPokeCounts updatePlayerRole updatePlayerRoles updatePlayerPrepare updatePlayerState updatePlayerStates updatePlayerName updatePlayerNames updateTuoguan updatePlayerLevel updatePlayerLevels updatePlayers"+$;-A=JCTLlVtnzv|§­©Ã¯ÒÉÖÔÙÙtheClass  % I    Ü2   5   4   1 : 0  G   	bindGPlayerUpdatePluginÜÜÜ  