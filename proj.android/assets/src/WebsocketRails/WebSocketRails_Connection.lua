LJ 1@src/WebsocketRails/WebSocketRails_Connection.lua*   +   + C  ?   ÀÀfn obj  &  1  0  H  fn  obj   û   ?  T2  7    T) 7 4 77 T) T) ::H retry_excceedself_closeCONNECTION_MAX_RETRIESconfigWebSocketRails_connection_retries_self_closeself  data  self_close retry_excceed 	 ¢  A3  ::4    >:  4 77% >  T% 7$:2  :	4 :
 7>H connectwsConnecting
statemessage_queue
ws://wss?://	findstring__indexsetmetatabledispatcherurl  		self  url  dispatcher  this_obj    	 )-4  7  T4  7  T 7>  T)  H 4 % 7 % $ 7> =G  serialize!>.trigger] sending event => url[<
printis_internal_eventdebug_dump_internal_eventdebug_dump_outgoing_eventGlobalSettingself  event   ¤  &67
  7   >7 7 T4 % 7 % $ 7> =4	 7
7 7    >T4  7> 77  7> =G  _websocket_id	sendsharedWebsocketManagerWebsocketManagermessage_queueinsert
tableserialize6>.trigger] websocket not ready. enqueue event => url[<
printconnected
statedispatcherdebug_dump_event
self  'event  '   .YC7   T
4 % 7 % $7  %  >G  4 7  T 7%	 >  T 7%
 >  T4 % 7 % $ >+  7 >7  7 >G  Ànew_messagedispatcherdecode>.on_message] event => "server_ack"websocket_rails.	finddebug_dump_websocket_rawGlobalSetting , event.websocket: <>.on_message] event not own by me, self._websocket_id: url[<
print_websocket_id							json self  /websocket_id  /event  /data ) É  	 9T4  % 7 % $ >7  T
4  % 7 % $7 %  >G    7 >'  : G  _connection_retriescancel_connection_timout , event.websocket: 9>.on_open] event not own by me, self._websocket_id: _websocket_id>.on_open] url[<
print		self  websocket_id  event   3   r+     7   > G   Àconnectself  
Ea4  % 7 % $ >7  T
4  % 7 % $7 %  >0 0)  4 7 7	3
 +    2	  > <  > 7  7 >7 % :7   T7 4 77 T  7 >7 4  %  % >4 7 1 >0  G  G  À add_timer
Timer seconds.1connection broken, start to reconnect after cancel_connection_timoutCONNECTION_MAX_RETRIESconfig_connection_retries_self_closeclosed
statedispatchdispatcher  connection_closednew
EventWebSocketRails , event.websocket: :>.on_close] event not own by me, self._websocket_id: _websocket_id>.on_close] url[<
printÀ												




wrap_err self  Ewebsocket_id  Eevent  Eclose_event /delay_seconds #
 4   +     7   > G   Àconnectself  µHy4  % 7 % $ >7  T
4  % 7 % $7 %  >0 3* 
  T74 7	 7
3 +  	  
 > <  > 7  7 >7 % :7   T7 4 77 T  7 >7 4  %  %	 >4 7 1 >0  G  G  À add_timer
Timer seconds.0connection error, start to reconnect after cancel_connection_timoutCONNECTION_MAX_RETRIESconfig_connection_retries_self_closeclosed
statedispatchdispatcher  connection_errornew
EventWebSocketRails	data , event.websocket: :>.on_error] event not own by me, self._websocket_id: _websocket_id>.on_error] url[<
printÀ

wrap_err self  Hwebsocket_id  Hevent  Herror_event 2error_data  2delay_seconds &
 ­  	 C	)  4  7 >T4  7> 77	  7
>
 =ANó7  '   TQ4 77 >TõG  remove
tableserialize_websocket_id	sendsharedWebsocketManagerWebsocketManagermessage_queueipairs	self  event   _ event   À 9{¢  T'   T2  4   >D,4	 4
 7

%  >
 $

 4  > =	+	  7			 T	4	 %
  %  >	)	  9	4	 
 >			 T	6		  T		)	 9	
  7	
    >	9	)	 9	BNÒH Àfix_json_data
table is lightuserdata : 
key: 	null	type  repstring
print
pairs







json self  :the_table  :level  :fixed_objects  :
/ / /k ,v  , ÷  	 )¶ T) :  4 % 7 % $7  >4  7> 77 >G  _websocket_id
closesharedWebsocketManagerWebsocketManager">.close] self._self_close => url[<
print_self_closeself  self_close   s  
¼7    T4 7 >'  :  G  cancel_timer
Timer_connect_timeout self  handle 	 Ü   0â+   '  :  4  % 4 77% + % > 4    7 	 >   7 
 +  7> +     7  > G   ÀÀconnect_websocket_id
closesharedWebsocketManagerWebsocketManager	 ... sec. retry CONNECTION_TIMEOUTconfigWebSocketRails#****ERROR: connect timeout in 
print_connect_timeoutself reconnect_times  
%hÅ$7    T'  :  7  4 77 T&4 : 4 % 7 %	 4 77%
 >4  7> 77 >'  : 4 7 73 3 ;>7  7 >7 % :0 67   :  7 % :4 : 4  7> 77 +  7   >+  7   >+  7   >+  7 	  > =: 4 4 7% 7 > = 7  4! 7"4 77#  T' 1$ >:  0  G  G   À CONNECTION_TIMEOUTadd_timer
Timer_connect_timeoutself._websocket_id => %dformatstringon_erroron_messageon_closeon_openconnectwsConnectingconnectingcloseddispatchdispatcher messageConnection failed!  connection_errornew
Event_websocket_id
closesharedWebsocketManagerWebsocketManagerretries !!!!! after url%****ERROR: failed to connect to 
printwsClosed
stateCONNECTION_MAX_RETRIESconfigWebSocketRails_connection_retries







""$$$__bind self  herror_event )	reconnect_times 2 È   'C ë4      T2   5   1  1 4 % >4  3 1 :1	 :
1 :1 :1 :1 :1 :1 :1 :1 :1 :1 ::0  G  connect cancel_connection_timout 
close fix_json_data flush_queue on_error on_close on_open on_message trigger debug_dump_event new  MAX_CONNECTION_RETRIES
WebSocketConnection
cjsonrequire  WebSocketRails	++55AARR__ww  ´´ººÂÂééëëë__bind !wrap_err  json   