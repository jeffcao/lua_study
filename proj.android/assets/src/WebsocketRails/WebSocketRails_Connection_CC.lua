LJ 4@src/WebsocketRails/WebSocketRails_Connection_CC.lua*   +   + C  ?   ��fn obj  &  1  0  �H  fn  obj   �   ?  T�2  7    T�) 7 4 77 T�) T�) ::H retry_excceedself_closeCONNECTION_MAX_RETRIESconfigWebSocketRails_connection_retries_self_closeself  data  self_close retry_excceed 	 �  C2 : :4    >:  4 77 % >  T�% 7 $: 2  :4
 :	)  : 7>H connectwebsocketwsConnecting
statemessage_queue
ws://wss?://	findstring__indexsetmetatabledispatcherurl		self  url  dispatcher  this_obj  �  	 )/4  7  T�4  7  T� 7>  T�)  H 4 % 7 % $ 7> =G  serialize!>.trigger] sending event => url[<
printis_internal_eventdebug_dump_internal_eventdebug_dump_outgoing_eventGlobalSettingself  event   �  %59  7   >7 7 T�7   T�4 % 7 % $ 7	> =4
 77 7    >T�7  7 7	> =G  sendTextMsgmessage_queueinsert
tableserialize6>.trigger] websocket not ready. enqueue event => url[<
printwebsocketconnected
statedispatcherdebug_dump_eventself  &event  & �  !=F4  7  T� 7% >  T� 7% >  T�4 % 7 % $ >+  7	 >7
  7 >G  �new_messagedispatcherdecode>.on_message] event => url[<
print"server_ack"websocket_rails.	finddebug_dump_websocket_rawGlobalSettingjson self  "event  "data  �   V4  % 7 % $ >  7 >'  : G  _connection_retriescancel_connection_timout>.on_open] url[<
print		self  event   3   t+     7   > G   �connectself  �	7nc4  % 7 % $ >)  4 7 73 +    2  > <  > 7  7	 >7 % :
7   T�7 4 77 T�  7 >7 4  %  % >4 7 1 >0  �G  � add_timer
Timer seconds.1connection broken, start to reconnect after cancel_connection_timoutCONNECTION_MAX_RETRIESconfig_connection_retries_self_closeclosed
statedispatchdispatcher  connection_closednew
EventWebSocketRails>.on_close] url[<
print����												




wrap_err self  8event  8close_event 	/delay_seconds #
 4   �+     7   > G   �connectself  �
:~{4  % 7 % $ >* 
  T�74 7 73 +    	 > <  > 7	  7
 >7	 % :7   T�7 4 77 T�  7 >7 4  %  % >4 7 1 >0  �G  � add_timer
Timer seconds.0connection error, start to reconnect after cancel_connection_timoutCONNECTION_MAX_RETRIESconfig_connection_retries_self_closeclosed
statedispatchdispatcher  connection_errornew
EventWebSocketRails	data>.on_error] url[<
print����	

wrap_err self  ;event  ;error_event 	2error_data  2delay_seconds &
 �   B�)  7  
  T�4 7 >T�7   7
 7	>	 =AN�7  '   T�Q�4 77 >T�G  remove
tableserializesendTextMsgmessage_queueipairswebsocket					self  event 
 
 
_ event   � 9{�  T�'   T�2  4   >D,�4	 4
 7

%  >
 $

 4  > =	+	  7			 T	�4	 %
  %  >	)	  9	4	 
 >			 T	�6		  T		�)	 9	
  7	
    >	9	)	 9	BN�H �fix_json_data
table is lightuserdata : 
key: 	null	type  repstring
print
pairs







json self  :the_table  :level  :fixed_objects  :
/ / /k ,v  , �   -� T�) :  4 % 7 % $7  >  7 >7 
  T�7  7>)  : G  
closewebsocketunbind_websocket_handlers">.close] self._self_close => url[<
print_self_closeself  self_close   s  
�7    T�4 7 >'  :  G  cancel_timer
Timer_connect_timeout self  handle 	 � 
 (7�7  
  T$�7   7+  7   >4 >7   7+  7   >4 >7   7+  7   >4 >7   7+  7   >4	 >G   �!kWebSocketScriptHandlerErroron_error!kWebSocketScriptHandlerCloseon_close#kWebSocketScriptHandlerMessageon_message kWebSocketScriptHandlerOpenon_openregisterScriptHandlerwebsocket__bind self  ) �    �7  
  T�7   74 >7   74 >7   74 >7   74 >G  !kWebSocketScriptHandlerError!kWebSocketScriptHandlerClose#kWebSocketScriptHandlerMessage kWebSocketScriptHandlerOpenunregisterScriptHandlerwebsocketself   �  
 +�+   '  :  4  % 4 77% + % > +     7  > +     7 	 > G   ��connect
close	 ... sec. retry CONNECTION_TIMEOUTconfigWebSocketRails#****ERROR: connect timeout in 
print_connect_timeoutself reconnect_times  �O��#7    T�'  :  7  4 77 T$�4 : 4 % 7 %	 4 77%
 >  7 >'  : 4 7 73 +    3 > <  >7  7 >7 % :0 �7  :  7 % :4 : 4  77 >:   7 >7  4 74 77  T�' 1 >: 0  �G  G  � CONNECTION_TIMEOUTadd_timer
Timer_connect_timeoutbind_websocket_handlerscreateWebSocketwebsocketwsConnectingconnectingcloseddispatchdispatcher messageConnection failed!  connection_errornew
Event_websocket_id
closeretries !!!!!> after url&****ERROR: failed to connect to <
printwsClosed
stateCONNECTION_MAX_RETRIESconfigWebSocketRails_connection_retries����










!!###wrap_err self  Perror_event '	reconnect_times  �  # +r �4      T�2   5   1  1 4 % >4  3 1 :1	 :
1 :1 :1 :1 :1 :1 :1 :1 :1 :1 :1 : 1! :":0  �G  connect unbind_websocket_handlers bind_websocket_handlers cancel_connection_timout 
close fix_json_data flush_queue on_error on_close on_open on_message trigger debug_dump_event new  MAX_CONNECTION_RETRIES
WebSocketConnectionCC
cjsonrequire  WebSocketRails     	       - - 7 7 D D T T a a y y � � � � � � � � � � � � � � __bind %wrap_err $json !  