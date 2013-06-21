package com.tblin.DDZ2;

public class DDZJniHelper {
public static native void messageCpp(String str);
public static void onCppMessage(String str){
	System.out.println("onCppMessage: " + str);
}
}
