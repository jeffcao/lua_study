LJ @src/luasocket/smtp.luaÚ  4*7  7  7% > = 7  7  7%  T4 > = +  7' 7  7  7% > =  ? 	skipDOMAIN	EHLOcommand2..
checktptrysocket self  domain       07  7  7% %  $> = 7  7  7% > ?  2..
check
FROM:	MAILcommandtptryself  from      57  7  7% %  $> = 7  7  7% > ?  2..
checkTO:	RCPTcommandtptryself  to     
 $9:7  7  7% > = 7  7  7% > = 7  7  7  > = 7  7  7% > = 7  7  7%	 > ?  2..

.
	sendsource3..
check	DATAcommandtptryself  %src  %step  % v   B7  7  7% > = 7  7  7% > ?  2..
check	QUITcommandtptryself   /   G7   7@ 
closetpself   Ì 	 1PK7  7  7% % > = 7  7  7% > = 7  7  7+  7 > = = 7  7  7% > = 7  7  7+  7 > = = 7  7  7% > ?  2..b643..
check
LOGIN	AUTHcommandtptrymime self  2user  2password  2 Ú 		 ?T%  +  7%  %  $>$7 7  7%  > = 7 7  7% > ?  2..
check	AUTHcommandtptry b64PLAIN mime self  user  password  auth  ¼  %LZ	  T  T' H +  7  % >  T  7   @ T+  7  % >  T  7   @ T7 )  % >G  !authentication not supportedtry
plainAUTH[^
]+PLAIN
loginAUTH[^
]+LOGIN	find	string self  &user  &password  &ext  & Â 
 'Xf
  7  7>+  77> T+  77>T  7 	 >ANúT  7 7>  7 + 777+ 7	> =7
>G   	step
stuff
chainsource	dataipairs
table	rcpt	type	from	mail												
base ltn12 mime self  (mailt  (  i v   .   w+     7   > G  
closes  		 Sr	+  7 + 7  T4  T4 4  > = + 72 :+ >+  71 >: 0  H  	 newtrytpsetmetatableTIMEOUT	PORTSERVERconnecttrysocket tp base metat server  port  create  tp s   	 @~2  +  7   T >T+ 7 >9ANùH  
lower
pairsbase string headers  lower   i v   ¯  '+      ,   +  7   % + 7% >+ 7'  ( >+  @  random%d%m%Y%H%M%S	date%s%05d==%05uformat¾seqno string os math  ¯  B%  +  7  >T % 	 %
   $ANø+ 7 >G   
yield: 
pairs
base coroutine headers  h 	 	 	i v   Ø  Iµ+  >+ 7    T2  >7  T% :7%  % $:+  >7 7  T	+ 77 7>+ 7% >+ 7	7 >T
+ 7%	
 
 % $		>+ 	 >ANô+ 7%
  % $>7 7  T	+ 77 7>+ 7% >G  
 epilogue--

	
--ipairs

yieldpreamble	body"; boundary="multipart/mixedcontent-typeheaders				




newboundary lower_headers send_headers coroutine base send_message mesgt  Jbd Gheaders A  i 
m  
 Ç  #iº+  7    T2  >7  T% :+  >Q7 >  T+ 7)   >Tõ  T+ 7 >TîTTìG  

yield	body%text/plain; charset="iso-8859-1"content-typeheaders								






lower_headers send_headers coroutine mesgt  $headers chunk err   é  KÊ+  7    T2  >7  T% :+  >+ 77 >G  
	body
yield%text/plain; charset="iso-8859-1"content-typeheaderslower_headers send_headers coroutine mesgt  headers  Ù  MÕ+  7 7 > T+   >T+  7 7 > T+   >T+   >G   function
table	body	typebase send_multipart send_source send_string mesgt    	 BÜ+  7  >7  T	+ 7% >7   T4 $:7  T+ 7:% :H 
1.0mime-version_VERSIONx-mailer	ZONE	zone!%a, %d %b %Y %H:%M:%S 	dateheaderslower_headers os socket mesgt  lower  7    é +   + > G        send_message mesgt  x   *ê+   7   + >    T  F T)   F G   resumecoroutine co ret 
a  
b  
  ?æ	+    >:  + 71 >1 0  H   createheadersadjust_headers coroutine send_message mesgt  co 	 ã   ,ô4  7 7 7 > 77 > 77 7  > 7	  > 7
> 7@ 
close	quit	sendpassword	user	authdomain
greetcreate	portserver	openmailt  s ext  º  8 `° ü4   4 % >4 % >4 % >4 % >4 % >4 % >4 % >4 %		 >4	
 %
 >	'	< 5	 %	 5	 '	 5	 7	%
 >	 	 T
%	 5	 %	 5	 2	 2
  :
	7
	1 :
7
	1 :
7
	1 :
7
	1 :
7
	1 :
7
	1! : 
7
	1# :"
7
	1% :$
7
	1' :&
7
	1) :(
1
* 5
+ 1
, '  1- )  1. 1/ 10 11 12 13 14 55 7617 >5( 0  G   protectmessage         	open  	send 	auth 
plain 
login 
close 	quit 	data 	rcpt 	mail 
greet__index	ZONE
-0000DOMAINSERVER_NAMEgetenv	PORTSERVERlocalhostTIMEOUTsocket.smtpmodule	mime
ltn12socket.tpsocketos	mathstringcoroutinerequire_G!!!!!!!##(((*.*030585:@:BEBGIGKRKTXTZcZfpf{r·ÇÒÕäïæôûôûûûbase _coroutine \string Ymath Vos Ssocket Ptp Mltn12 Jmime Gmetat 2lower_headers !seqno newboundary send_message send_headers send_multipart send_source send_string 
adjust_headers   