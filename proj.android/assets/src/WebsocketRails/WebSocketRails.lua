LJ &@src/WebsocketRails/WebSocketRails.luaò   .X(2  4     >:  :) :
  T
 T) T) :% :2  :2  :2  :2  :	4 77:
) :) :2  :4 7 7  >:H newWebSocketConnectionCC
_conn_event_queue_pause_self_closeINVALIDSessionStateWebSocketRailssession_staterequest_event_queue
queuechannelscallbacksconnecting
stateuse_websocketsurl__indexsetmetatableself  /url  /use_websockets  /this_obj - U   D4  % >'ÿÿ: G  last_notify_idclear_notify_id
cclogself   N   I4  % >7 H last_notify_idget_notify_id
cclogself   å  1íöNN2  4   >T4 77	 7
 

 
 
 >ANö7   TH 7  '   TÔQÓ7 84 77 ' >4 7 7 >4	 7
  T 7>  T 7>  T	4 % 7 % $ 7> =7   T'ÿÿ)  4  > T '   T4 8> T8 '  T887  T
4 887> T) T)   T8877  T	 T: 4 %	 
  >T  T4 %	 
  >G  	 7>5 4 
  T7 	 74
 >	 7>  T	7 7	6	
  T	
 7	 7!7>	7	 7
)  9
	T3	 7">  T		  7# 
 >T)	 7>  T		  7$ >T 	 7>  T	7  T	77%  T	7& 7	7	%	6	7	& 7
7
%
)  9
	  T		4	' 7	(	7
)>	T	  7* 
 >7+ , T7+ - T7./ T4 7	 
 
 
  70 7> =T/4 7	 
 
 
'  >T'H connection_establishedclient_connected	nameclosedconnecting
statedispatchtimer_handlercancel_timer
Timerrequest_event_queueack_id	pongdispatch_channelis_channelsuccessrun_callbackid
queueis_resulttrigger
_connack_eventnew_client_ack_event=current notify id %d is not bigger than last notify id%d#change notify id from %d to %d
cclognotify_id	data	typelast_notify_idserialize] got event => url[
printis_server_ackis_pingdebug_dump_websocket_eventGlobalSettingnew
EventWebSocketRailsremove_pause_event_queueinsert
tableipairs      !!"""""#&&&&'''(((((+++++---//4444466666777778888899999::::;;;;;<<<<<<<====>>>>>??@@@@BDDDDGGGGGGGGGHHHHHHHHHHHJJJJJJJKMself  îdata  îresults ì  _ ev  socket_message Ðevent Ålast_notify_id ªcur_id ©has_notify_id "_ref -req_event / ®   !0% :  7: 4 77: 7  77>  7	 >2  :
 4 7 > T	4 % 7 % $>7  @ G  2>.connection_established] invoke self.on_openurl[WebSocketRails<
printfunctionon_open	typerequest_event_queuereset_channelsflush_queue
_connSESSTION_CONNECTEDSessionStateWebSocketRailssession_stateconnection_idconnected
state			self  "data  " ¢  3«7  6  T7  2  94 77  67  6   >7  H insert
tablecallbacksself  event_name  callback   ä   \³)  4  7 72 ;;7	 ;		 
 >   7  @ trigger_eventconnection_idnew
EventWebSocketRailsself  event_name  data  success_callback  failure_callback  event  ô  (VÃ+   7   + 6  +  , + 4 77 T   T+  7 T	   T+  7 + )  9) H 7 7+ :+  7	 7
7 >) H  trigger
_connretries	data
eventconnected
stateEVENT_MAX_RESENDconfigWebSocketRailsrequest_event_queue				





self event_id resend_times pending_request $    0Z»4  %  7>$>7 76  T4  % 7% 4 7> =7 797 72 :	97'  7 764 74 771 >:
0 7  7 0  @ trigger
_conn EVENT_RESEND_TIMEFRAMEconfigWebSocketRailsadd_repeat_timer
Timertimer_handler
eventrequest_event_queue	type  :[WebSocketRails:trigger_event] store event into queueid
queueserialize-[WebSocketRails:trigger_event] event => 
printself  1event  1event_id resend_times  ï  SÔ7  76  TG  7  762  4  >T	4	 7		
    7> =	ANõH 	datainsert
tableipairs	namecallbacksself  event  _ref 
results   _ 	callback  	    %â
7  76  TG   777@ 	data	namedispatchchannelchannels					self  event  channel  Ð   Yî7  6  T4 7 7   )	 
  > 7  9H newChannelWebSocketRailschannelsself  channel_name  success_callback  failure_callback  channel  Ð   Y÷7  6  T4 7 7   )	 
  > 7  9H newChannelWebSocketRailschannelsself  channel_name  success_callback  failure_callback  channel  +   2  :  G  channelsself   ¹   $4  7 73 2  ;7 ;>7  7 @ trigger
_connconnection_id  websocket_rails.pongnew
EventWebSocketRailsself  pong_event  j   
) :  7  7) >% : G  closed
state
close
_conn_self_closeself   ,   :  G  _pauseself  pause   ù  % 9s 2  3  : 5  4  3 : 4  1 : 4  1 : 4  1
 :	 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1 : 4  1  : 4  1" :! 4  1$ :# 0  G   pause_event 
close 	pong reset_channels subscribe_private subscribe dispatch_channel dispatch trigger_event trigger 	bind connection_established new_message get_notify_id clear_notify_id new SESSION_VERIFEDSESSION_OPENSESSION_INVALID SESSION_DISCONNECTEDSESSION_CLOSEDSESSION_CONNECTEDSESSION_RECONNECTINGSessionStateWebSocketRailsconfig EVENT_RESEND_TIMEFRAMEEVENT_MAX_RESENDCONNECTION_MAX_RETRIESPING_PONG_TIMEFRAME(CONNECTION_TIMEOUTLOGIN_RETRY_TIMEFRAMELOGIN_MAX_RETRIES      % ( B ( D G D I L I N  N  ©  « ± « ³ ¹ ³ » Ò » Ô à Ô â ì â î õ î ÷ þ ÷   

  