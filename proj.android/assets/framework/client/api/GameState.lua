LJ #@framework/client/api/GameState.lua  '4  7  ' 4  7+  > =+   T) T) H ÀlensubstringencodeSign contents   É  U+  7   >+ 7 + $>+  7 3 ::>+  $H ÀÀÀsh  md5encodejson crypto secretKey encodeSign values  s hash 
contents  · 	@©4  7  4  7+  > >+ 7 >4  > T4 % >3	 + 7:
H 77+ 7 + $> T4 % >3 + 7:
H + 7 >4  > T4 % >3 + 7:
H 3 :H ÀÀ ÀÀvalues    -GameState.decode_() - invalid state data  ERROR_HASH_MISS_MATCH*GameState.decode_() - hash miss matchmd5sherrorCode   ERROR_INVALID_FILE_CONTENTS+GameState.decode_() - invalid contentsechoError
table	typedecodelensubstring		





encodeSign json GameState crypto secretKey fileContents  Acontents 
7j 3hash $s  $testHash values  ¶ 	 )64    > T4 % >) H ,   4   > T, 4   > T, +  3 + 7>:4  + > T) T) :>) H  ÀencodefilenamegetGameStatePath 	name	initstring-GameState.init() - invalid eventListenerechoErrorfunction	type	eventListener stateFilename secretKey GameState eventListener_  *stateFilename_  *secretKey_  * Ô   O¾O$+   7   > 4 7  >  T
4 %   >+ 3 +  7:@ 4 7  >4 %	   >)  ) +   T+  >  T+  >7  T+ 3
 7:@ 7) T+ 7 > 4  > T	4 % >+ 3 +  7:@ + 3 ::4 7>:@  ÀÀ	ÀÀ	timeosencode 	name	load ERROR_INVALID_FILE_CONTENTS 	name	load$GameState.load() - invalid dataechoError
table	typedecodevalues 	name	load,GameState.load() - get values from "%s"readfileerrorCodeERROR_STATE_FILE_NOT_FOUND 	name	load+GameState.load() - file "%s" not foundechoInfoexistsiogetGameStatePath				 !""""#GameState eventListener secretKey isEncodedContents_ decode_ json filename Lcontents 8values 3encode 2d 
 È  ;u+  3  : 4 + > T) T) :>4  > T4 % >) H + 7>) +   T	4	 7
 +  > = T+ 7 >4  > T4	 7
  > 4 %  >H  ÀÀÀ(GameState.save() - update file "%s"echoInfowritefileiogetGameStatePath4GameState.save() - listener return invalid dataechoError
tableencodestring	typevalues 	name	saveeventListener secretKey GameState encode_ json newValues  <values .filename !ret  s     4   7  4 7% % > % +  $  H  /[\\/]+$documentsPathdevice	gsubstringstateFilename  Õ    2   'ÿÿ:  'þÿ: 'ýÿ: 4 % >4 % >% % * 1 1	 1	
 1
 :
 1
 :
 1
 :
 1
 :
 0  H   getGameStatePath 	save 	load 	init   state.txt	=QP=framework.shared.jsonframework.client.cryptorequireERROR_STATE_FILE_NOT_FOUNDERROR_HASH_MISS_MATCH ERROR_INVALID_FILE_CONTENTS			2M6sOuGameState crypto 	json encodeSign stateFilename eventListener secretKey  isEncodedContents_ encode_ decode_ 
  